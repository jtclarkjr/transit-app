//
//  StationSearchField.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

struct StationSearchField: View {
    let title: String
    let placeholder: String
    let stationType: String // "from" or "to"
    @Binding var value: String
    @State private var showingAutocompleteSheet = false
    
    var body: some View {
        Button(action: {
            showingAutocompleteSheet = true
        }) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    if value.isEmpty {
                        Text(placeholder)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    } else {
                        Text(value)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 16))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingAutocompleteSheet) {
            AutocompleteSheetView(
                title: title,
                currentValue: value,
                stationType: stationType
            ) { selectedStation in
                value = selectedStation
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        StationSearchField(
            title: "出発駅",
            placeholder: "駅名を入力",
            stationType: "from",
            value: .constant("")
        )
        
        StationSearchField(
            title: "到着駅", 
            placeholder: "駅名を入力",
            stationType: "to",
            value: .constant("新宿")
        )
    }
    .padding()
}
