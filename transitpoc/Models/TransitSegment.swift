//
//  TransitSegment.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation
import SwiftData

@Model
final class TransitSegment: Identifiable {
    var id: String
    var type: TransportType
    var from: String
    var to: String
    var departureTime: Date
    var arrivalTime: Date
    var duration: Int // minutes
    var line: String?
    var direction: String?
    var cost: Int?
    var distance: Int? // meters for walking segments
    var color: String? // hex color from API
    
    init(
        id: String? = nil,
        type: TransportType,
        from: String,
        to: String,
        departureTime: Date,
        arrivalTime: Date,
        duration: Int,
        line: String? = nil,
        direction: String? = nil,
        cost: Int? = nil,
        distance: Int? = nil,
        color: String? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.type = type
        self.from = from
        self.to = to
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.duration = duration
        self.line = line
        self.direction = direction
        self.cost = cost
        self.distance = distance
        self.color = color
    }
}