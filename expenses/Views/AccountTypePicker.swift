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

let accountTypeOrder: [AccountType] = [
    .asset,
    .expense,
    .income,
    .liability,
    .equity,
]  // FIXME: make private

struct AccountTypePicker: View {
    let title: String
    @Binding var selection: AccountType

    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(accountTypeOrder, id: \.self) { type in
                Text(TextFormatter.formatAccountType(type)).tag(type)
            }
        }
    }
}

struct AccountTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section(header: Text("DEMO")) {
                AccountTypePicker(title: "Account type", selection: .constant(.asset))
            }
        }.listStyle(GroupedListStyle())
    }
}
