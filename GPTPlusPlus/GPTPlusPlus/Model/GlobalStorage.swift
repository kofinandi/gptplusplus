//
//  GlobalStorage.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 29..
//

import Foundation

let globalStorage = GlobalStorage()

class GlobalStorage {
    var folders: [Folder]
    var chatDetails: [ChatDetails]
    
    init() {
        self.folders =
        [
            Folder(id: UUID(), name: "Folder 1"),
            Folder(id: UUID(), name: "Folder 2")
        ]
        
        self.chatDetails =
        [
            // sample data
            ChatDetails(id: UUID(), title: "Sample chat 1", api: .jo, autoGenerateTitle: false, showMarkdown: false, folderID: folders[0].id),
            ChatDetails(id: UUID(), title: "Sample chat 2", api: .jo, autoGenerateTitle: false, showMarkdown: false, folderID: folders[0].id),
            ChatDetails(id: UUID(), title: "Sample chat 3", api: .jobb, autoGenerateTitle: false, showMarkdown: false, folderID: folders[1].id),
        ]
    }
    
    func getAllFolders() -> [Folder] {
        return folders
    }
    
    func getChatDetails(byFolderID: UUID) -> [ChatDetails] {
        return chatDetails.filter { $0.folderID == byFolderID }
    }
    
    func getChat(byChatDetails: ChatDetails) -> Chat {
        return Chat(id: UUID(), title: "Test chat", text: "Hello")
    }
}

