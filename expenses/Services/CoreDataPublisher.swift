//  Expenses app. Tracks income and expenses based on double-entry bookkeeping system.
//  Copyright (C) 2020  Zhuravskii Maskim <paperlark@yandex.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import Combine
import CoreData
import Foundation

enum CoreDataPublisherError: Error {
    case badResponse
    case requestFailed(Error)
}

class CoreDataPublisher<Entity: NSManagedObject>: NSObject, Publisher,
    NSFetchedResultsControllerDelegate
{
    typealias Output = [Entity]
    typealias Failure = CoreDataPublisherError

    private class Inner: Subscription {
        private var fetchPublisher: CoreDataPublisher?
        private var cancellable: AnyCancellable?

        @discardableResult
        init(
            fetchPublisher publisher: CoreDataPublisher, subscriber: AnySubscriber<Output, Failure>
        ) {
            fetchPublisher = publisher
            subscriber.receive(subscription: self)
            cancellable = publisher.subject.sink(
                receiveCompletion: { subscriber.receive(completion: $0) },
                receiveValue: { _ = subscriber.receive($0) }
            )
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            cancellable?.cancel()
            cancellable = nil
            fetchPublisher = nil
        }
    }

    private let moc: NSManagedObjectContext
    private let subject: CurrentValueSubject<[Entity], Failure>
    private var controller: NSFetchedResultsController<Entity>

    init(context: NSManagedObjectContext, request: NSFetchRequest<Entity>) {
        if request.sortDescriptors == nil {
            request.sortDescriptors = []
        }
        moc = context
        controller = NSFetchedResultsController<Entity>(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        subject = CurrentValueSubject([])
        super.init()
        controller.delegate = self
    }

    convenience init(context: NSManagedObjectContext) {
        self.init(
            context: context,
            request: NSFetchRequest<Entity>.init(entityName: Entity.entity().name ?? ""))
    }

    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        do {
            try controller.performFetch()
            guard let result = controller.fetchedObjects else {
                subject.send(completion: .failure(CoreDataPublisherError.badResponse))
                return
            }
            subject.send(result)
        } catch let error {
            subject.send(completion: .failure(.requestFailed(error)))
        }

        Inner(fetchPublisher: self, subscriber: AnySubscriber(subscriber))
    }

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        guard let result = controller.fetchedObjects as? [Entity] else {
            subject.send(completion: .failure(.badResponse))
            return
        }
        subject.send(result)
    }
}
