//
//  Transaction.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//

import Foundation

extension Transaction {
    public var created: Date {
        return self.ts ?? Date()
    }
    
    public var credited: Account {
        return self.creditAccount!
    }
    
    public var debited: Account {
        return self.debitAccount!
    }
}
