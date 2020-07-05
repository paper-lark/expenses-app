//
//  AccountsScreenView.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//

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
