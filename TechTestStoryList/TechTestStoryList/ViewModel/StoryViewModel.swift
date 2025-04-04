//
//  StoryViewModel.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import SwiftUI

@MainActor
class StoryViewModel: ObservableObject {
    @Published var currentUserIndex: Int
    @Published var currentStoryIndex: Int = 0
    let storage: StoryStateStorage
    
    let users: [User]
    
    var currentUser: User { users[currentUserIndex] }
    var stories: [Story] { currentUser.stories }
    var currentStory: Story { stories[currentStoryIndex] }
    
    init(users: [User], initialUserIndex: Int, storage: StoryStateStorage) {
        self.users = users
        self._currentUserIndex = .init(initialValue: initialUserIndex)
        self.storage = storage
    }
    
    func nextStory() {
        if currentStoryIndex < stories.count - 1 {
            currentStoryIndex += 1
        } else {
            nextUser()
        }
        markSeen()
    }
    
    func previousStory() {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
        }
    }
    
    func nextUser() {
        if currentUserIndex < users.count - 1 {
            currentUserIndex += 1
            currentStoryIndex = 0
        }
    }
    
    func markSeen() {
        storage.markSeen(currentStory.id)
    }
    
    func toggleLike() {
        storage.toggleLike(currentStory.id)
    }
    
    func isLiked() -> Bool {
        storage.isLiked(currentStory.id)
    }
}






