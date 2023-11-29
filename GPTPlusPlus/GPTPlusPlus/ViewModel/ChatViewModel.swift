//
//  ChatViewModel.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation

class ChatViewModel: ObservableObject {
    var chatDetails: ChatDetails
    
    init(chatDetails: ChatDetails) {
        self.chatDetails = chatDetails
    }
}
