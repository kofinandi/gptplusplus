//
//  ChatPopupViewModel.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 30..
//

import Foundation

class ChatPopupViewModel: ObservableObject {
    @Published var chatDetails: ChatDetails
    @Published var filename: String = ""
    @Published var prompts: [Prompt] = []
    
    init(chatDetails: ChatDetails) {
        self.chatDetails = chatDetails
        prompts = SettingsStorage.instance.prompts
    }

    func updatePrompts() {
        prompts = SettingsStorage.instance.prompts
    }
    
    func exportChat() {
        let messages = globalStorage.getChatMessages(byChatDetails: chatDetails)

        var text = ""
        for message in messages {
            text += "\(message.sender.name): \(message.text)\n"
        }
        
        filename = chatDetails.title + ".txt"
        
        writeToFile(filename: filename, text: text)
    }
}
