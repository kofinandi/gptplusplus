//
//  ChatPopupViewModel.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 30..
//

import Foundation

class ChatPopupViewModel: ObservableObject {
    @Published var chatDetails: ChatDetails
    
    init(chatDetails: ChatDetails) {
        self.chatDetails = chatDetails
        
    }
    
    func exportChat() {
        
    }
}
