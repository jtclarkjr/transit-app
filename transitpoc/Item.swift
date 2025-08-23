//
//  Item.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
