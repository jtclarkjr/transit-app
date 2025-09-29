//
//  RouteCardView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

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
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
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

#Preview {
    // Create a sample route for preview
    let sampleRoute = TransitRoute(
        from: "渋谷",
        to: "新宿",
        departureTime: Date(),
        arrivalTime: Date().addingTimeInterval(1800), // 30 minutes later
        totalTime: 30,
        totalCost: 160,
        transferCount: 1
    )
    
    return RouteCardView(route: sampleRoute) {
        print("Route card tapped")
    }
    .padding()
}