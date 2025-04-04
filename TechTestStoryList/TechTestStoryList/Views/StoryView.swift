//
//  StoryView.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import SwiftUI
import Kingfisher

struct StoryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: StoryViewModel
    @State private var timer: Timer?
    @State private var progress: CGFloat = 0.0
    @State private var isAnimatingLike = false
    @State private var isLiked = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                headerView
                progressView
                storyImageView
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.currentStory.id) {
            isLiked = viewModel.isLiked()
            startTimer()
        }
        .onAppear {
            isLiked = viewModel.isLiked()
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
}

extension StoryView {
    
    private var headerView: some View {
        HStack(spacing: 10) {
            KFImage(viewModel.currentUser.profileImageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
            
            Text(viewModel.currentUser.name)
                .foregroundColor(.white)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
            
            CloseButtonView {
                dismiss()
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
    private var progressView: some View {
        GeometryReader { geometry in
            HStack(spacing: 4) {
                ForEach(viewModel.stories.indices, id: \.self) { index in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                        
                        if index < viewModel.currentStoryIndex {
                            Capsule()
                                .fill(Color.white)
                                .frame(maxWidth: .infinity)
                        } else if index == viewModel.currentStoryIndex {
                            Capsule()
                                .fill(Color.white)
                                .frame(width: progressBarWidth(for: geometry.size.width))
                                .animation(.linear(duration: 0.1), value: progress)
                        }
                    }
                }
            }
        }
        .frame(height: 3)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    private var storyImageView: some View {
        ZStack(alignment: .topTrailing) {
            KFImage(viewModel.currentStory.imageURL)
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
                .onTapGesture { location in
                    handleTap(location: location)
                }
                .gesture(
                    DragGesture().onEnded { value in
                        if value.translation.height > 50 {
                            dismiss()
                        }
                    }
                )
            
            LikeButtonView(isLiked: $isLiked) {
                viewModel.toggleLike()
            }
            .padding(12)
        }
        .padding(.horizontal, 20)
    }
}

extension StoryView {
    private func handleTap(location: CGPoint) {
        let screenWidth = UIScreen.main.bounds.width
        if location.x < screenWidth / 2 {
            viewModel.previousStory()
        } else {
            viewModel.nextStory()
        }
    }
    
    private func startTimer() {
        progress = 0.0
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { t in
            if progress < 1.0 {
                progress += 0.01
            } else {
                t.invalidate()
                progress = 0.0
                
                Task { @MainActor in
                    viewModel.nextStory()
                    startTimer()
                }
            }
        }
    }
    
    private func progressBarWidth(for totalWidth: CGFloat) -> CGFloat {
        let count = CGFloat(viewModel.stories.count)
        let spacing: CGFloat = 4
        let totalSpacing = spacing * (count - 1)
        let availableWidth = totalWidth - totalSpacing
        let segmentWidth = availableWidth / count
        return segmentWidth * progress
    }
}



