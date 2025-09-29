//
//  AutocompleteSheetView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

struct AutocompleteSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var filteredStations: [AutocompleteStation] = []
    @State private var recentStations: [StationHistory] = []
    @State private var isSearching = false
    
    let title: String
    let currentValue: String
    let stationType: String // "from" or "to"
    let onSelection: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search field
                VStack(alignment: .leading, spacing: 8) {
                    TextField("駅名・施設名を入力", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 16))
                        .submitLabel(.search)
                        .onSubmit {
                            if !searchText.isEmpty {
                                performSearch()
                            }
                        }
                }
                .padding()
                
                Divider()
                
                // Content based on search state
                if searchText.isEmpty {
                    // Show history when no search text
                    if recentStations.isEmpty {
                        EmptyHistoryView()
                    } else {
                        // Show recent station history
                        List {
                            Section("最近検索した駅") {
                                ForEach(recentStations, id: \.id) { history in
                                    StationHistoryRow(history: history) {
                                        saveStationToHistory(history.stationName)
                                        onSelection(history.stationName)
                                        dismiss()
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                } else {
                    // Show search results
                    if isSearching {
                        SearchLoadingView()
                    } else if filteredStations.isEmpty {
                        NoSearchResultsView()
                    } else {
                        // Show autocomplete results
                        List(filteredStations, id: \.id) { station in
                            StationResultRow(station: station) {
                                saveStationToHistory(station.name)
                                onSelection(station.name)
                                dismiss()
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("キャンセル") {
                    dismiss()
                }
            )
        }
        .onAppear {
            loadRecentStations()
        }
        .onChange(of: searchText) { _, newValue in
            // Clear results when search text is empty
            if newValue.isEmpty {
                filteredStations = []
                isSearching = false
            }
        }
    }
    
    private func loadRecentStations() {
        let fetchDescriptor = FetchDescriptor<StationHistory>(
            predicate: #Predicate { $0.stationType == stationType },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            let allHistory = try modelContext.fetch(fetchDescriptor)
            recentStations = Array(allHistory.prefix(10)) // Show last 10 searches
        } catch {
            print("Error loading recent stations: \(error)")
            recentStations = []
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else {
            filteredStations = []
            return
        }
        
        isSearching = true
        
        Task {
            do {
                let results = try await TransitAPIService.shared.searchStations(query: searchText)
                
                await MainActor.run {
                    filteredStations = results
                    isSearching = false
                }
            } catch {
                await MainActor.run {
                    print("Search error: \(error)")
                    filteredStations = []
                    isSearching = false
                }
            }
        }
    }
    
    private func saveStationToHistory(_ stationName: String) {
        let fetchDescriptor = FetchDescriptor<StationHistory>(
            predicate: #Predicate { $0.stationName == stationName && $0.stationType == stationType }
        )
        
        if let existingHistory = try? modelContext.fetch(fetchDescriptor).first {
            existingHistory.incrementUsage()
        } else {
            let newHistory = StationHistory(stationName: stationName, stationType: stationType)
            modelContext.insert(newHistory)
        }
        
        try? modelContext.save()
    }
}
