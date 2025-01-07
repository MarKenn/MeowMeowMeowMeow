//
//  ContentView.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .wild

    enum Tab {
        case wild
        case domesticated
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            WildCatView()
                .tabItem {
                    Label("Wild", systemImage: "star")
                }
                .tag(Tab.wild)

            DomesticatedCatView()
                .tabItem {
                    Label("Domesticated", systemImage: "list.bullet")
                }
                .tag(Tab.domesticated)
        }
    }
}

#Preview {
    ContentView()
}
