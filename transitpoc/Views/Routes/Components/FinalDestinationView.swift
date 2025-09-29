//
//  FinalDestinationView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

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

#Preview {
    let sampleSegment = TransitSegment(
        type: .train,
        from: "渋谷",
        to: "新宿",
        departureTime: Date(),
        arrivalTime: Date().addingTimeInterval(600),
        duration: 10,
        line: "JR山手線",
        direction: "新宿・池袋方面",
        cost: 160,
        color: "#00B48D"
    )
    
    FinalDestinationView(segment: sampleSegment)
}