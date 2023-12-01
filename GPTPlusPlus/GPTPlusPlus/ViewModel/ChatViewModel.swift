//
//  ChatViewModelTest.swift
//  GPTPlusPlus
//
//  Created by KiDani on 2023. 11. 30..
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var chatDetails: ChatDetails
    @Published var messageViewModels: [MessageViewModel] = []
    
    init(chatDetails: ChatDetails) {
        self.chatDetails = chatDetails
        messageViewModels = globalStorage.messages[chatDetails]?.map { MessageViewModel(message: $0, chatViewModel: self) } ?? []
    }
    
    func sendMessage(text: String, sender: Message.Sender = .user) {
        let message = Message(sender: sender, text: text)
        messageViewModels.append(MessageViewModel(message: message, chatViewModel: self))
        globalStorage.addChatMessage(byChatDetails: chatDetails, message: message)
    }
    
    func deleteMessage(message: Message) {
        messageViewModels.removeAll { $0.message.id == message.id }
        globalStorage.deleteChatMessage(byChatDetails: chatDetails, message: message)
    }
    
    func insertMessage(message: Message, bellow: Message) {
        guard let index = messageViewModels.firstIndex(where: { $0.message.id == bellow.id }) else { return }
        messageViewModels.insert(MessageViewModel(message: message, chatViewModel: self), at: index + 1)
        globalStorage.insertChatMessage(byChatDetails: chatDetails, message: message, bellow: bellow)
    }
    
    func updateChatDetails(with: ChatDetails) {
        globalStorage.updateChatDetails(with: with)
        self.chatDetails = with
    }
}
