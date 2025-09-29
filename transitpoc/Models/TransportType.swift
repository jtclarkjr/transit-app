//
//  TransportType.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation

enum TransportType: String, CaseIterable, Codable {
    case walk = "walk"
    case train = "train"
    case bus = "bus"
    case subway = "subway"
    
    var icon: String {
        switch self {
        case .walk:
            return "figure.walk"
        case .train:
            return "train.side.front.car"
        case .bus:
            return "bus"
        case .subway:
            return "tram"
        }
    }
    
    var displayName: String {
        switch self {
        case .walk:
            return "徒歩"
        case .train:
            return "電車"
        case .bus:
            return "バス"
        case .subway:
            return "地下鉄"
        }
    }
    
    var defaultColor: String {
        switch self {
        case .walk:
            return "#FF9500"
        case .train:
            return "#007AFF"
        case .bus:
            return "#34C759"
        case .subway:
            return "#AF52DE"
        }
    }
}