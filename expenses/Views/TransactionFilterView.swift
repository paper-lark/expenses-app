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

enum TransactionFilter {
    case all
    case debit
    case credit
}

private let allFilterValues: [TransactionFilter] = [
    .all,
    .debit,
    .credit,
]

struct TransactionFilterView: View {
    @Binding var selection: TransactionFilter

    var body: some View {
        Picker("", selection: $selection) {
            ForEach(allFilterValues, id: \.self) { filter in
                self.getFilterTitle(filter).tag(filter)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }

    func getFilterTitle(_ filter: TransactionFilter) -> some View {
        switch filter {
        case .all:
            return Text("All")
        case .debit:
            return Text("Debit")
        case .credit:
            return Text("Credit")
        }
    }
}

struct TransactionFilterView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionFilterView(selection: .constant(.all))
    }
}
