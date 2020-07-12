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

enum AccountType: Int16 {
    case asset = 0
    case expense = 1
    case income = 2
    case liability = 3
    case equity = 4
}

struct AccountModel {
    let id: UUID
    let title: String
    let type: AccountType
    let transactions: [TransactionModel]
    let isDefault: Bool

    var debit: [TransactionModel] {
        return transactions.filter({ $0.debitAccountID == id })
    }

    var credit: [TransactionModel] {
        return transactions.filter({ $0.creditAccountID == id })
    }

    var balance: Int64 {
        let totalDebit = self.debit.map {
            return $0.amount
        }.reduce(0) {
            return $0 + $1
        }
        let totalCredit = self.credit.map {
            return $0.amount
        }.reduce(0) {
            return $0 + $1
        }

        if self.type == .asset || self.type == .expense {
            return totalDebit - totalCredit
        }

        return totalCredit - totalDebit
    }
}
