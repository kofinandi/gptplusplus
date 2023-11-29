//
//  Chat.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 29..
//

import Foundation

class Chat: Identifiable {
    let id: UUID
    var title: String
    var text: String
    
    init(id: UUID, title: String, text: String) {
        self.id = id
        self.title = title
        self.text = text
    }
}
