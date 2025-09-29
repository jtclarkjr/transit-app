//
//  ContentView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        // Temporarily hide tabs and show only HomeView
        NavigationStack {
            HomeView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TransitRoute.self, SearchHistory.self, StationHistory.self], inMemory: true)
}
