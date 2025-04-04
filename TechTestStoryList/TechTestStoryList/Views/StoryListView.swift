//
//  ContentView.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import SwiftUI
import Kingfisher

struct StoryListView: View {
    @StateObject private var viewModel = StoryListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack() {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        avatarList
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadUsers()
            }
        }
    }
}

extension StoryListView {
    private var avatarList: some View {
        ForEach(Array(viewModel.users.enumerated()), id: \.offset) { index, user in
            NavigationLink(
                destination: StoryView(
                    viewModel: StoryViewModel(users: viewModel.users,
                                              initialUserIndex: index,
                                              storage: viewModel.stateStorage))
            ) {
                StoryAvatarView(user: user,
                                storage: viewModel.stateStorage)
            }
            .onAppear {
                if index == viewModel.users.count - 1 {
                    viewModel.appendMoreUsers()
                }
            }
        }
    }
}




