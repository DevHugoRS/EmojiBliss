//
//  ContentView.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 10/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Random Emoji", destination: RandomEmojiView())
                NavigationLink("Emoji List", destination: EmojiListView())
                NavigationLink("Search Avatar", destination: AvatarSearchView())
                NavigationLink("Avatar List", destination: AvatarListView())
                NavigationLink("Apple Repository", destination: RepositoryListView())
            } //: LIST
            .navigationTitle("Emoji Bliss")
        } //: NAV. STACK
    }
}

#Preview {
    ContentView()
}
