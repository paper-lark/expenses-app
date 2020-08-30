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

struct AccountsView: View {
    @ObservedObject var model: AccountsViewModel

    init(model: AccountsViewModel) {
        self.model = model

        // remove extra separators below the list
        if #available(iOS 14.0, *) {
            // iOS 14 has no separators
        } else {
            UITableView.appearance().tableFooterView = UIView()
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            AccountTypePicker(title: "", selection: self.$model.selectedType)
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 16)
                .padding(.horizontal, 16)
            List {
                ForEach(self.model.getSelectedAccounts(), id: \.id) { account in
                    AccountRowView(account: account)
                        .deleteDisabled(account.isDefault)
                }
                .onDelete(perform: model.deleteAccounts)
                .alert(
                    isPresented: $model.isDeletingAccounts,
                    content: {
                        Alert(
                            title: Text("Removing accounts"),
                            message: Text(
                                "Accounts will be removed with all their related transactions. Are you sure?"
                            ),
                            primaryButton: .destructive(
                                Text("Remove"), action: self.model.confirmDelete),
                            secondaryButton: .default(Text("Cancel"))
                        )
                    })
            }
            Spacer()

            Button(
                action: self.model.addTransaction,
                label: {
                    HStack(alignment: .lastTextBaseline) {
                        Image(systemName: "plus.circle")
                        Text("Add new transaction")
                    }
                }
            )
            .padding(.vertical, 48)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .sheet(
                isPresented: $model.isAddingTransaction,
                content: {
                    AddTransactionView(model: self.model.getAddTransactionViewModel())
                }
            )
        }
        .navigationBarTitle("Accounts")
        .navigationBarItems(
            leading: EditButton(),
            trailing: Button(
                action: self.model.addAccount,
                label: {
                    Image(systemName: "plus")
                        .padding(
                            EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 0))
                }
            ).sheet(
                isPresented: $model.isAddingAccount,
                content: {
                    AddAccountView(model: self.model.getAddAccountViewModel())
                }
            )
        )
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let model = AccountsViewModel(
            context: moc
        )

        return NavigationView {
            AccountsView(model: model)
        }
    }
}
