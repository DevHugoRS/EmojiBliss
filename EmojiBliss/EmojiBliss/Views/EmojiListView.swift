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
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                ForEach(viewModel.emojis) { emoji in
                    AsyncImage(url: URL(string: emoji.url))
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            // remove
                        }
                } //: LOOP
            } //: GRID
        } //: SROLL
        .navigationTitle("Emojis")
        .task {
            await viewModel.getEmojis()
        }
    }
}
//    MARK: - PREVIEW
#Preview {
    EmojiListView()
}
