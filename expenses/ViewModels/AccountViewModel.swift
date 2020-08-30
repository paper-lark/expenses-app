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

class AccountViewModel: ObservableObject {
    private let moc: NSManagedObjectContext
    private var cancellables = [AnyCancellable]()
    @Published var accounts: [AccountModel] = []
    @Published var account: AccountModel
    @Published var isEditingAccount = false
    @Published var shouldDismissView = false

    init(context: NSManagedObjectContext, account acc: AccountModel) {
        print("AccountScreenViewModel created")
        moc = context
        account = acc
        CoreDataPublisher<Account>(context: context)
            .map { $0.map { $0.toModel() } }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    guard let sself = self else {
                        return
                    }
                    sself.shouldDismissView = true
                },
                receiveValue: { [weak self] accounts in
                    guard let sself = self else {
                        return
                    }
                    sself.accounts = accounts
                    guard let acc = accounts.first(where: { $0.id == sself.account.id }) else {
                        sself.shouldDismissView = true
                        return
                    }
                    sself.account = acc
                }
            )
            .store(in: &cancellables)
    }

    deinit {
        print("AccountScreenViewModel disposed")
    }

    func editAccount() {
        isEditingAccount = true
    }
}
