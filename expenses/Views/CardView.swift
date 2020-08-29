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

import SwiftUI

struct CardView<ChildView: View>: View {
    let child: () -> ChildView

    var body: some View {
        ZStack(alignment: .leading) {
            self.child()
                .padding(16)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        }
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(UIColor.systemBackground))
        )
        .padding(.horizontal, 16)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.secondarySystemBackground)
            VStack(alignment: .leading, spacing: 16) {
                CardView {
                    VStack(alignment: .leading) {
                        Text("Awesome card")
                            .font(.title)
                        Text("This is a long long long long long card description for preview")
                    }
                }
                CardView {
                    VStack(alignment: .leading) {
                        Text("Awesome card")
                            .font(.title)
                        Text("Short description")
                    }
                }
            }
        }
    }
}
