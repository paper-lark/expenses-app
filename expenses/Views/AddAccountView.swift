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

struct AddAccountView: View {
    @ObservedObject var model: AddAccountViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text("Account information".uppercased()).padding(.top, 16),
                    footer: footer
                ) {
                    TextField("Account title", text: $model.title)
                    AccountTypePicker(title: "Account type", selection: $model.type)
                    TextField("Initial Balance", text: $model.balance)
                        .keyboardType(.numberPad)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("New account", displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    "Cancel",
                    action: self.cancel
                ),
                trailing: Button(
                    "Create",
                    action: self.createAccount
                ).disabled(!model.isBalanceValid()))
        }
    }

    var footer: some View {
        if !model.isBalanceValid() {
            return Text("Balance must be a number.").foregroundColor(.red)
        }
        if model.shouldCreditFromEquity() {
            return Text("Initial balance will be credited from Equity account.")
        }
        return Text("Initial balance will be debited from Equity account.")
    }

    private func cancel() {
        presentationMode.wrappedValue.dismiss()
    }

    private func createAccount() {
        model.createAccount()
        cancel()
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let model = AddAccountViewModel(
            context: moc,
            initialAccountType: .asset,
            equityAccount: AccountTestData.equityAccount
        )
        return AddAccountView(model: model)
    }
}
