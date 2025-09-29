//
//  RouteDetailSummaryView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

struct RouteDetailSummaryView: View {
    let route: TransitRoute
    let fromStation: String
    let toStation: String
    let onToggleFavorite: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text(formatTime(route.departureTime))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    Text(fromStation)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(route.durationText)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.blue)
                    
                    if route.transferCount > 0 {
                        Text("乗換\(route.transferCount)回")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    } else {
                        Text("直通")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(formatTime(route.arrivalTime))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    Text(toStation)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Text(route.costText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: onToggleFavorite) {
                    HStack(spacing: 4) {
                        Image(systemName: route.isFavorite ? "bookmark.fill" : "bookmark")
                        Text(route.isFavorite ? "保存済み" : "保存")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(route.isFavorite ? .yellow : .blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding()
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

#Preview {
    let sampleRoute = TransitRoute(
        from: "渋谷",
        to: "新宿",
        departureTime: Date(),
        arrivalTime: Date().addingTimeInterval(1800), // 30 minutes later
        totalTime: 30,
        totalCost: 160,
        transferCount: 1
    )
    
    RouteDetailSummaryView(
        route: sampleRoute,
        fromStation: "渋谷",
        toStation: "新宿"
    ) {
        print("Toggle favorite tapped")
    }
}