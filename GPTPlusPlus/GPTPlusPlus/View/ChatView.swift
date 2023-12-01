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
    
    @State private var draftText: String = ""
    @State private var scrollToBottomAnimated = false
    @State private var scrollToBottom = false
    @State private var selectedSender: Message.Sender = .user
    
    init(chatDetails: ChatDetails) {
        self._chatViewModel = StateObject(wrappedValue: ChatViewModel(chatDetails: chatDetails))
        self._modifyChat = StateObject(wrappedValue: ChatDetails(folderID: chatDetails.folderID))
    }
    
    var body: some View {
        VStack {
            // Message List
            ScrollViewReader { scrollView in
                ScrollView {
                    ForEach(chatViewModel.messageViewModels) { message in
                        MessageView(viewModel: message).id(message.id)
                            .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal, 8)
                .onChange(of: scrollToBottomAnimated) { _ in
                    withAnimation{
                        scrollView.scrollTo(chatViewModel.messageViewModels.last?.id, anchor: .bottom)
                    }
                }
                .onChange(of: scrollToBottom) { _ in
                    scrollView.scrollTo(chatViewModel.messageViewModels.last?.id, anchor: .bottom)
                }
            }
            
            // Input Section
            HStack {
                // A menu in which the user can select the sender of the message
                Menu {
                    ForEach(Message.Sender.allCases, id: \.self) { sender in
                        Button {
                            selectedSender = sender
                        } label: {
                            HStack {
                                Text(sender.name)
                                if sender == selectedSender {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: MessageViewModel.getIconName(sender: selectedSender))
                        .font(.system(size: 24))
                }
                
                TextField("Type your message...", text: $draftText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                
                Button(action: {
                    if draftText.isEmpty { return }
                    chatViewModel.sendMessage(text: draftText, sender: selectedSender)
                    draftText = ""
                    scrollToBottomAnimated.toggle()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 24))
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2).edgesIgnoringSafeArea(.bottom))
        }
        .onAppear {
            scrollToBottom.toggle()
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
        .navigationTitle(chatViewModel.chatDetails.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            modifyChat.copy(from: chatViewModel.chatDetails)
            modifyChatPresented = true
        }) {
            Image(systemName: "ellipsis.circle")
        }
        )
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatDetails: globalStorage.getChatDetails(byFolderID: globalStorage.getAllFolders()[0].id)[0])
    }
}
