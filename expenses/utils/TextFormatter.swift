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
