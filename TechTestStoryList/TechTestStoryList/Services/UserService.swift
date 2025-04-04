//
//  UserService.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import Foundation

final class UserService {
    private let url = API.userDataURL
    
    func fetchUsers() async throws -> [User] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(UsersResponse.self, from: data)
        return response.pages.flatMap { $0.users }
    }
}
