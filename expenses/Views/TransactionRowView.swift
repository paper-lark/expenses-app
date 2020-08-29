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

import SwiftUI

struct TransactionRowView: View {
    let account: AccountModel
    let transaction: TransactionModel
    let accounts: [AccountModel]
    var body: some View {
        VStack(alignment: .leading) {
            title
            description
        }
    }

    var title: some View {
        let sign = hasAccountReceived() ? "+" : "-"
        return Text(
            sign
                + TextFormatter.formatAmount(
                    transaction.amount, currency: AppSettings.getCurrency()))
    }

    var description: some View {
        let prop = isDebitAccount() ? "To" : "From"
        let secondAccountID =
            isDebitAccount()
            ? transaction.creditAccountID : transaction.debitAccountID
        let secondAccount = accounts.first { $0.id == secondAccountID }
        let secondAccountTitle = secondAccount?.title ?? "Somewhere"
        return Text(
            "\(prop) \(secondAccountTitle) at \(TextFormatter.formatDate(transaction.created))"
        )
        .foregroundColor(.secondary)
    }

    func isDebitAccount() -> Bool {
        return transaction.debitAccountID == account.id
    }

    func hasAccountReceived() -> Bool {
        switch account.type {
        case .expense, .asset:
            return isDebitAccount()
        case .equity, .income, .liability:
            return !isDebitAccount()
        }
    }
}

struct TransactionRowView_Previews: PreviewProvider {
    static var previews: some View {
        let accounts = [
            AccountModel(
                id: UUID(),
                title: "Cash",
                type: .asset,
                transactions: [],
                isDefault: false
            ),
            AccountModel(
                id: UUID(),
                title: "Salary",
                type: .income,
                transactions: [],
                isDefault: false
            ),
        ]
        return NavigationView {
            List {
                TransactionRowView(
                    account: accounts[0],
                    transaction: TransactionModel(
                        id: UUID(),
                        created: Date(),
                        amount: 1000,
                        debitAccountID: accounts[0].id,
                        creditAccountID: accounts[1].id
                    ), accounts: accounts
                )
                TransactionRowView(
                    account: accounts[0],
                    transaction: TransactionModel(
                        id: UUID(),
                        created: Date(),
                        amount: 500,
                        debitAccountID: accounts[1].id,
                        creditAccountID: accounts[0].id
                    ),
                    accounts: accounts
                )
            }
        }
    }
}
