//
//  File.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import Foundation

struct UsersResponse: Codable {
    let pages: [Page]
}

struct Page: Codable {
    let users: [User]
}

struct User: Identifiable, Codable, Hashable {
    let id: Int
    
    let name: String
    let profileImageURL: URL?
    var stories: [Story] = []
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case profileImageURL = "profile_picture_url"
    }
}


struct Story: Identifiable, Codable, Hashable {
    let id: String
    let imageURL: URL
}
