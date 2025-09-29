//
//  RouteListView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

struct RouteListView: View {
    let routes: [TransitRoute]
    let fromStation: String
    let toStation: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRoute: TransitRoute?
    
    // Search timestamp for display
    private let searchTimestamp = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                RouteListHeaderView(
                    fromStation: fromStation,
                    toStation: toStation,
                    searchTimestamp: searchTimestamp
                )
                
                if routes.isEmpty {
                    RouteListEmptyStateView {
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    // Route List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(routes, id: \.id) { route in
                                RouteCardView(route: route) {
                                    selectedRoute = route
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $selectedRoute) { route in
            RouteDetailView(
                route: route,
                fromStation: fromStation,
                toStation: toStation
            )
        }
    }
}
