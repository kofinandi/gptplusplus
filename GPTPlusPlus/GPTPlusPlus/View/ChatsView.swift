//
//  ChatsView.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import SwiftUI

struct ChatsView: View {
    let folder: Folder
    @StateObject var chatsViewModel: ChatsViewModel
    
    init(folder: Folder) {
        self.folder = folder
        self._chatsViewModel = StateObject(wrappedValue: ChatsViewModel(folder: folder))
    }
    
    var body: some View {
        List(chatsViewModel.chats, id: \.id) { chat in
            NavigationLink(destination: ChatView(chatDetails: chat)) {
                Text(chat.title)
            }
        }
        .navigationTitle(self.folder.name)
        .navigationBarItems(trailing:
            Button(action: {
                print("Add new chat")
            }) {
                Image(systemName: "plus")
            }
        )
    }
}

struct Chats_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(folder: globalStorage.getAllFolders()[0])
    }
}
