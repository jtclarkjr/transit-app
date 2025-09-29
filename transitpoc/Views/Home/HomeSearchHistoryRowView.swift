//
//  HomeSearchHistoryRowView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI
import SwiftData

// Search History Row View with swipe-to-delete for Home screen
struct HomeSearchHistoryRowView: View {
    @Environment(\.modelContext) private var modelContext
    let item: SearchHistory
    let showDivider: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    // Route information
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(item.from)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.secondary)
                                .font(.system(size: 10))
                            
                            Text(item.to)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        
                        HStack(spacing: 12) {
                            Text(formatDate(item.timestamp))
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button("削除") {
                    deleteHistoryItem()
                }
                .tint(.red)
            }
            
            if showDivider {
                Divider()
                    .padding(.leading, 16)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    private func deleteHistoryItem() {
        withAnimation {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
}