//
//  StationHistory.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation
import SwiftData

@Model
final class StationHistory: Identifiable {
    var id: String
    var stationName: String
    var stationType: String // "from" or "to" 
    var timestamp: Date
    var usageCount: Int
    
    init(stationName: String, stationType: String) {
        self.id = UUID().uuidString
        self.stationName = stationName
        self.stationType = stationType
        self.timestamp = Date()
        self.usageCount = 1
    }
    
    func incrementUsage() {
        self.usageCount += 1
        self.timestamp = Date()
    }
}
