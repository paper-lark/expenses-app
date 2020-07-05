//
//  AccountRowView.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//

import SwiftUI
import CoreData

struct AccountRowView: View {
    let account: Account
    
    var body: some View {
        NavigationLink(destination: AccountView(account: account)) {
            HStack(alignment: .firstTextBaseline) {
                Text(account.accountTitle)
                Spacer()
                Text(TextFormatter.formatAmount(account.balance, currency: AppSettings.getCurrency()))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AccountRowView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let account = Account(context: moc)
        account.id = UUID()
        account.title = "Credit card"
        account.accountType = AccountType.Asset
        return NavigationView {
            List {
                AccountRowView(account: account)
            }
        }
    }
}
