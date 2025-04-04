//
//  CloseButtonView.swift
//  TechTestStoryList
//
//  Created by Анастасия Набатова on 4/4/25.
//

import SwiftUI

struct CloseButtonView: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .foregroundColor(.white)
                .padding()
        }
    }
}
