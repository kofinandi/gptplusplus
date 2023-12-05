//
//  Message.swift
//  GPTPlusPlus
//
//  Created by KiDani on 2023. 12. 01..
//

import Foundation

class Message: Identifiable {
    enum Sender: Int, CaseIterable, Codable {
        case user = 0
        case gpt = 1
        case system = 2
        
        var name: String {
            switch self {
            case .user:
                return "User"
            case .gpt:
                return "ChatGPT"
            case .system:
                return "System"
            }
        }
    }
    var id: UUID
    var sender: Sender
    var text: String
    var chatDetailsID: UUID
    var idx: Int
    
    init(id: UUID = UUID(), sender: Sender, text: String, chatDetailsID: UUID, idx: Int) {
        self.id = id
        self.sender = sender
        self.text = text
        self.chatDetailsID = chatDetailsID
        self.idx = idx
    }
    
    static func fromPersisted(_ from: MessagePersisted) -> Message {
        return Message(id: from.id! ,sender: Sender(rawValue: from.sender!.intValue)!, text: from.text!, chatDetailsID: from.chatDetailsID!, idx: from.idx!.intValue)
    }

    func toPersisted() -> MessagePersisted {
        let message = MessagePersisted(context: PersistenceController.shared.container.viewContext)
        message.id = self.id
        message.sender = NSDecimalNumber(value: self.sender.rawValue)
        message.text = self.text
        message.chatDetailsID = self.chatDetailsID
        message.idx = NSDecimalNumber(value: self.idx)
        return message
    }
}
