//
//  ContentView.swift
//  expenses
//
//  Created by Max Zhuravsky on 05.07.2020.
//  Copyright © 2020 Max Zhuravsky. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            AccountsScreenView()
            // FIXME: add tabs
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
