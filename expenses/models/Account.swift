//
//  Account.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//
//

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
