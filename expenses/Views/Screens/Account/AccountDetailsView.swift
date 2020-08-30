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

struct AccountDetailsView: View {
    let account: AccountModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(TextFormatter.formatAccountType(account.type)) balance")
                .font(.system(size: 22, weight: .semibold))
            Text(
                TextFormatter.formatAmount(account.balance, currency: AppSettings.getCurrency())
            )
            .font(.largeTitle)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        }
    }
}

struct AccountOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        return AccountDetailsView(
            account: AccountModel(
                id: UUID(),
                title: "Cash",
                type: .asset,
                transactions: [],
                isDefault: false
            ))
    }
}
