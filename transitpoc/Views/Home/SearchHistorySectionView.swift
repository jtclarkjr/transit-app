//
//  SearchHistorySectionView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

struct SearchHistorySectionView: View {
    let recentSearchHistory: [SearchHistory]
    let onHistoryItemTapped: (SearchHistory) -> Void
    
    var body: some View {
        if !recentSearchHistory.isEmpty {
            VStack(spacing: 12) {
                HStack {
                    Text("最近の検索")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("最大\(recentSearchHistory.count)件")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    ForEach(Array(recentSearchHistory.enumerated()), id: \.element.id) { index, item in
                        HomeSearchHistoryRowView(
                            item: item,
                            showDivider: index < recentSearchHistory.count - 1
                        ) {
                            onHistoryItemTapped(item)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
    }
}
