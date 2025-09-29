//
//  RouteDetailTimelineView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

struct RouteDetailTimelineView: View {
    let segments: [TransitSegment]
    
    var body: some View {
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
}

#Preview {
    let sampleSegments = [
        TransitSegment(
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
        ),
        TransitSegment(
            type: .train,
            from: "新宿",
            to: "池袋",
            departureTime: Date().addingTimeInterval(720),
            arrivalTime: Date().addingTimeInterval(1320),
            duration: 10,
            line: "JR山手線",
            direction: "池袋・上野方面",
            cost: 160,
            color: "#00B48D"
        )
    ]
    
    RouteDetailTimelineView(segments: sampleSegments)
}