//
//  CardView.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//

import SwiftUI

struct CardView<ChildView: View>: View {
    let child: () -> ChildView
    
    var body: some View {
        ZStack(alignment: .leading) {
            self.child()
                .padding(16)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        }
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color(UIColor.systemBackground)))
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
