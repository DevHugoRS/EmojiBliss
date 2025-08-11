//
//  RandomEmojiView.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import SwiftUI

struct RandomEmojiView: View {
//    MARK: - PROPERTIES
    @StateObject private var viewModel = EmojiViewModel()
    @State private var selectedEmoji: Emoji?
    
//    MARK: - BODY
    var body: some View {
        VStack(spacing: 20) {
            if let emoji = selectedEmoji {
                AsyncImage(url: URL(string: emoji.url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .padding()
                
                Text(emoji.name)
                    .font(.headline)
            } else {
                ProgressView("Loading emojis...")
            }
            
            Button("Random Emoji") {
                selectedEmoji = viewModel.getRandomEmoji()
            } //: BUTTON
            .buttonStyle(.borderedProminent)
        } //: VSTACK
        .navigationTitle("Random Emoji")
        .task {
            await viewModel.getEmojis()
            selectedEmoji = viewModel.getRandomEmoji()
        }
    }
}
//    MARK: - PREVIEW
#Preview {
    RandomEmojiView()
}
