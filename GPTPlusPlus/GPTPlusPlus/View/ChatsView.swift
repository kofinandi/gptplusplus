//
//  ChatsView.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import SwiftUI

struct ChatsView: View {
    let folder: FolderPersisted
    @StateObject var chatsViewModel: ChatsViewModel
    @State var addNewChatPresented = false
    @State var modifyChatPresented = false
    @StateObject var newChat: ChatDetails
    @StateObject var modifyChat: ChatDetails
    @State var editingIndex: Int = 0
    @State var lastAdded = false
    @State var lastAddedIndex = 0
    
    init(folder: FolderPersisted) {
        self.folder = folder
        self._chatsViewModel = StateObject(wrappedValue: ChatsViewModel(folder: folder))
        self._newChat = StateObject(wrappedValue: ChatDetails(folderID: folder.id!))
        self._modifyChat = StateObject(wrappedValue: ChatDetails(folderID: folder.id!))
    }
    
    var body: some View {
        List(chatsViewModel.chats, id: \.id) { chat in
            NavigationLink(destination: ChatView(chatDetails: chat)) {
                Text(chat.title)
            }
            .contextMenu {
                Group {
                    Button(action: {
                        self.editingIndex = chatsViewModel.chats.firstIndex(where: { $0.id == chat.id })!
                        self.modifyChat.copy(from: chat)
                        self.modifyChatPresented = true
                    }) {
                        Text("Edit")
                        Image(systemName: "pencil")
                    }
                    Button(action: {
                        withAnimation{
                            chatsViewModel.deleteChatDetails(withID: chat.id)
                        }
                    }) {
                        Text("Delete")
                        Image(systemName: "trash.fill")
                    }
                }
            }
        }
        .navigationTitle(self.folder.name!)
        .navigationBarItems(trailing:
                                Button(action: {
            self.addNewChatPresented = true
            self.newChat.resetValues()
        }) {
            Image(systemName: "plus")
        }
        )
        .sheet(isPresented: $addNewChatPresented) {
            VStack {
                HStack {
                    Button("Cancel") {
                        self.addNewChatPresented = false
                    }
                    Spacer()
                    Button("Add") {
                        let copy = newChat.copy() as! ChatDetails
                        chatsViewModel.addNewChat(chatDetails: copy)
                        self.addNewChatPresented = false

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.lastAddedIndex = chatsViewModel.chats.firstIndex(where: { $0.id == copy.id })!
                            self.lastAdded = true
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                ChatPopupView(title: "Create chat", chatDetails: newChat)
            }
            .padding(EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32))
        }
        .sheet(isPresented: $modifyChatPresented) {
            VStack {
                HStack {
                    Button("Cancel") {
                        self.modifyChatPresented = false
                    }
                    Spacer()
                    Button("Save") {
                        chatsViewModel.chats[editingIndex].copy(from: modifyChat)
                        chatsViewModel.updateChatDetails(with: chatsViewModel.chats[editingIndex])
                        self.modifyChatPresented = false
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                ChatPopupView(title: "Edit chat", chatDetails: modifyChat, showExport: true)
            }
            .padding(EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32))
        }
        .background(
            List {
                if !chatsViewModel.chats.isEmpty {
                    NavigationLink(destination: ChatView(chatDetails:  chatsViewModel.chats[lastAddedIndex]), isActive: $lastAdded) {
                        EmptyView()
                    }
                    .opacity(0) // Hide the link view
                    .disabled(true)
                }
            }
        )
    }
}

struct Chats_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(folder: globalStorage.getAllFolders()[0])
    }
}
