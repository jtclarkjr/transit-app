//
//  HomeView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        sort: \SearchHistory.timestamp,
        order: .reverse
    ) private var searchHistory: [SearchHistory]
    
    @State private var fromStation = ""
    @State private var toStation = ""
    @State private var isSearching = false
    @State private var searchResults: [TransitRoute] = []
    @State private var shouldNavigateToRoutes = false
    
    // Get the last 5 search history items
    private var recentSearchHistory: [SearchHistory] {
        Array(searchHistory.prefix(5))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Search Form
                SearchFormView(
                    fromStation: $fromStation,
                    toStation: $toStation,
                    isSearching: isSearching,
                    onSearch: performSearch
                )
                
                // Search History Section
                SearchHistorySectionView(
                    recentSearchHistory: recentSearchHistory
                ) { item in
                    handleHistoryItemTapped(item)
                }
                
                Spacer(minLength: 20)
            }
        }
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $shouldNavigateToRoutes) {
            RouteListView(
                routes: searchResults,
                fromStation: fromStation,
                toStation: toStation
            )
        }
    }
    
    private func handleHistoryItemTapped(_ item: SearchHistory) {
        print("Tapping history item: \(item.from) → \(item.to)")
        withAnimation(.easeInOut(duration: 0.2)) {
            fromStation = item.from
            toStation = item.to
        }
        print("Updated state: fromStation = \(fromStation), toStation = \(toStation)")
    }
    
    private func performSearch() {
        guard !fromStation.isEmpty && !toStation.isEmpty else { return }
        
        isSearching = true
        
        // Save to search history
        saveToHistory()
        
        // Perform actual API search
        Task {
            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
                let currentTime = formatter.string(from: Date())
                
                print("Searching for routes from '\(fromStation)' to '\(toStation)' at time '\(currentTime)'")
                
                let response = try await TransitAPIService.shared.searchRoutes(
                    start: fromStation,
                    goal: toStation,
                    startTime: currentTime
                )
                
                print("API Response: items=\(response.items?.count ?? 0), unit=\(response.unit?.currency ?? "none")")
                
                // Convert API response to TransitRoute objects
                let routes = TransitDataMapper.shared.mapTransitResponse(response)
                
                print("Mapped \(routes.count) routes for UI")
                
                // Log route details for debugging
                for (index, route) in routes.enumerated() {
                    print("Route \(index + 1): \(route.from) → \(route.to)")
                    print("   Time: \(route.durationText), Cost: \(route.costText), Transfers: \(route.transferCount)")
                    print("   Segments: \(route.segments?.count ?? 0)")
                }
                
                await MainActor.run {
                    searchResults = routes
                    isSearching = false
                    shouldNavigateToRoutes = true
                }
            } catch {
                await MainActor.run {
                    print("Search failed: \(error)")
                    searchResults = []
                    isSearching = false
                    // Still navigate to show empty results
                    shouldNavigateToRoutes = true
                }
            }
        }
    }
    
    private func saveToHistory() {
        // Check if this search already exists
        let fetchDescriptor = FetchDescriptor<SearchHistory>(
            predicate: #Predicate { $0.from == fromStation && $0.to == toStation }
        )
        
        if let existingHistory = try? modelContext.fetch(fetchDescriptor).first {
            existingHistory.incrementSearchCount()
        } else {
            let newHistory = SearchHistory(from: fromStation, to: toStation)
            modelContext.insert(newHistory)
        }
        
        try? modelContext.save()
    }
    
}
