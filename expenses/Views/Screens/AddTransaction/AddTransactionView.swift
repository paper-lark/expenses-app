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

struct AddTransactionView: View {
    @ObservedObject var model: AddTransactionViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text("Transaction information".uppercased()).padding(.top, 16),
                    footer: footer
                ) {
                    AccountPicker(
                        title: "Credit account",
                        accounts: model.accounts,
                        accountID: $model.creditAccountID
                    )
                    AccountPicker(
                        title: "Debit account",
                        accounts: model.accounts,
                        accountID: $model.debitAccountID
                    )
                    TextField("Amount", text: $model.amount)
                        .keyboardType(.numberPad)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("New transaction", displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    "Cancel",
                    action: self.cancel
                ),
                trailing: Button(
                    "Add",
                    action: self.createTransaction
                ).disabled(getValidationError() != nil || model.hasEmptyFields())
            )
        }
    }

    var footer: some View {
        if let text = getValidationError() {
            return Text(text)
        }
        return Text("")
    }

    private func cancel() {
        presentationMode.wrappedValue.dismiss()
    }

    private func createTransaction() {
        model.create()
        cancel()
    }

    private func getValidationError() -> String? {
        if !model.isAccountsValid() {
            return "Credit and debit accounts should be different"
        }
        if !model.isAmountValid() {
            return "Invalid amount to transfer"
        }
        return nil
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let accounts = [
            AccountModel(
                id: UUID(),
                title: "Cash",
                type: .asset,
                transactions: [],
                isDefault: false
            ),
            AccountModel(
                id: UUID(),
                title: "Salary",
                type: .income,
                transactions: [],
                isDefault: false
            ),
        ]

        let model = AddTransactionViewModel(
            context: moc,
            accounts: accounts,
            creditAccountID: accounts[1].id,
            debitAccountID: accounts[0].id
        )
        return AddTransactionView(model: model)
    }
}
