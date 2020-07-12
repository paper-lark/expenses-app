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

enum Currency: Int {
    case rouble = 0
    case dollar = 1
    case euro = 2
}

class AppSettings {
    private enum UserDefaultsKeys: String {
        case currency = "currency"
    }

    static func getCurrency() -> Currency {
        let raw = UserDefaults.standard.integer(forKey: UserDefaultsKeys.currency.rawValue)
        return Currency(rawValue: raw) ?? Currency.rouble
    }

    static func setCurrency(_ currency: Currency) {
        UserDefaults.standard.set(currency.rawValue, forKey: UserDefaultsKeys.currency.rawValue)
    }
}
