//
//  APIModels.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation

// MARK: - Minimal API Models

struct AutocompleteResponse: Codable {
    let items: [AutocompleteStation]?
}

struct AutocompleteStation: Codable, Identifiable {
    let id: String
    let name: String
    let type: String
    
    var stationType: StationType {
        switch type.lowercased() {
        case "station":
            return .station
        case "landmark":
            return .landmark
        case "address":
            return .address
        default:
            return .station
        }
    }
}

struct TransitResponse: Codable {
    let items: [TransitRouteItem]?
    let unit: TransitUnit?
}

struct TransitRouteItem: Codable {
    let summary: RouteSummary
    let sections: [RouteSection]
}

struct RouteSummary: Codable {
    let no: String
    let start: RoutePoint
    let goal: RoutePoint
    let move: RouteMove
}

struct RoutePoint: Codable {
    let name: String
    let coord: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case name, coord
    }
}

struct RouteMove: Codable {
    let transitCount: Int
    let fare: FareInfo
    let fromTime: String
    let toTime: String
    let time: Int
    let distance: Int
    
    enum CodingKeys: String, CodingKey {
        case transitCount = "transit_count"
        case fare
        case fromTime = "from_time"
        case toTime = "to_time"
        case time, distance
    }
}

struct RouteSection: Codable {
    let type: String
    let name: String?
    let transport: TransportInfo?
    let move: String?
    let fromTime: String?
    let toTime: String?
    let time: Int?
    let distance: Int?
    let lineName: String?
    
    enum CodingKeys: String, CodingKey {
        case type, name, transport, move
        case fromTime = "from_time"
        case toTime = "to_time"
        case time, distance
        case lineName = "line_name"
    }
}

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}

struct FareInfo: Codable {
    let unit0: Int
    let unit48: Int
    let unit128Train: Int?
    let unit130Train: Int?
    let unit133Train: Int?
    
    enum CodingKeys: String, CodingKey {
        case unit0 = "unit_0"
        case unit48 = "unit_48"
        case unit128Train = "unit_128_train"
        case unit130Train = "unit_130_train"
        case unit133Train = "unit_133_train"
    }
}

struct TransportInfo: Codable {
    let fare: FareInfo
    let color: String?
    let name: String?
}

struct TransitUnit: Codable {
    let currency: String?
}

// MARK: - API Errors

enum TransitAPIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case networkError(Error)
    case decodingError(DecodingError)
    case rateLimitExceeded
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .serverError(let code):
            return "Server error: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .rateLimitExceeded:
            return "Rate limit exceeded - using offline data"
        }
    }
}