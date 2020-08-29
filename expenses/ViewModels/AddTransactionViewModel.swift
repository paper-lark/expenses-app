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

import CoreData
import SwiftUI

class AddTransactionViewModel: ObservableObject {
    private let moc: NSManagedObjectContext
    let accounts: [AccountModel]
    @Published var creditAccountID: UUID
    @Published var debitAccountID: UUID
    @Published var amount: String = ""
    private let tests: [TestViewModel]

    init(
        context moc: NSManagedObjectContext,
        accounts: [AccountModel],
        creditAccountID: UUID?,
        debitAccountID: UUID?
    ) {
        self.moc = moc
        self.accounts = accounts
        self.creditAccountID = creditAccountID ?? UUID()
        self.debitAccountID = debitAccountID ?? UUID()
        tests = [TestViewModel(context: moc), TestViewModel(context: moc)]
    }

    func hasEmptyFields() -> Bool {
        return amount.count == 0
    }

    func isAmountValid() -> Bool {
        return amount.count > 0 && Int64(amount) != nil
    }

    func isAccountsValid() -> Bool {
        if creditAccountID == debitAccountID {
            return false
        }
        if getAccount(byID: creditAccountID) == nil
            || getAccount(byID: debitAccountID) == nil
        {
            return false
        }
        return true
    }

    func create() {
        if let amount = Int64(amount), isAccountsValid(), isAmountValid() {
            let repo = TransactionRepository(context: moc)
            repo.addTransaction(
                transaction: TransactionModel(
                    id: UUID(),
                    created: Date(),
                    amount: amount,
                    debitAccountID: debitAccountID,
                    creditAccountID: creditAccountID
                ))
            try? self.moc.save()
        }
    }

    private func getAccount(byID id: UUID?) -> AccountModel? {
        guard let id = id else {
            return nil
        }
        return accounts.first(where: { $0.id == id })
    }
}
