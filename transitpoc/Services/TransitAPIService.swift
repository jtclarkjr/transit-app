//
//  TransitAPIService.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import Foundation

class TransitAPIService {
    static let shared = TransitAPIService()
    
    private let baseURL: String
    private let session = URLSession.shared
    
    private init() {
        // Require baseURL from environment variable
        guard let envBaseURL = ProcessInfo.processInfo.environment["TRANSIT_API_BASE_URL"], !envBaseURL.isEmpty else {
            print("WARNING: TRANSIT_API_BASE_URL environment variable is not set or empty. API calls will fail.")
            self.baseURL = ""
            return
        }
        self.baseURL = envBaseURL
    }
    
    // MARK: - Autocomplete
    
    func searchStations(query: String) async throws -> [AutocompleteStation] {
        guard var urlComponents = URLComponents(string: "\(baseURL)/autocomplete") else {
            throw TransitAPIError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "word", value: query),
            URLQueryItem(name: "lang", value: "ja")
        ]
        
        guard let url = urlComponents.url else {
            throw TransitAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TransitAPIError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 429 {
                    throw TransitAPIError.rateLimitExceeded
                } else {
                    throw TransitAPIError.serverError(httpResponse.statusCode)
                }
            }
            
            let autocompleteResponse = try JSONDecoder().decode(AutocompleteResponse.self, from: data)
            let stations = autocompleteResponse.items ?? []
            
            return stations
            
        } catch let decodingError as DecodingError {
            throw TransitAPIError.decodingError(decodingError)
        } catch let error as TransitAPIError {
            throw error
        } catch {
            throw TransitAPIError.networkError(error)
        }
    }
    
    // MARK: - Transit Route Search
    
    func searchRoutes(start: String, goal: String, startTime: String) async throws -> TransitResponse {
        guard var urlComponents = URLComponents(string: "\(baseURL)/transit") else {
            throw TransitAPIError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "start", value: start),
            URLQueryItem(name: "goal", value: goal),
            URLQueryItem(name: "start_time", value: startTime),
            URLQueryItem(name: "lang", value: "ja")
        ]
        
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        guard let url = urlComponents.url else {
            throw TransitAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TransitAPIError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw TransitAPIError.serverError(httpResponse.statusCode)
            }
            
            let transitResponse = try JSONDecoder().decode(TransitResponse.self, from: data)
            
            return transitResponse
            
        } catch let decodingError as DecodingError {
            throw TransitAPIError.decodingError(decodingError)
        } catch let error as TransitAPIError {
            throw error
        } catch {
            throw TransitAPIError.networkError(error)
        }
    }
    
}
