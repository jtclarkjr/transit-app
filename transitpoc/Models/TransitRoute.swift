//
//  TransitRoute.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation
import SwiftData

@Model
final class TransitRoute: Identifiable {
    var id: String
    var from: String
    var to: String
    var departureTime: Date
    var arrivalTime: Date
    var totalTime: Int // minutes
    var totalCost: Int
    var transferCount: Int
    var segments: [TransitSegment]?
    var isFavorite: Bool
    var searchTimestamp: Date
    
    // Enhanced properties from API
    var routeNumber: String? // "1", "2", etc. from API
    var totalDistance: Int? // meters
    var fareOptions: [String: Int]? // Different fare types from API
    
    // Coordinates stored as separate properties for SwiftData compatibility
    var startLatitude: Double?
    var startLongitude: Double?
    var goalLatitude: Double?
    var goalLongitude: Double?
    
    init(
        id: String? = nil,
        from: String,
        to: String,
        departureTime: Date,
        arrivalTime: Date,
        totalTime: Int,
        totalCost: Int,
        transferCount: Int,
        segments: [TransitSegment]? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.from = from
        self.to = to
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.totalTime = totalTime
        self.totalCost = totalCost
        self.transferCount = transferCount
        self.segments = segments
        self.isFavorite = false
        self.searchTimestamp = Date()
    }
    
    var durationText: String {
        let hours = totalTime / 60
        let minutes = totalTime % 60
        if hours > 0 {
            return "\(hours)時間\(minutes)分"
        }
        return "\(minutes)分"
    }
    
    var costText: String {
        return "¥\(totalCost.formatted())"
    }
    
    var transferText: String {
        if transferCount == 0 {
            return "直通"
        }
        return "乗換 \(transferCount)回"
    }
    
    // Computed properties for coordinate access
    var startCoordinates: (lat: Double, lon: Double)? {
        guard let lat = startLatitude, let lon = startLongitude else { return nil }
        return (lat: lat, lon: lon)
    }
    
    var goalCoordinates: (lat: Double, lon: Double)? {
        guard let lat = goalLatitude, let lon = goalLongitude else { return nil }
        return (lat: lat, lon: lon)
    }
}
