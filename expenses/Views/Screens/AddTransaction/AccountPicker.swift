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

struct AccountPicker: View {
    let title: String
    let accounts: [AccountModel]
    @Binding var accountID: UUID

    var body: some View {
        Picker(title, selection: $accountID) {
            ForEach(accounts, id: \.id) { acc in
                Text(acc.title).tag(acc.id)
            }
        }
    }
}

struct AccountPicker_Previews: PreviewProvider {
    @State static var id = UUID()

    static var previews: some View {
        let accounts = [
            AccountModel(
                id: id,
                title: "Cash",
                type: .asset,
                transactions: [],
                isDefault: false
            )
        ]
        return List {
            Section(header: Text("DEMO")) {
                AccountPicker(
                    title: "Account",
                    accounts: accounts,
                    accountID: $id
                )
            }
        }.listStyle(GroupedListStyle())
    }
}
