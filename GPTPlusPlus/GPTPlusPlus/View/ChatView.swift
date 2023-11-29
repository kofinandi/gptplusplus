//
//  Chat.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import SwiftUI

struct ChatView: View {
    let chatDetails: ChatDetails
    @StateObject var chatViewModel: ChatViewModel
    
    init(chatDetails: ChatDetails) {
        self.chatDetails = chatDetails
        self._chatViewModel = StateObject(wrappedValue: ChatViewModel(chatDetails: chatDetails))
    }
    
    var body: some View {
        NavigationView {
            // Display chat messages
            // Input field for new messages
            // Button to open Popup View to edit chat settings
        }
        .navigationTitle("Chat")
        .navigationBarItems(trailing:
            NavigationLink(destination: PopupView()) {
                Image(systemName: "ellipsis.circle")
            }
        )
        .onAppear {
            // Load chat messages based on chatID

        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatDetails: globalStorage.getChatDetails(byFolderID: globalStorage.getAllFolders()[0].id)[0])
    }
}
