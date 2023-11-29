//
//  ChatViewModel.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var chatDetails: ChatDetails
    
    init(chatDetails: ChatDetails) {
        self.chatDetails = chatDetails
    }
    
    func updateChatDetails(with: ChatDetails) {
        globalStorage.updateChatDetails(with: with)
        self.chatDetails = with
    }
}
