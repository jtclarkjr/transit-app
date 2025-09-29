//
//  TransitDataMapperTests.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/29.
//

import Foundation

class TransitDataMapperTests {
    
    static func testAPIMapping() {
        print("Testing Transit API Data Mapping...")
        
        // Sample API response JSON (simplified version of the real response)
        let jsonString = """
        {
          "items": [{
            "summary": {
              "no": "1",
              "start": {
                "type": "point",
                "coord": {"lat": 35.710286, "lon": 139.813287},
                "name": "押上[スカイツリー前]",
                "node_id": "00000813",
                "node_types": ["station"]
              },
              "goal": {
                "type": "point",
                "coord": {"lat": 35.684855, "lon": 139.773372},
                "name": "三越前",
                "node_id": "00002964", 
                "node_types": ["station"]
              },
              "move": {
                "transit_count": 0,
                "fare": {"unit_0": 210, "unit_48": 209},
                "type": "move",
                "from_time": "2025-08-29T20:31:00+09:00",
                "to_time": "2025-08-29T20:43:00+09:00",
                "time": 12,
                "distance": 7300,
                "move_type": ["local_train"]
              }
            },
            "sections": [
              {
                "type": "point",
                "coord": {"lat": 35.710286, "lon": 139.813287},
                "name": "押上[スカイツリー前]",
                "node_id": "00000813",
                "node_types": ["station"]
              },
              {
                "type": "move",
                "transport": {
                  "fare": {"unit_0": 210, "unit_48": 209},
                  "color": "#8F76D6",
                  "name": "東京メトロ半蔵門線",
                  "fare_season": "normal",
                  "company": {"id": "00000113", "name": "東京地下鉄（メトロ）"},
                  "id": "00000451",
                  "type": "普通"
                },
                "move": "local_train",
                "from_time": "2025-08-29T20:31:00+09:00",
                "to_time": "2025-08-29T20:43:00+09:00",
                "time": 12,
                "distance": 7300,
                "line_name": "東京メトロ半蔵門線"
              },
              {
                "type": "point",
                "coord": {"lat": 35.684855, "lon": 139.773372},
                "name": "三越前",
                "node_id": "00002964",
                "node_types": ["station"]
              }
            ]
          }],
          "unit": {
            "datum": "wgs84",
            "coord_unit": "degree",
            "distance": "metre",
            "time": "minute",
            "currency": "JPY"
          }
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to create JSON data")
            return
        }
        
        do {
            let response = try JSONDecoder().decode(TransitResponse.self, from: jsonData)
            print("JSON decoded successfully")
            
            let routes = TransitDataMapper.shared.mapTransitResponse(response)
            print("Mapped \(routes.count) routes")
            
            if let firstRoute = routes.first {
                print("Route Details:")
                print("   From: \(firstRoute.from)")
                print("   To: \(firstRoute.to)")
                print("   Duration: \(firstRoute.durationText)")
                print("   Cost: \(firstRoute.costText)")
                print("   Transfers: \(firstRoute.transferText)")
                print("   Route Number: \(firstRoute.routeNumber ?? "N/A")")
                print("   Distance: \(firstRoute.totalDistance ?? 0)m")
                print("   Segments: \(firstRoute.segments?.count ?? 0)")
                
                if let segments = firstRoute.segments {
                    for (index, segment) in segments.enumerated() {
                        print("   Segment \(index + 1): \(segment.from) → \(segment.to) (\(segment.type.displayName))")
                        if let line = segment.line {
                            print("      Line: \(line)")
                        }
                        if let color = segment.color {
                            print("      Color: \(color)")
                        }
                    }
                }
            }
            
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }
}

