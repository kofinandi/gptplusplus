//
//  Persistence.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        var folders: [FolderPersisted] = []
        for idx in 0..<5 {
            let newFolder = FolderPersisted(context: viewContext)
            newFolder.id = UUID()
            newFolder.name = "Sample folder \(idx)"
            folders.append(newFolder)
        }
        var chats: [ChatDetailsPersisted] = []
        for idx in 0..<20 {
            let newChat = ChatDetailsPersisted(context: viewContext)
            newChat.id = UUID()
            newChat.folderID = folders[idx % 5].id!
            newChat.title = "Sample chat \(idx)"
            newChat.api = "gpt-4"
            chats.append(newChat)
            
            for _ in 0..<20 {
                let newMessage = MessagePersisted(context: viewContext)
                newMessage.id = UUID()
                newMessage.text = "Sample message"
                newMessage.chatDetailsID = newChat.id!
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "GPTPlusPlus")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
