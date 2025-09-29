//
//  TagView.swift
//  transitpoc
//
//  Created by James Clark on 2025/08/23.
//

import SwiftUI

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.1))
            .cornerRadius(4)
    }
}

#Preview {
    HStack {
        TagView(text: "直通", color: .green)
        TagView(text: "早", color: .blue)
        TagView(text: "安", color: .orange)
    }
}