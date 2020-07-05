//
//  AppSettings.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//

import Foundation

enum Currency: Int {
    case Rouble = 0
    case Dollar = 1
    case Euro = 2
}

class AppSettings {
    private enum UserDefaultsKeys: String {
        case Currency = "currency"
    }
    
    static func getCurrency() -> Currency {
        let raw = UserDefaults.standard.integer(forKey: UserDefaultsKeys.Currency.rawValue)
        return Currency(rawValue: raw) ?? Currency.Rouble
    }
    
    static func setCurrency(_ currency: Currency) {
        UserDefaults.standard.set(currency.rawValue, forKey: UserDefaultsKeys.Currency.rawValue)
    }
}
