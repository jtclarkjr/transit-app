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
                            
                            Button(action: toggleFavorite) {
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
                    
                    // Route Steps
                    if let segments = route.segments, !segments.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("経路詳細")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.horizontal)
                                .padding(.bottom, 12)
                            
                            ForEach(Array(segments.enumerated()), id: \.offset) { index, segment in
                                RouteSegmentView(
                                    segment: segment,
                                    isFirst: index == 0,
                                    isLast: index == segments.count - 1
                                )
                            }
                            
                            // Final destination
                            if let lastSegment = segments.last {
                                FinalDestinationView(segment: lastSegment)
                            }
                        }
                        .padding(.vertical)
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

struct RouteSegmentView: View {
    let segment: TransitSegment
    let isFirst: Bool
    let isLast: Bool
    
    private let timelineWidth: CGFloat = 20
    private let circleSize: CGFloat = 16
    private let lineWidth: CGFloat = 4
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Fixed-width timeline column
            VStack(spacing: 0) {
                // Connection line from previous segment
                if !isFirst {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(width: 2, height: 16)
                }
                
                // Departure station circle
                Circle()
                    .fill(Color.white)
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 2)
                    )
                
                // Journey line
                Rectangle()
                    .fill(segmentColor)
                    .frame(width: lineWidth, height: 80)
                
                // Arrival station circle (if not last)
                if !isLast {
                    Circle()
                        .fill(Color.white)
                        .frame(width: circleSize, height: circleSize)
                        .overlay(
                            Circle()
                                .stroke(Color(.systemGray4), lineWidth: 2)
                        )
                } else {
                    // If this is the last segment, extend the line to connect with final destination
                    Rectangle()
                        .fill(segmentColor)
                        .frame(width: lineWidth, height: 16)
                }
            }
            .frame(width: timelineWidth)
            
            // Content column
            VStack(alignment: .leading, spacing: 0) {
                // Departure info - aligned with departure circle
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(formatTime(segment.departureTime))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if segment.type != .walk, let line = segment.line {
                            HStack(spacing: 4) {
                                Image(systemName: segment.type.icon)
                                    .foregroundColor(segmentColor)
                                    .font(.system(size: 12))
                                
                                Text(line)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(segmentColor)
                                    .lineLimit(1)
                            }
                        }
                    }
                    
                    Text(segment.from)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                }
                
                // Spacer to center journey details in the colored line area
                Spacer(minLength: 20)
                
                // Journey details - centered in journey line
                HStack {
                    if segment.type == .walk {
                        HStack(spacing: 6) {
                            Image(systemName: "figure.walk")
                                .foregroundColor(.orange)
                                .font(.system(size: 14))
                            
                            Text("徒歩 \(segment.duration)分")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            if let distance = segment.distance {
                                Text("(\(distance)m)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(segment.duration)分")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            if let direction = segment.direction {
                                Text(direction)
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if let cost = segment.cost {
                        Text("¥\(cost)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Spacer for arrival info
                if !isLast {
                    Spacer(minLength: 20)
                    
                    // Arrival info - aligned with arrival circle
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formatTime(segment.arrivalTime))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        
                        Text(segment.to)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                    }
                } else {
                    // Extra space for last segment to align with final destination
                    Spacer(minLength: 40)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var segmentColor: Color {
        if let colorHex = segment.color {
            return Color(hex: colorHex) ?? Color(hex: segment.type.defaultColor) ?? Color.blue
        }
        return Color(hex: segment.type.defaultColor) ?? Color.blue
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

struct FinalDestinationView: View {
    let segment: TransitSegment
    
    private let timelineWidth: CGFloat = 20
    private let circleSize: CGFloat = 18
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Fixed-width timeline column
            VStack(spacing: 0) {
                // Final destination circle (larger)
                Circle()
                    .fill(Color.white)
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Circle()
                            .stroke(segmentColor, lineWidth: 3)
                    )
            }
            .frame(width: timelineWidth)
            
            // Content column
            VStack(alignment: .leading, spacing: 4) {
                Text(formatTime(segment.arrivalTime))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(segment.to)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var segmentColor: Color {
        if let colorHex = segment.color {
            return Color(hex: colorHex) ?? Color(hex: segment.type.defaultColor) ?? Color.blue
        }
        return Color(hex: segment.type.defaultColor) ?? Color.blue
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
