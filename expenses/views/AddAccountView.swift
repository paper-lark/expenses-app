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

struct AddAccountView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Account.entity(), sortDescriptors: [], predicate: StoreController.getDefaultEquityPredicate()) var equityAccount: FetchedResults<Account>
    @State var title = ""
    @State var type: AccountType
    @State var balance = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account information".uppercased()).padding(.top, 16), footer: footer) {
                    TextField("Account title", text: $title)
                    Picker("Account type", selection: $type) {
                        ForEach(accountTypeOrder, id: \.self) { type in
                            Text(TextFormatter.formatAccountType(type)).tag(type)
                        }
                    }
                    TextField("Initial Balance", text: $balance)
                        .keyboardType(.numberPad)
                }
            }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("New account", displayMode: .inline)
                .navigationBarItems(leading: Button(
                    "Cancel",
                    action: { self.presentationMode.wrappedValue.dismiss() }
                ), trailing: Button(
                    "Create",
                    action: self.createAccount
                ).disabled(self.validateFields() != nil))
        }
    }
    
    var footer: some View {
        if let error = validateFields() {
            return Text(error).foregroundColor(.red)
        }
        if shouldCreditFromEquity() {
            return Text("Initial balance will be credited from Equity account.")
        }
        return Text("Initial balance will be debited from Equity account.")
    }
    
    private func validateFields() -> String? {
        let isBalanceInvalid = balance.count > 0 && Int64(balance) == nil
        return isBalanceInvalid ? "Balance must be a number." : nil
    }
    
    private func createAccount() {
        // create account
        let account = Account(context: self.moc)
        account.id = UUID()
        account.title = self.title
        account.accountType = self.type
        account.isDefault = false
        
        // add first transaction
        if let initialBalance = Int64(self.balance) {
            let balancingTransaction = Transaction(context: self.moc)
            balancingTransaction.id = UUID()
            
            if shouldCreditFromEquity() {
                balancingTransaction.debitAccount = account
                balancingTransaction.creditAccount = self.equityAccount[0]
            } else {
                balancingTransaction.creditAccount = account
                balancingTransaction.debitAccount = self.equityAccount[0]
            }
            
            balancingTransaction.amount = initialBalance
            balancingTransaction.ts = Date()
        }
        
        // save entities
        try? self.moc.save()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func shouldCreditFromEquity() -> Bool {
        return type == .Asset || type == .Expense
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView(type: AccountType.Asset)
    }
}
