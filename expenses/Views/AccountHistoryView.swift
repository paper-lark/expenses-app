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

struct AccountHistoryView: View {
    let account: AccountModel
    let accounts: [AccountModel]
    @State var filter: TransactionFilter = .all

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("History")
                .font(.system(size: 22, weight: .semibold))

            TransactionFilterView(selection: $filter)
            TransactionHistoryChart(history: getHistory())

            List {
                ForEach(getTransactions(), id: \.id) {
                    TransactionRowView(
                        account: self.account,
                        transaction: $0,
                        accounts: self.accounts
                    )
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
                // TODO: allow to remove
            }.listStyle(.plain)
        }
    }

    private func getTransactions() -> [TransactionModel] {
        switch filter {
        case .all:
            return account.transactions
        case .credit:
            return account.credit
        case .debit:
            return account.debit
        }
    }

    private func getHistory() -> [(Date, Int64)] {
        let dict = Dictionary(
            grouping: getTransactions(),
            by: { $0.created.getDay() }
        ).mapValues {
            return $0.reduce(Int64(0)) {
                if $1.debitAccountID == account.id {
                    return $0 + $1.amount
                } else {
                    return $0 - $1.amount
                }
            }
        }
        return dict.sorted(by: { $0.key < $1.key })
    }
}

struct AccountHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        return AccountHistoryView(
            account: AccountTestData.assetAccount,
            accounts: AccountTestData.accounts
        )
    }
}
