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
import CoreData

struct AccountRowView: View {
    let account: Account
    
    var body: some View {
        NavigationLink(destination: AccountView(account: account)) {
            HStack(alignment: .firstTextBaseline) {
                Text(account.accountTitle)
                Spacer()
                Text(TextFormatter.formatAmount(account.balance, currency: AppSettings.getCurrency()))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AccountRowView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let account = Account(context: moc)
        account.id = UUID()
        account.title = "Credit card"
        account.accountType = AccountType.Asset
        return NavigationView {
            List {
                AccountRowView(account: account)
            }
        }
    }
}
