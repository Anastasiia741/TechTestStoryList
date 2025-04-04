//
//  StoryAvatarView.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import SwiftUI
import Kingfisher

struct StoryAvatarView: View {
    let user: User
    @ObservedObject var storage: StoryStateStorage
    
    var body: some View {
        let isSeen = user.stories.allSatisfy { storage.isSeen($0.id) }
        
        return VStack(spacing: 4) {
            KFImage(user.profileImageURL)
                .placeholder {
                    ProgressView()
                }
                .cancelOnDisappear(true)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(isSeen ? Color.gray : Color.blue, lineWidth: 2.5)
                )
            
            Text(user.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}
