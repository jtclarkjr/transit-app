//
//  TransitDataMapper.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/29.
//

import Foundation

class TransitDataMapper {
    static let shared = TransitDataMapper()
    
    private init() {}
    
    /// Converts API TransitResponse to array of TransitRoute objects for SwiftData
    func mapTransitResponse(_ response: TransitResponse) -> [TransitRoute] {
        guard let items = response.items else { return [] }
        
        return items.compactMap { item in
            mapTransitRouteItem(item)
        }
    }
    
    private func mapTransitRouteItem(_ item: TransitRouteItem) -> TransitRoute? {
        let summary = item.summary
        
        // Parse times with timezone support
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withTimeZone]
        
        guard let departureTime = formatter.date(from: summary.move.fromTime),
              let arrivalTime = formatter.date(from: summary.move.toTime) else {
            print("Failed to parse dates: \(summary.move.fromTime) -> \(summary.move.toTime)")
            return nil
        }
        
        print("Successfully parsed dates: \(summary.move.fromTime) -> \(summary.move.toTime)")
        
        // Extract segments
        let segments = mapRouteSegments(item.sections)
        
        // Calculate total cost (using unit_0 as primary fare)
        let totalCost = summary.move.fare.unit0
        
        let route = TransitRoute(
            from: summary.start.name,
            to: summary.goal.name,
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            totalTime: summary.move.time,
            totalCost: totalCost,
            transferCount: summary.move.transitCount,
            segments: segments
        )
        
        // Set enhanced properties
        route.routeNumber = summary.no
        route.totalDistance = summary.move.distance
        route.startLatitude = summary.start.coord.lat
        route.startLongitude = summary.start.coord.lon
        route.goalLatitude = summary.goal.coord.lat
        route.goalLongitude = summary.goal.coord.lon
        
        // Store fare options
        var fareOptions: [String: Int] = [:]
        fareOptions["regular"] = summary.move.fare.unit0
        fareOptions["ic_card"] = summary.move.fare.unit48
        if let trainFare128 = summary.move.fare.unit128Train {
            fareOptions["train_128"] = trainFare128
        }
        if let trainFare130 = summary.move.fare.unit130Train {
            fareOptions["train_130"] = trainFare130
        }
        if let trainFare133 = summary.move.fare.unit133Train {
            fareOptions["train_133"] = trainFare133
        }
        route.fareOptions = fareOptions
        
        return route
    }
    
    private func mapRouteSegments(_ sections: [RouteSection]) -> [TransitSegment] {
        var segments: [TransitSegment] = []
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withTimeZone]
        
        // Process sections in pairs: point -> move -> point
        for i in 0..<sections.count {
            let section = sections[i]
            
            if section.type == "move" {
                // Find the previous and next point sections
                let fromPoint = findPreviousPoint(in: sections, before: i)
                let toPoint = findNextPoint(in: sections, after: i)
                
                guard let from = fromPoint?.name,
                      let to = toPoint?.name,
                      let departureTime = section.fromTime.flatMap({ formatter.date(from: $0) }),
                      let arrivalTime = section.toTime.flatMap({ formatter.date(from: $0) }),
                      let duration = section.time else {
                    print("Skipping segment due to missing data: from=\(fromPoint?.name ?? "nil"), to=\(toPoint?.name ?? "nil")")
                    continue
                }
                
                let transportType = mapTransportType(from: section.move)
                let cost = section.transport?.fare.unit0
                
                let segment = TransitSegment(
                    type: transportType,
                    from: from,
                    to: to,
                    departureTime: departureTime,
                    arrivalTime: arrivalTime,
                    duration: duration,
                    line: section.lineName,
                    direction: section.transport?.name,
                    cost: cost,
                    distance: section.distance,
                    color: section.transport?.color
                )
                
                segments.append(segment)
                print("Added segment: \(from) → \(to) (\(transportType.displayName))")
            }
        }
        
        return segments
    }
    
    private func findPreviousPoint(in sections: [RouteSection], before index: Int) -> RouteSection? {
        for i in (0..<index).reversed() {
            if sections[i].type == "point" {
                return sections[i]
            }
        }
        return nil
    }
    
    private func findNextPoint(in sections: [RouteSection], after index: Int) -> RouteSection? {
        for i in (index + 1)..<sections.count {
            if sections[i].type == "point" {
                return sections[i]
            }
        }
        return nil
    }
    
    private func getNextStationFromSections(_ sections: [RouteSection], after currentSection: RouteSection) -> String? {
        if let currentIndex = sections.firstIndex(where: { $0.name == currentSection.name && $0.type == currentSection.type }) {
            // Find the next "point" type section
            for i in (currentIndex + 1)..<sections.count {
                if sections[i].type == "point" {
                    return sections[i].name
                }
            }
        }
        return nil
    }
    
    private func mapTransportType(from move: String?) -> TransportType {
        guard let move = move else { return .train }
        
        switch move.lowercased() {
        case "walk":
            return .walk
        case "local_train", "rapid_train", "express_train":
            return .train
        case "bus":
            return .bus
        case "subway":
            return .subway
        default:
            return .train
        }
    }
}

// MARK: - Helper Extensions

extension ISO8601DateFormatter {
    static let transitAPIFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
