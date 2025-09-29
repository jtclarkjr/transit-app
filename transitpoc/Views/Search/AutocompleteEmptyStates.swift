//
//  AutocompleteEmptyStates.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("履歴がありません")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Text("駅名を検索すると、ここに履歴が表示されます")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
}

struct NoSearchResultsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("該当する駅が見つかりません")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Text("駅名や施設名を確認してください")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct SearchLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("検索中...")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .padding(.top, 16)
            Spacer()
        }
    }
}