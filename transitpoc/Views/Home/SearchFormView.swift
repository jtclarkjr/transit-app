//
//  SearchFormView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

struct SearchFormView: View {
    @Binding var fromStation: String
    @Binding var toStation: String
    let isSearching: Bool
    let onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                // From Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("出発")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    StationSearchField(
                        title: "出発駅を選択",
                        placeholder: "駅名を入力",
                        stationType: "from",
                        value: $fromStation
                    )
                }
                
                // Swap button
                Button(action: swapStations) {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                }
                
                // To Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("到着")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    StationSearchField(
                        title: "到着駅を選択",
                        placeholder: "駅名を入力",
                        stationType: "to",
                        value: $toStation
                    )
                }
            }
            
            // Search Button
            Button(action: onSearch) {
                HStack {
                    if isSearching {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Image(systemName: "magnifyingglass")
                    }
                    Text("ルート検索")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .disabled(fromStation.isEmpty || toStation.isEmpty || isSearching)
        }
        .padding()
        .padding(.horizontal)
    }
    
    private func swapStations() {
        let temp = fromStation
        fromStation = toStation
        toStation = temp
    }
}