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

// FIXME: rename all repositories to services
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
        return (accounts ?? []).map { $0.toModel() }
    }

    func fetchAccounts(byIDs ids: [UUID]) -> [AccountModel] {
        return getAccountModels(byIDs: ids).map { $0.toModel() }
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
        a.id = model.id
        a.title = model.title
        a.typeValue = model.type.rawValue
        a.isDefault = model.isDefault
    }

    func updateAccount(withID id: UUID, setTitle title: String, setType type: AccountType) {
        guard let account = getAccountModels(byIDs: [id]).first else {
            // TODO: display error
            return
        }
        account.title = title
        account.typeValue = type.rawValue
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
            #keyPath(Account.id),
            ids as CVarArg
        )
        let result = try? moc.fetch(req)
        return result ?? []
    }
}
