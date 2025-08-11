//
//  EmojiListView.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import SwiftUI

struct EmojiListView: View {
//    MARK: - PROPERTIES
    @StateObject var viewModel = EmojiViewModel()
    
//    MARK: - BODY
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 10) {
                ForEach(viewModel.emojis) { emoji in
                    VStack {
                        AsyncImage(url: URL(string: emoji.url)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                        }
                        .onTapGesture {
                            withAnimation {
                                viewModel.removeEmojiFromMemory(emoji)
                            }
                        }
                    } //: VSTACK
                } //: LOOP
            } //: GRID
            .padding()
        } //: SROLL
        .navigationTitle("Emojis")
        .refreshable {
            await viewModel.reloadFromCache()
        }
        .task {
            await viewModel.getEmojis()
        }
    }
}
//    MARK: - PREVIEW
#Preview {
    EmojiListView()
}
