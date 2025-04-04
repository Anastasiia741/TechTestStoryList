//
//  LikeButtonView.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import SwiftUI

struct LikeButtonView: View {
    @Binding var isLiked: Bool
    var onToggle: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isAnimating = true
                isLiked.toggle()
                onToggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(isLiked ? .red : .white)
                .scaleEffect(isAnimating ? 1.3 : 1.0)
                .animation(.spring(), value: isAnimating)
        }
        .padding()
    }
}


