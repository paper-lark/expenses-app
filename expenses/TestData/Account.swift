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

class AccountTestData {
    static let accounts = [assetAccount, expenseAccount]

    static let assetsAccountId = UUID()
    static let assetAccount = AccountModel(
        id: assetsAccountId,
        title: "Credit card",
        type: .asset,
        transactions: [
            TransactionModel(
                id: UUID(),
                created: Calendar.current.date(
                    from: DateComponents(
                        year: 2018,
                        month: 1,
                        day: 17
                    ))!,
                amount: 5000,
                debitAccountID: assetsAccountId,
                creditAccountID: expenseAccountId
            ),
            TransactionModel(
                id: UUID(),
                created: Calendar.current.date(
                    from: DateComponents(
                        year: 2018,
                        month: 1,
                        day: 18,
                        hour: 10
                    ))!,
                amount: 1000,
                debitAccountID: expenseAccountId,
                creditAccountID: assetsAccountId
            ),
            TransactionModel(
                id: UUID(),
                created: Calendar.current.date(
                    from: DateComponents(
                        year: 2018,
                        month: 1,
                        day: 18,
                        hour: 20
                    ))!,
                amount: 1000,
                debitAccountID: expenseAccountId,
                creditAccountID: assetsAccountId
            ),
            TransactionModel(
                id: UUID(),
                created: Calendar.current.date(
                    from: DateComponents(
                        year: 2018,
                        month: 1,
                        day: 19
                    ))!,
                amount: 100,
                debitAccountID: expenseAccountId,
                creditAccountID: assetsAccountId
            ),
            TransactionModel(
                id: UUID(),
                created: Calendar.current.date(
                    from: DateComponents(
                        year: 2018,
                        month: 1,
                        day: 20
                    ))!,
                amount: 500,
                debitAccountID: assetsAccountId,
                creditAccountID: expenseAccountId
            ),
        ],
        isDefault: false
    )

    static let expenseAccountId = UUID()
    static let expenseAccount = AccountModel(
        id: expenseAccountId,
        title: "Home",
        type: .expense,
        transactions: [],
        isDefault: false
    )

    static let equityAccount = AccountModel(
        id: UUID(),
        title: "Equity account",
        type: .equity,
        transactions: [],
        isDefault: true
    )
}
