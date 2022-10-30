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

class TransactionRepository {
    private let moc: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.moc = context
    }

    func addTransaction(transaction model: TransactionModel) {
        let req = NSFetchRequest<Account>(entityName: Account.entity().name ?? "")
        req.predicate = NSPredicate(
            format: "%K in %@",
            #keyPath(Account.uid),
            [model.creditAccountID, model.debitAccountID] as CVarArg
        )
        let accounts = try? moc.fetch(req)
        let creditAccount = accounts?.first(where: { $0.uid == model.creditAccountID })
        let debitAccount = accounts?.first(where: { $0.uid == model.debitAccountID })

        let t = Transaction(context: moc)
        t.uid = model.id
        t.amount = model.amount
        t.ts = model.created
        t.creditAccount = creditAccount
        t.debitAccount = debitAccount
    }

    static func mapTransaction(transaction t: Transaction) -> TransactionModel {
        guard let id = t.value(forKey: "uid") as? UUID,
            let created = t.ts,
            let debitAccountID = t.debitAccount?.uid,
            let creditAccountID = t.creditAccount?.uid
        else {
            fatalError("Failed to map transaction")
        }

        return TransactionModel(
            id: id,
            created: created,
            amount: t.amount,
            debitAccountID: debitAccountID,
            creditAccountID: creditAccountID
        )
    }
}
