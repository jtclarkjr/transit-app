//
//  SearchHistory.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation
import SwiftData

@Model
final class SearchHistory: Identifiable {
    var id: String
    var from: String
    var to: String
    var fromType: String?
    var toType: String?
    var timestamp: Date
    var searchCount: Int
    
    init(from: String, to: String, fromType: String? = "station", toType: String? = "station") {
        self.id = UUID().uuidString
        self.from = from
        self.to = to
        self.fromType = fromType
        self.toType = toType
        self.timestamp = Date()
        self.searchCount = 1
    }
    
    func incrementSearchCount() {
        self.searchCount += 1
        self.timestamp = Date()
    }
}
