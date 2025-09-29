//
//  AutocompleteItem.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation
import SwiftData

@Model
final class AutocompleteItem: Identifiable {
    var id: String
    var name: String
    var type: StationType
    var city: String?
    var prefecture: String?
    var timestamp: Date
    
    init(id: String, name: String, type: StationType, city: String? = nil, prefecture: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.city = city
        self.prefecture = prefecture
        self.timestamp = Date()
    }
}

enum StationType: String, CaseIterable, Codable {
    case station = "station"
    case landmark = "landmark" 
    case address = "address"
    
    var displayName: String {
        switch self {
        case .station:
            return "駅"
        case .landmark:
            return "施設"
        case .address:
            return "住所"
        }
    }
}
