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

struct AccountView: View {
    let account: Account

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(Color.secondarySystemBackground)
            VStack(alignment: .leading, spacing: 16) {
                CardView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(TextFormatter.formatAccountType(self.account.accountType)) balance")
                            .font(.system(size: 22, weight: .semibold))
                        Text(
                            TextFormatter.formatAmount(
                                self.account.balance, currency: AppSettings.getCurrency())
                        )
                        .font(.largeTitle)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    }
                }
                CardView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transaction history")
                            .font(.system(size: 22, weight: .semibold))
                        // FIXME: add transaction grid
                    }
                }
            }
            .padding(.top, 24)
        }
        // FIXME: add go back button
        .navigationBarTitle(Text(account.accountTitle), displayMode: .inline)
        .navigationBarItems(
            trailing: Button(
                action: {
                    // FIXME:
                },
                label: {
                    Image(systemName: "square.and.pencil")
                }))
    }
}

struct AccountView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let account = Account(context: moc)
        account.id = UUID()
        account.title = "Credit card"
        account.accountType = AccountType.Asset
        return NavigationView {
            AccountView(account: account)
        }
    }
}
