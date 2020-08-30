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

class AccountsViewModel: ObservableObject {
    private let moc: NSManagedObjectContext
    private var cancellables = [AnyCancellable]()
    @Published var selectedType = AccountType.asset
    @Published var isAddingAccount = false
    @Published var isAddingTransaction = false
    @Published var accounts: [AccountModel] = []
    @Published private(set) var accountIDsToDelete: [UUID] = []
    @Published var isDeletingAccounts: Bool = false

    init(context: NSManagedObjectContext) {
        print("AccountsScreenViewModel created")
        moc = context
        CoreDataPublisher<Account>(context: context)
            .map { $0.map { $0.toModel() } }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] accounts in
                    self?.accounts = accounts
                }
            )
            .store(in: &cancellables)
    }

    deinit {
        print("AccountsScreenViewModel disposed")
    }

    func addAccount() {
        isAddingAccount = true
    }

    func addTransaction() {
        isAddingTransaction = true
    }

    func getSelectedAccounts() -> [AccountModel] {
        return accounts.filter { $0.type == selectedType }
    }

    func deleteAccounts(at offsets: IndexSet) {
        let selected = getSelectedAccounts()
        accountIDsToDelete = offsets.map { selected[$0].id }
        isDeletingAccounts = true
    }

    func confirmDelete() {
        if accountIDsToDelete.count > 0 {
            let repo = AccountRepository(context: moc)
            repo.removeAccounts(byIDs: accountIDsToDelete)
            try? moc.save()
        }
    }

    func getAddAccountViewModel() -> some AddAccountViewModel {
        let repo = AccountRepository(context: moc)
        return AddAccountViewModel(
            context: moc,
            initialAccountType: selectedType,
            equityAccount: repo.fetchDefaultEquityAccount()
        )
    }

    func getAddTransactionViewModel() -> some AddTransactionViewModel {
        return AddTransactionViewModel(
            context: moc,
            accounts: accounts,
            creditAccountID: nil,
            debitAccountID: nil
        )
    }

    private func fetchAccounts() {
        let repo = AccountRepository(context: moc)
        accounts = repo.fetchAccounts()
    }
}
