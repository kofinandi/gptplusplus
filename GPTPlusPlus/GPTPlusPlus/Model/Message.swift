//
//  Message.swift
//  GPTPlusPlus
//
//  Created by KiDani on 2023. 12. 01..
//

import Foundation

struct Message: Identifiable {
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
    var id = UUID()
    var sender: Sender
    var text: String
}
