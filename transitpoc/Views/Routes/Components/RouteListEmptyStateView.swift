//
//  RouteListEmptyStateView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

struct RouteListEmptyStateView: View {
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            
            Text("ルートが見つかりません")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("検索条件を変更して、もう一度お試しください。")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: onRetry) {
                Text("再試行")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 120, height: 44)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
    }
}

#Preview {
    RouteListEmptyStateView {
        print("Retry tapped")
    }
}