//
//  Chat.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import SwiftUI

struct ChatView: View {
    @StateObject var chatViewModel: ChatViewModel
    @StateObject var modifyChat: ChatDetails
    @State var modifyChatPresented = false
    
    init(chatDetails: ChatDetails) {
        self._chatViewModel = StateObject(wrappedValue: ChatViewModel(chatDetails: chatDetails))
        self._modifyChat = StateObject(wrappedValue: ChatDetails(folderID: chatDetails.folderID))
    }
    
    var body: some View {
        NavigationView {
            // Display chat messages
            // Input field for new messages
            // Button to open Popup View to edit chat settings
        }
        .navigationTitle(chatViewModel.chatDetails.title)
        .navigationBarItems(trailing: Button(action: {
            modifyChat.copy(from: chatViewModel.chatDetails)
            modifyChatPresented = true
        }) {
            Image(systemName: "ellipsis.circle")
        }
        )
        .onAppear {
            // Load chat messages based on chatID
            
        }
        .sheet(isPresented: $modifyChatPresented) {
            VStack {
                HStack {
                    Button("Cancel") {
                        self.modifyChatPresented = false
                    }
                    Spacer()
                    Button("Save") {
                        chatViewModel.chatDetails.copy(from: modifyChat)
                        chatViewModel.updateChatDetails(with: chatViewModel.chatDetails)
                        self.modifyChatPresented = false
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                ChatPopupView(title: "Edit chat", chatDetails: modifyChat, showExport: true)
            }
            .padding(EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32))
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatDetails: globalStorage.getChatDetails(byFolderID: globalStorage.getAllFolders()[0].id)[0])
    }
}
