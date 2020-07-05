//
//  AccountView.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//

import SwiftUI
import CoreData

struct AccountView: View {
    let account: Account
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(Color.secondarySystemBackground)
            VStack(alignment: .leading, spacing: 16) {
                CardView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(TextFormatter.formatAccountType(self.account.accountType)) balance")
                            .font(.system(size: 22, weight: .semibold))
                        Text(TextFormatter.formatAmount(self.account.balance, currency: AppSettings.getCurrency()))
                            .font(.largeTitle)
                            .frame(minWidth:0, maxWidth: .infinity, alignment: .center)
                    }
                }
                CardView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transaction history")
                            .font(.system(size: 22, weight: .semibold))
                        // FIXME: add transaction grid
                    }
                }
            }
                .padding(.top, 24)
        }
            // FIXME: add go back button
            .navigationBarTitle(Text(account.accountTitle), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                // FIXME:
            }, label: {
                Image(systemName: "square.and.pencil")
            }))
    }
}

struct AccountView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let account = Account(context: moc)
        account.id = UUID()
        account.title = "Credit card"
        account.accountType = AccountType.Asset
        return NavigationView {
            AccountView(account: account)
        }
    }
}
