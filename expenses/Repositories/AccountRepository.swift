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

class AccountRepository {
    private let moc: NSManagedObjectContext
    static let defaultEquityID: UUID = {
        if let id = UUID(uuidString: "00000000-0000-0000-0000-000000000001") {
            return id
        }
        fatalError("Failed to parse defaultEquityID")
    }()

    init(context: NSManagedObjectContext) {
        self.moc = context
    }

    func fetchAccounts() -> [AccountModel] {
        let req = NSFetchRequest<Account>(entityName: Account.entity().name ?? "")
        let accounts = try? moc.fetch(req)
        return (accounts ?? []).map(self.mapAccount)
    }

    func fetchAccounts(byIDs ids: [UUID]) -> [AccountModel] {
        return getAccountModels(byIDs: ids).map(self.mapAccount)
    }

    func fetchAccount(byID id: UUID) -> AccountModel? {
        let accounts = fetchAccounts(byIDs: [id])
        return accounts.first
    }

    @discardableResult
    func fetchDefaultEquityAccount() -> AccountModel {
        guard let account = fetchAccount(byID: AccountRepository.defaultEquityID) else {
            do {
                let newAccount = AccountModel(
                    id: AccountRepository.defaultEquityID,
                    title: "Balancing account",
                    type: .equity,
                    transactions: [],
                    isDefault: true
                )
                addAccount(newAccount)
                try moc.save()
                return newAccount
            } catch let error {
                fatalError("Failed to create default equity account: \(error)")
            }
        }
        return account
    }

    func addAccount(_ model: AccountModel) {
        let a = Account(context: moc)
        a.uid = model.id
        a.title = model.title
        a.typeValue = model.type.rawValue
        a.isDefault = model.isDefault
    }

    func removeAccounts(byIDs ids: [UUID]) {
        for account in getAccountModels(byIDs: ids) {
            moc.delete(account)
        }
    }

    func removeAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: Account.entity().name ?? "")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try moc.fetch(fetchRequest)
            for object in results {
                if let objectData = object as? NSManagedObject {
                    moc.delete(objectData)
                }
            }
            try moc.save()
        } catch let error {
            fatalError("Failed to delete all accounts: \(error)")
        }
    }

    private func getAccountModels(byIDs ids: [UUID]) -> [Account] {
        let req = NSFetchRequest<Account>(entityName: Account.entity().name ?? "")
        req.predicate = NSPredicate(
            format: "%K IN %@",
            #keyPath(Account.uid),
            ids as CVarArg
        )
        let result = try? moc.fetch(req)
        return result ?? []
    }

    private func mapAccount(_ a: Account) -> AccountModel {
        let transactions = (a.debitTransactions as? Set<Transaction> ?? []).union(
            a.creditTransactions as? Set<Transaction> ?? []
        ).map(self.mapTransaction).sorted {
            $0.created > $1.created
        }

        guard let id = a.value(forKey: "uid") as? UUID,
            let title = a.title,
            let type = AccountType(rawValue: a.typeValue)
        else {
            fatalError("Failed to map account")
        }

        return AccountModel(
            id: id,
            title: title,
            type: type,
            transactions: transactions,
            isDefault: a.isDefault
        )
    }

    private func mapTransaction(transaction t: Transaction) -> TransactionModel {
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
