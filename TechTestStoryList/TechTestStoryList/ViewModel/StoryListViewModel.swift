//
//  StoryListViewModel.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import Foundation

@MainActor
class StoryListViewModel: ObservableObject {
    @Published var stateStorage = StoryStateStorage()
    @Published var users: [User] = []
    let userService = UserService()
    
    func loadUsers() async {
        do {
            var result = try await userService.fetchUsers()
            for index in result.indices {
                let count = Int.random(in: 1...3)
                result[index].stories = (0..<count).map { i in
                    let userID = result[index].id
                    let storyID = "\(userID)-story-\(i)"
                    let imageURL = URL(string: "https://picsum.photos/400/700?user=\(userID)&story=\(i)")!
                    
                    return Story(id: storyID, imageURL: imageURL)
                }
            }
            
            users = result
            
            await MainActor.run {
                self.users = result
            }
        } catch {
            print("\(error)")
        }
    }
    
    func appendMoreUsers() {
        users.append(contentsOf: users)
    }
}
