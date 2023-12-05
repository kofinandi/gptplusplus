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
    @State private var rotation: Double = 0.0
    
    @State private var draftText: String = ""
    @State private var scrollToBottom = false
    @State private var selectedSender: Message.Sender = .user

    @State private var promptContextMenuVisible = false
    
    init(chatDetails: ChatDetails) {
        self._chatViewModel = StateObject(wrappedValue: ChatViewModel(chatDetails: chatDetails))
        self._modifyChat = StateObject(wrappedValue: ChatDetails(folderID: chatDetails.folderID))
    }
    
    var body: some View {
        VStack {
            // Message List
            getChatList().padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            // Input Section
            getInputBar().padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color(white: 0.9), lineWidth: 9)
                )
        }
        .alert(isPresented: $chatViewModel.showApiError) {
            Alert(title: Text("GPT API Error"), message: Text(chatViewModel.apiError ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            scrollToBottom.toggle()
            chatViewModel.reloadData()
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
        .navigationBarItems(trailing: HStack {
            Button(action: {
                withAnimation {
                    if chatViewModel.requestInProgress {
                        chatViewModel.stopCurrentRequest()
                    } else {
                        chatViewModel.regenerateLastResponse()
                    }
                }
            }) {
                Image(systemName: chatViewModel.requestInProgress ? "stop" : "arrow.clockwise")
            }
            .disabled(chatViewModel.messageViewModels.isEmpty)
            
            Button(action: {
                modifyChat.copy(from: chatViewModel.chatDetails)
                modifyChatPresented = true
            }) {
                Image(systemName: "ellipsis.circle")
            }
        }
        )
    }

    @ViewBuilder func getChatList() -> some View {
        ScrollViewReader { scrollView in
            ScrollView {
                ForEach(chatViewModel.messageViewModels) { message in
                    MessageView(viewModel: message).id(message.id)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 12)
                }
            }
            .onChange(of: chatViewModel.scrollToBottomAnimated) { _ in
                withAnimation{
                    scrollView.scrollTo(chatViewModel.messageViewModels.last?.id, anchor: .bottom)
                }
            }
            .onChange(of: scrollToBottom) { _ in
                scrollView.scrollTo(chatViewModel.messageViewModels.last?.id, anchor: .bottom)
            }
        }
    }

    @ViewBuilder func getInputBar() -> some View {
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
                .onSubmit {
                    if draftText.isEmpty { return }
                    chatViewModel.sendMessage(text: draftText, sender: selectedSender)
                    draftText = ""
                }

            Menu {
                ForEach(chatViewModel.prompts) { prompt in
                    Button {
                        chatViewModel.sendMessage(text: prompt.text, sender: selectedSender)
                    } label: {
                        Text(prompt.title)
                    }
                }
                if chatViewModel.prompts.isEmpty {
                    Text("No Prompts Available")
                        .foregroundColor(.gray)
                }
            } label: {
                Image(systemName: "text.cursor")
            }
            
            Button(action: {
                if draftText.isEmpty { return }
                chatViewModel.sendMessage(text: draftText, sender: selectedSender)
                draftText = ""
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 24))
            }
            .disabled(chatViewModel.requestInProgress || draftText.isEmpty)
            .overlay(
                    chatViewModel.requestInProgress
                        ? Circle()
                            .trim(from: 0.4, to: 1.0) // Adjust the trim to create a missing part
                            .stroke(style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round))
                            .fill(Color.blue)
                            .frame(width: 30, height: 30)
                            .rotationEffect(.degrees(rotation))
                            .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false))
                            .onAppear() {
                                self.rotation += 360
                            }
                        : nil
                )
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(Color(white: 0.9).edgesIgnoringSafeArea(.bottom))
    }

}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatDetails: globalStorage.getChatDetails(byFolderID: globalStorage.getAllFolders()[0].id!)[0])
    }
}
