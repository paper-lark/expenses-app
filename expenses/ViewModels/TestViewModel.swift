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
import SwiftUI

class TestViewModel: ObservableObject {
    let moc: NSManagedObjectContext
    @Published var accounts: [AccountModel] = []
    @Published var error: CoreDataPublisherError?
    private var cancellables = [AnyCancellable]()

    init(context: NSManagedObjectContext) {
        self.moc = context
        CoreDataPublisher<Account>(context: context)
            .map { $0.map { $0.toModel() } }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in
                    switch $0 {
                    case .finished:
                        print("Publisher completed in VM")
                    case .failure(let err):
                        print("Error occurred in VM")
                        self?.error = err
                    }
                },
                receiveValue: { [weak self] in
                    print("Models updated in VM")
                    self?.accounts = $0
                }
            )
            .store(in: &cancellables)
    }
}
