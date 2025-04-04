//
//  StoryStateStorage.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import Foundation

final class StoryStateStorage: ObservableObject {
    @Published private(set) var seenStories: Set<String>
    @Published private(set) var likedStories: Set<String>
    private let seenKey = "seen_stories"
    private let likedKey = "liked_stories"
    
    init() {
        seenStories = Self.loadSet(key: seenKey)
        likedStories = Self.loadSet(key: likedKey)
    }
    
    func isSeen(_ id: String) -> Bool {
        seenStories.contains(id)
    }
    
    func isLiked(_ id: String) -> Bool {
        likedStories.contains(id)
    }
    
    func markSeen(_ id: String) {
        guard !seenStories.contains(id) else { return }
        seenStories.insert(id)
        saveSet(seenStories, key: seenKey)
    }
    
    func toggleLike(_ id: String) {
        if likedStories.contains(id) {
            likedStories.remove(id)
        } else {
            likedStories.insert(id)
        }
        saveSet(likedStories, key: likedKey)
    }
    
    private func saveSet(_ set: Set<String>, key: String) {
        if let data = try? JSONEncoder().encode(set) {
            UserDefaults.standard.set(data, forKey: key)
        }
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    private static func loadSet(key: String) -> Set<String> {
        guard let data = UserDefaults.standard.data(forKey: key),
              let ids = try? JSONDecoder().decode(Set<String>.self, from: data) else {
            return []
        }
        return ids
    }
}
