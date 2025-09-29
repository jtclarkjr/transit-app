//
//  RouteDetailView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

struct RouteDetailView: View {
    let route: TransitRoute
    let fromStation: String
    let toStation: String
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Route Summary
                    RouteDetailSummaryView(
                        route: route,
                        fromStation: fromStation,
                        toStation: toStation,
                        onToggleFavorite: toggleFavorite
                    )
                    
                    // Route Steps
                    if let segments = route.segments, !segments.isEmpty {
                        RouteDetailTimelineView(segments: segments)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("ルート詳細")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("閉じる") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func toggleFavorite() {
        route.isFavorite.toggle()
        try? modelContext.save()
    }
}
