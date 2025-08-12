//
//  AvatarListView.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 12/08/25.
//

import SwiftUI

struct AvatarListView: View {
//    MARK: - PROPERTIES
    @StateObject private var viewModel = AvatarViewModel()
    
//    MARK: - BODY
    var body: some View {
        List {
            ForEach(viewModel.avatars) { avatar in
                HStack {
                    AsyncImage(url: URL(string: avatar.avatarUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    
                    Text(avatar.login)
                } //: HSTACK
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        viewModel.deleteAvatar(avatar)
                    }
                }
            } //: LOOP
        } //: LIST
        .navigationTitle("Avatar List")
        .onAppear {
            viewModel.loadAvatars()
        }
    }
}

//    MARK: - PREVIEW
#Preview {
    AvatarListView()
}
