//
//  TransitPocApp.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

@main
struct TransitPocApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AutocompleteItem.self,
            SearchHistory.self,
            StationHistory.self,
            TransitRoute.self,
            TransitSegment.self,
            SavedRoute.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("ModelContainer creation failed: \(error)")
            // Try with a fresh database file for the new schema
            let url = URL.applicationSupportDirectory.appending(path: "TransitPoc.sqlite")
            let freshConfig = ModelConfiguration(url: url)
            
            do {
                return try ModelContainer(for: schema, configurations: [freshConfig])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
