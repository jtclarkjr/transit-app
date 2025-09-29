//
//  StationType+Extensions.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

extension StationType {
    var iconName: String {
        switch self {
        case .station:
            return "train.side.front.car"
        case .landmark:
            return "building.2.crop.circle"
        case .address:
            return "location.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .station:
            return .blue
        case .landmark:
            return .purple
        case .address:
            return .green
        }
    }
}