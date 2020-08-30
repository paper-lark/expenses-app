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

import Combine
import CoreData
import Foundation

// FIXME: attach to view and show view
class EditAccountViewModel: ObservableObject {
    private let moc: NSManagedObjectContext
    private let model: AccountModel
    @Published var title: String
    @Published var type: AccountType

    init(context: NSManagedObjectContext, account: AccountModel) {
        moc = context
        model = account
        type = account.type
        title = account.title
    }

    func canDelete() -> Bool {
        return !model.isDefault
    }

    func update() {
        let repo = AccountRepository(context: moc)
        repo.updateAccount(withID: model.id, setTitle: model.title, setType: model.type)
    }
}
