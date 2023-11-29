//
//  GlobalStorage.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 29..
//

import Foundation

let globalStorage = GlobalStorage()

class GlobalStorage {
    var foldersList: [Folder]
    var chatDetailsList: [ChatDetails]
    
    init() {
        self.foldersList =
        [
            Folder(name: "Folder 1"),
            Folder(name: "Folder 2")
        ]
        
        self.chatDetailsList =
        [
            // sample data
            ChatDetails(id: UUID(), title: "Sample chat 1", api: .jo, autoGenerateTitle: false, showMarkdown: false, folderID: foldersList[0].id),
            ChatDetails(id: UUID(), title: "Sample chat 2", api: .jo, autoGenerateTitle: false, showMarkdown: false, folderID: foldersList[0].id),
            ChatDetails(id: UUID(), title: "Sample chat 3", api: .jobb, autoGenerateTitle: false, showMarkdown: false, folderID: foldersList[1].id),
        ]
    }
    
    func getAllFolders() -> [Folder] {
        return foldersList
    }
    
    func addNewFolder(folder: Folder) {
        foldersList.append(folder)
    }

    func renameFolder(withID: UUID, to: String) {
        let folder = foldersList.first { $0.id == withID }
        folder?.name = to
    }
    
    func deleteFolder(withID: UUID) {
        foldersList.removeAll { $0.id == withID }
    }
    
    func getChatDetails(byFolderID: UUID) -> [ChatDetails] {
        return chatDetailsList.filter { $0.folderID == byFolderID }
    }
    
    func getChatDetails(byID: UUID) -> ChatDetails? {
        return chatDetailsList.first { $0.id == byID }
    }
    
    func getChat(byChatDetails: ChatDetails) -> Chat {
        return Chat(id: UUID(), title: "Test chat", text: "Hello")
    }
    
    func addNewChat(chatDetails: ChatDetails) {
        chatDetailsList.append(chatDetails)
    }
    
    func updateChatDetails(with: ChatDetails) {
        
    }
    
    func deleteChatDetails(withID: UUID) {
        chatDetailsList.removeAll { $0.id == withID }
    }
}

