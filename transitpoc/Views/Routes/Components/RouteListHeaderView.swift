//
//  RouteListHeaderView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

struct RouteListHeaderView: View {
    let fromStation: String
    let toStation: String
    let searchTimestamp: Date
    
    var body: some View {
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
    
    private func formatSearchTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日(E) HH:mm 検索"
        return formatter.string(from: date)
    }
}

#Preview {
    RouteListHeaderView(
        fromStation: "渋谷",
        toStation: "新宿",
        searchTimestamp: Date()
    )
}