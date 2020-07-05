//
//  StoreController.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//

import Foundation
import CoreData

private let defaultEquityID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

class StoreController {
    static func initializeStore(moc: NSManagedObjectContext) {
        // create default equity account
        let request = NSFetchRequest<Account>(entityName: Account.entity().name!)
        request.predicate = getDefaultEquityPredicate()
        
        if (try? moc.count(for: request)) == 0 {
            let equityAccount = Account(context: moc)
            equityAccount.id = defaultEquityID
            equityAccount.title = "Balancing account"
            equityAccount.accountType = AccountType.Equity
            equityAccount.isDefault = true
            try? moc.save()
        }
    }
    
    static func getDefaultEquityPredicate() -> NSPredicate {
        return NSPredicate(
            format: "%K == %@",
            #keyPath(Account.id),
            defaultEquityID as CVarArg
        )
    }
}
