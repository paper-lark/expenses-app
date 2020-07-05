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
import CoreData

let accountTypeOrder: [AccountType] = [
    .Asset,
    .Expense,
    .Income,
    .Liability,
    .Equity
];

struct AccountsScreenView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Account.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Account.title, ascending: true)
    ]) var accounts: FetchedResults<Account>
    @State var selectedType = AccountType.Asset // FIXME: take from app state
    @State var isAddingAccount = false
    
    init() {
        // remove extra separators below the list
        if #available(iOS 14.0, *) {
            // iOS 14 has no separators
        } else {
            UITableView.appearance().tableFooterView = UIView()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("", selection: $selectedType) {
                ForEach(accountTypeOrder, id: \.self) { type in
                    Text(TextFormatter.formatAccountType(type)).tag(type)
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding(.top, 16)
                .padding(.horizontal, 16)
            List {
                ForEach(self.getSelectedAccounts(), id: \.id) { account in
                    AccountRowView(account: account)
                        .deleteDisabled(account.isDefault)
                }
                    .onDelete(perform: self.deleteAccounts)
            }
            Spacer()
            
            Button(action: {
                // FIXME:
            }, label: {
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: "plus.circle")
                    Text("Add new transaction")
                }
            })
                .padding(.vertical, 48)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        }
            .navigationBarTitle("Accounts")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.isAddingAccount = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $isAddingAccount, content: {
                AddAccountView(type: self.selectedType)
                    .environment(\.managedObjectContext, self.moc)
            })
    }
    
    
    private func getSelectedAccounts() -> [Account] {
        return self.accounts.filter { $0.accountType == self.selectedType }
    }
    
    private func deleteAccounts(at offsets: IndexSet) {
        for offset in offsets {
            moc.delete(self.getSelectedAccounts()[offset])
        }
        
        // FIXME: confirm action
        try? moc.save()
    }
}

struct AccountsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountsScreenView()
        }
    }
}
