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

import Charts
import SwiftUI

struct TransactionHistoryChart: View {
    let history: [(Date, Int64)]
    static private let minPointCount = 4

    var body: some View {
        let historyWithColor = history.map {
            ($0.0, $0.1, ($0.1 > 0) ? Color.blue : Color.red)
        }

        Chart(historyWithColor, id: \.0) { item in
            BarMark(
                x: .value("Date", item.0),
                y: .value("Change", item.1)
            ).foregroundStyle(item.2)
        }.chartXScale(
            domain: .automatic(dataType: Date.self) { domain in
                domain.removeDuplicates()
                print(domain)
                for (index, date) in domain.enumerated() {
                    domain[index] = date.getDay()
                }
                if let lastDay = domain.first, domain.count < TransactionHistoryChart.minPointCount
                {
                    for i in 1...(TransactionHistoryChart.minPointCount - domain.count) {
                        domain.insert(
                            Calendar.current.date(byAdding: .day, value: -i, to: lastDay)!, at: 0)
                    }
                }
                print(domain)
            })
    }
}

struct TransactionHistoryChart_Previews: PreviewProvider {
    static var previews: some View {
        TransactionHistoryChart(
            history: [
                //                (
                //                    Calendar.current.date(from: DateComponents(year: 2018, month: 1, day: 15))!,
                //                    100
                //                ),
                (
                    Calendar.current.date(from: DateComponents(year: 2018, month: 1, day: 16))!,
                    200
                ),
                (
                    Calendar.current.date(from: DateComponents(year: 2018, month: 1, day: 17))!,
                    500
                ),
                //                (
                //                    Calendar.current.date(from: DateComponents(year: 2018, month: 1, day: 18))!,
                //                    -200
                //                ),
            ])
    }
}
