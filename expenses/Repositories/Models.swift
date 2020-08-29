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

import Foundation

extension Transaction {
    func toModel() -> TransactionModel {
        guard let id = self.value(forKey: "id") as? UUID,
            let created = self.ts,
            let debitAccountID = self.debitAccount?.id,
            let creditAccountID = self.creditAccount?.id
        else {
            fatalError("Failed to map transaction")
        }

        return TransactionModel(
            id: id,
            created: created,
            amount: self.amount,
            debitAccountID: debitAccountID,
            creditAccountID: creditAccountID
        )
    }
}

extension Account {
    func toModel() -> AccountModel {
        let transactions = (self.debitTransactions as? Set<Transaction> ?? []).union(
            self.creditTransactions as? Set<Transaction> ?? []
        ).map { $0.toModel() }.sorted {
            $0.created > $1.created
        }

        guard let id = self.value(forKey: "id") as? UUID,
            let title = self.title,
            let type = AccountType(rawValue: self.typeValue)
        else {
            fatalError("Failed to map account")
        }

        return AccountModel(
            id: id,
            title: title,
            type: type,
            transactions: transactions,
            isDefault: self.isDefault
        )
    }
}
