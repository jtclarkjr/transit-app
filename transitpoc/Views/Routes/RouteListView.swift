//
//  RouteListView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

struct RouteListView: View {
    let routes: [TransitRoute]
    let fromStation: String
    let toStation: String
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @State private var selectedRoute: TransitRoute?
    
    // Search timestamp for display
    private let searchTimestamp = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                if routes.isEmpty {
                    noResultsView
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
    
    private var headerView: some View {
        VStack(spacing: 8) {
       
            Text("\(fromStation) ↔ \(toStation)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)

            Text(formatSearchTimestamp(searchTimestamp))
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray4)),
            alignment: .bottom
        )
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            
            Text("ルートが見つかりません")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("検索条件を変更して、もう一度お試しください。")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("再試行")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 120, height: 44)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
    }
    
    private func formatSearchTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日(E) HH:mm 検索"
        return formatter.string(from: date)
    }
}

struct RouteCardView: View {
    let route: TransitRoute
    let onTap: () -> Void
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Route Header with Route Number
                HStack {
                    // Route Number Badge
                    if let routeNumber = route.routeNumber {
                        Text(routeNumber)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                    // Time
                    HStack(spacing: 8) {
                        Text(formatTime(route.departureTime))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14))
                        
                        Text(formatTime(route.arrivalTime))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // Duration and Cost
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(route.durationText)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                        
                        HStack(spacing: 4) {
                            Text(route.costText)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            // IC Card fare if different
                            if let fareOptions = route.fareOptions,
                               let icFare = fareOptions["ic_card"],
                               icFare != route.totalCost {
                                Text("(IC: ¥\(icFare))")
                                    .font(.system(size: 12))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        // Distance info
                        if let distance = route.totalDistance {
                            Text("\(String(format: "%.1f", Double(distance) / 1000))km")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Route Info
                HStack(spacing: 12) {
                    // Transfer Info
                    HStack(spacing: 4) {
                        Image(systemName: route.transferCount == 0 ? "train.side.front.car" : "arrow.triangle.swap")
                            .foregroundColor(.blue)
                            .font(.system(size: 14))
                        
                        Text(route.transferText)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    // Route Preview (simplified)
                    HStack(spacing: 8) {
                        if let segments = route.segments?.prefix(3) {
                            ForEach(Array(segments.enumerated()), id: \.offset) { index, segment in
                                Circle()
                                    .fill(Color(hex: segment.color) ?? Color(hex: segment.type.defaultColor) ?? Color.blue)
                                    .frame(width: 8, height: 8)
                                
                                if let line = segment.line, !line.isEmpty {
                                    Text(line)
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                        
                        if let segmentCount = route.segments?.count, segmentCount > 3 {
                            Text("...")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Tags
                HStack(spacing: 8) {
                    if route.transferCount == 0 {
                        TagView(text: "直通", color: .green)
                    }
                    
                    if route.totalTime <= 30 {
                        TagView(text: "早", color: .blue)
                    }
                    
                    if route.totalCost <= 200 {
                        TagView(text: "安", color: .orange)
                    }
                    
                    Spacer()
                    
                    // Favorite button
                    Button(action: toggleFavorite) {
                        Image(systemName: route.isFavorite ? "bookmark.fill" : "bookmark")
                            .foregroundColor(route.isFavorite ? .yellow : .gray)
                            .font(.system(size: 14))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
            }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    private func toggleFavorite() {
        route.isFavorite.toggle()
        try? modelContext.save()
    }
}

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.1))
            .cornerRadius(4)
    }
}

extension Color {
    init?(hex: String?) {
        guard let hex = hex else { return nil }
        
        let trimmedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: trimmedHex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch trimmedHex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

