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
import Foundation

class StoreController {
    private static let defaultEquityID: UUID = {
        if let id = UUID(uuidString: "00000000-0000-0000-0000-000000000001") {
            return id
        }
        fatalError("Failed to parse defaultEquityID")
    }()

    static func initializeStore(moc: NSManagedObjectContext) {
        // create default equity account
        let request = NSFetchRequest<Account>(entityName: Account.entity().name ?? "")
        request.predicate = getDefaultEquityPredicate()

        if (try? moc.count(for: request)) == 0 {
            let equityAccount = Account(context: moc)
            equityAccount.id = defaultEquityID
            equityAccount.title = "Balancing account"
            equityAccount.accountType = AccountType.equity
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
