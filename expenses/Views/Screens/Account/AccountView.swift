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
    // TODO: use a separate view model
    @ObservedObject var model: AccountViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        if model.shouldDismissView {
            presentationMode.wrappedValue.dismiss()
        }

        return ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(Color.secondarySystemBackground)
                .edgesIgnoringSafeArea(Edge.Set.all)
            VStack(alignment: .leading, spacing: 16) {
                CardView {
                    AccountDetailsView(account: self.model.account)
                }
                CardView {
                    AccountHistoryView(
                        account: self.model.account,
                        accounts: self.model.accounts
                    )
                }
            }
            .padding(.top, 24)
        }
        .navigationBarTitle(Text(model.account.title), displayMode: .inline)
        .navigationBarItems(
            trailing: Button(
                action: model.editAccount,
                label: {
                    Image(systemName: "square.and.pencil")
                }))
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let account = AccountModel(
            id: UUID(),
            title: "Credit card",
            type: .asset,
            transactions: [],
            isDefault: false
        )
        let acc = Account(context: moc)
        acc.id = account.id
        let model = AccountViewModel(context: moc, account: account)
        return NavigationView {
            AccountView(model: model)
        }
    }
}
