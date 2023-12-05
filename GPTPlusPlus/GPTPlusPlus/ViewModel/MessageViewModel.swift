//
//  MessageViewModel.swift
//  GPTPlusPlus
//
//  Created by KiDani on 2023. 11. 30..
//

import Foundation

class MessageViewModel: ObservableObject, Identifiable {
    @Published var message: Message
    @Published var iconName: String = ""
    private let chatViewModel: ChatViewModel
    
    let id = UUID()
    
    init(message: Message, chatViewModel: ChatViewModel) {
        self.message = message
        self.chatViewModel = chatViewModel
        iconName = MessageViewModel.getIconName(sender: message.sender)
    }
    
    static func getIconName(sender: Message.Sender) -> String {
        switch sender {
        case .user:
            return "person.crop.circle.fill"
        case .gpt:
            return "antenna.radiowaves.left.and.right"
        case .system:
            return "gearshape.fill"
        }
    }
    
    func cycleMessageSender() {
        switch message.sender {
        case .user:
            message.sender = .gpt
        case .gpt:
            message.sender = .system
        case .system:
            message.sender = .user
        }
        iconName = MessageViewModel.getIconName(sender: message.sender)
        globalStorage.updateChatMessage(byChatDetails: chatViewModel.chatDetails, message: message)
    }
    
    func deleteMessage() {
        chatViewModel.deleteMessage(message: message)
    }
    
    func updateMessage(sender: Message.Sender, text: String) {
        message.sender = sender
        message.text = text
        iconName = MessageViewModel.getIconName(sender: message.sender)
        globalStorage.updateChatMessage(byChatDetails: chatViewModel.chatDetails, message: message)
    }
    
    func insertMessage(sender: Message.Sender, text: String) {
        let message = Message(sender: sender, text: text, chatDetailsID: chatViewModel.chatDetails.id, idx: self.message.idx)
        chatViewModel.insertMessage(message: message, bellow: self.message)
    }
}

