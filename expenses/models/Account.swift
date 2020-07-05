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

import Foundation
import CoreData

public enum AccountType: Int16 {
    case Asset = 0
    case Expense = 1
    case Income = 2
    case Liability = 3
    case Equity = 4
}

extension Account {
    public var accountType: AccountType {
        get {
            return AccountType(rawValue: self.typeValue) ?? AccountType.Asset
        }
        
        set {
            self.typeValue = newValue.rawValue
        }
    }
    
    public var accountTitle: String {
        return self.title ?? "Unknown title"
    }
    
    public var debit: [Transaction] {
        let set = self.debitTransactions as? Set<Transaction> ?? []
        return set.sorted {
            $0.created > $1.created
        }
    }
    
    public var credit: [Transaction] {
        let set = self.creditTransactions as? Set<Transaction> ?? []
        return set.sorted {
            $0.created > $1.created
        }
    }
    
    public var transactions: [Transaction] {
        let set = (self.debitTransactions as? Set<Transaction> ?? []).union(
            self.creditTransactions as? Set<Transaction> ?? []
        )
        return set.sorted {
            $0.created > $1.created
        }
        // FIXME: use own type to separate debit and credit entities
    }
    
    public var balance: Int64 {
        let totalDebit = self.debit.map(){
            return $0.amount
        }.reduce(0) {
            return $0 + $1
        }
        let totalCredit = self.credit.map(){
            return $0.amount
        }.reduce(0) {
            return $0 + $1
        }
        
        if (self.accountType == .Asset || self.accountType == .Expense) {
            return totalDebit - totalCredit
        }
        
        return totalCredit - totalDebit
    }
}
