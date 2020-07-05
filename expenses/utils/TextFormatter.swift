//
//  TextFormatter.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//

import Foundation


class TextFormatter {
    static func formatAmount(_ amount: Int64, currency: Currency) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let amountString = numberFormatter.string(from: NSNumber(value: amount))!
        return amountString + formatCurrency(currency)
    }
    
    static func formatCurrency(_ currency: Currency) -> String {
        switch currency {
        case .Dollar:
            return "$"
        case .Euro:
            return "€"
        case .Rouble:
            return "₽"
        }
    }
    
    static func formatAccountType(_ type: AccountType) -> String {
        switch type {
        case .Asset:
            return "Asset"
        case .Equity:
            return "Equity"
        case .Expense:
            return "Expense"
        case .Income:
            return "Income"
        case .Liability:
            return "Liability"
        }
    }
}
