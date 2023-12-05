//
//  GlobalStorage.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 29..
//

import Foundation
import CoreData

let globalStorage = GlobalStorage()

class GlobalStorage {
    private var viewContext = PersistenceController.shared.container.viewContext
    var foldersList: [FolderPersisted]
    var chatDetailsList: [ChatDetailsPersisted]
    var messages: [MessagePersisted]
    
    init() {
        let fetchRequestFolders: NSFetchRequest<FolderPersisted> = FolderPersisted.fetchRequest()
        
        do {
            self.foldersList = try viewContext.fetch(fetchRequestFolders)
        } catch {
            self.foldersList = []
            print("Error fetching objects: \(error)")
        }
        
        let fetchRequestChatDetails: NSFetchRequest<ChatDetailsPersisted> = ChatDetailsPersisted.fetchRequest()
        
        do {
            self.chatDetailsList = try viewContext.fetch(fetchRequestChatDetails)
        } catch {
            self.chatDetailsList = []
            print("Error fetching objects: \(error)")
        }
        
        let fetchRequestMessages: NSFetchRequest<MessagePersisted> = MessagePersisted.fetchRequest()
        
        do {
            self.messages = try viewContext.fetch(fetchRequestMessages)
        } catch {
            self.messages = []
            print("Error fetching objects: \(error)")
        }
    }
    
    func getAllFolders() -> [FolderPersisted] {
        return foldersList
    }
    
    func addNewFolder(folder: FolderPersisted) {
        foldersList.append(folder)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func renameFolder(withID: UUID, to: String) {
        let folder = foldersList.first { $0.id == withID }
        folder?.name = to
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteFolder(withID: UUID) {
        let toDelete = foldersList.first { $0.id == withID }
        foldersList.removeAll { $0.id == withID }
        
        viewContext.delete(toDelete!)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getChatDetails(byFolderID: UUID) -> [ChatDetails] {
        return chatDetailsList.filter { $0.folderID == byFolderID }.map { ChatDetails.fromPersisted($0) }
    }
    
    func getChatDetails(byID: UUID) -> ChatDetails? {
        return ChatDetails.fromPersisted(chatDetailsList.first { $0.id == byID }!)
    }
    
    func addNewChat(chatDetails: ChatDetails) {
        chatDetailsList.append(chatDetails.toPersisted())
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateChatDetails(with: ChatDetails) {
        let persisted = chatDetailsList.first { $0.id! == with.id }!
        persisted.title = with.title
        persisted.api = with.api.rawValue
        persisted.autoGenerateTitle = with.autoGenerateTitle
        persisted.showMarkdown = with.showMarkdown
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteChatDetails(withID: UUID) {
        let toDelete = chatDetailsList.first { $0.id == withID }
        chatDetailsList.removeAll { $0.id == withID}
        
        viewContext.delete(toDelete!)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getChatMessages(byChatDetails: ChatDetails) -> [Message] {
        return messages
            .filter { $0.chatDetailsID == byChatDetails.id }
            .map { Message.fromPersisted($0) }
            .sorted { $0.idx < $1.idx }
    }
    
    func updateChatMessage(byChatDetails: ChatDetails, message: Message) {
        let persisted = messages.first { $0.id! == message.id }!
        persisted.sender = NSDecimalNumber(value: message.sender.rawValue)
        persisted.text = message.text
        persisted.chatDetailsID = byChatDetails.id
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addChatMessage(byChatDetails: ChatDetails, message: Message) {
        messages.append(message.toPersisted())
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteChatMessage(byChatDetails: ChatDetails, message: Message) {
        let toDelete = messages.first { $0.id! == message.id }
        messages.removeAll { $0.id! == message.id }
        
        viewContext.delete(toDelete!)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func insertChatMessage(byChatDetails: ChatDetails, message: Message, bellow: Message) {
        let index = messages.firstIndex { $0.id! == bellow.id }
        messages.insert(message.toPersisted(), at: index! + 1)

        var messagesForChatDetails = messages.filter { $0.chatDetailsID == byChatDetails.id }
        messagesForChatDetails.sort { $0.idx!.intValue < $1.idx!.intValue }
        for i in 0 ..< messagesForChatDetails.count {
            messagesForChatDetails[i].idx = NSDecimalNumber(value: i)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

