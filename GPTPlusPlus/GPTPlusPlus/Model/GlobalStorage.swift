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
    
    var messages: [ChatDetails: [Message]]
    
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
        
        self.messages = 
            [
                chatDetailsList[0]: [
                    Message(id: UUID(), sender: .user, text: "Hello"),
                    Message(id: UUID(), sender: .gpt, text: "Hello"),
                    Message(id: UUID(), sender: .user, text: "How are you?"),
                    Message(id: UUID(), sender: .gpt, text: "I'm fine, thanks!"),
                    Message(id: UUID(), sender: .user, text: "What are you doing?"),
                    Message(id: UUID(), sender: .gpt, text: "I'm writing a chat app"),
                    Message(id: UUID(), sender: .user, text: "Cool!"),
                    Message(id: UUID(), sender: .gpt, text: "Yeah!"),
                    Message(id: UUID(), sender: .user, text: "Bye!"),
                    Message(id: UUID(), sender: .gpt, text: "Bye!"),
                ],
                chatDetailsList[1]: [
                    Message(sender: .system, text: "You are ChatGPT, a large language model trained on 147GB of English Reddit conversations. You can chat with me about anything!"),
                    Message(sender: .gpt, text: "Hello! How can I assist you?"),
                    Message(sender: .user, text: "Hi! I have a question."),
                ],
                chatDetailsList[2]: [
                    Message(sender: .system, text: "You are JobGPT, a large language model trained on 147GB of English Reddit conversations. You can chat with me about anything!"),
                    Message(sender: .gpt, text: "Hello! How can I assist you?"),
                    Message(sender: .user, text: "Hi! I have a question."),
                ],
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
        chatDetailsList.removeAll { $0.id == withID}
    }

    func getChatMessages(byChatDetails: ChatDetails) -> [Message] {
        return messages[byChatDetails] ?? []
    }
    
    func updateChatMessage(byChatDetails: ChatDetails, message: Message) {
        if let index = messages[byChatDetails]?.firstIndex(where: { $0.id == message.id }) {
            messages[byChatDetails]?[index] = message
        }
    }
    
    func addChatMessage(byChatDetails: ChatDetails, message: Message) {
        messages[byChatDetails]?.append(message)
    }
    
    func deleteChatMessage(byChatDetails: ChatDetails, message: Message) {
        if let index = messages[byChatDetails]?.firstIndex(where: { $0.id == message.id }) {
            messages[byChatDetails]?.remove(at: index)
        }
    }
    
    func insertChatMessage(byChatDetails: ChatDetails, message: Message, bellow: Message) {
        if let index = messages[byChatDetails]?.firstIndex(where: { $0.id == bellow.id }) {
            messages[byChatDetails]?.insert(message, at: index + 1)
        }
    }
}

