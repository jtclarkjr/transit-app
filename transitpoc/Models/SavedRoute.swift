//
//  SavedRoute.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation
import SwiftData

@Model 
final class SavedRoute: Identifiable {
    var id: String
    var name: String
    var route: TransitRoute?
    var createdDate: Date
    var isActive: Bool
    
    init(name: String, route: TransitRoute) {
        self.id = UUID().uuidString
        self.name = name
        self.route = route
        self.createdDate = Date()
        self.isActive = true
    }
}