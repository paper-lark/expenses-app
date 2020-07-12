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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Transaction history")
                .font(.system(size: 22, weight: .semibold))
            // TODO: add transaction grid
        }
    }
}

struct AccountHistoryView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        return AccountHistoryView(
            account: AccountModel(
                id: UUID(),
                title: "Credit card",
                type: .asset,
                transactions: [],
                isDefault: false
            ))
    }
}
