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

class AddAccountViewModel: ObservableObject {
    private let moc: NSManagedObjectContext
    private let equityAccount: AccountModel
    @Published var title: String = ""
    @Published var balance: String = ""
    @Published var type: AccountType

    init(
        context moc: NSManagedObjectContext,
        initialAccountType: AccountType,
        equityAccount: AccountModel
    ) {
        print("AddAccountViewModel created")
        self.moc = moc
        self.type = initialAccountType
        self.equityAccount = equityAccount
    }

    deinit {
        print("AddAccountViewModel disposed")
    }

    func isBalanceValid() -> Bool {
        return balance.count > 0 && Int64(balance) != nil
    }

    func shouldCreditFromEquity() -> Bool {
        return type == .asset || type == .expense
    }

    func createAccount() {
        let accountRepo = AccountRepository(context: moc)
        let transactionRepo = TransactionRepository(context: moc)
        let newAccountID = UUID()
        accountRepo.addAccount(
            AccountModel(
                id: newAccountID,
                title: title,
                type: type,
                transactions: [],
                isDefault: false
            ))

        if let initialBalance = Int64(self.balance) {
            transactionRepo.addTransaction(
                transaction: TransactionModel(
                    id: UUID(),
                    created: Date(),
                    amount: initialBalance,
                    debitAccountID: shouldCreditFromEquity() ? newAccountID : equityAccount.id,
                    creditAccountID: shouldCreditFromEquity() ? equityAccount.id : newAccountID
                ))
        }

        try? moc.save()
    }
}
