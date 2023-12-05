//
//  FoldersViewModel.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation

class FoldersViewModel: ObservableObject {
    private var viewContext = PersistenceController.shared.container.viewContext
    @Published var folders: [FolderPersisted]
    @Published var incorrectName = false
    @Published var folderNotEmptyWarning = false
    
    init() {
        folders = globalStorage.getAllFolders()
    }
    
    func addNewFolder() {
        let newFolder = FolderPersisted(context: viewContext)
        newFolder.id = UUID()
        newFolder.name = "New folder"
        globalStorage.addNewFolder(folder: newFolder)
        folders = globalStorage.getAllFolders()
    }
    
    func renameFolder(withID: UUID, to: String) {
        if to.isEmpty {
            incorrectName = true
            return
        }
        let folder = folders.first { $0.id == withID }
        folder?.name = to
        globalStorage.renameFolder(withID: withID, to: to)
        folders = globalStorage.getAllFolders()
    }
    
    func deleteFolder(withID: UUID) {
        let containedChats = globalStorage.getChatDetails(byFolderID: withID)
        if !containedChats.isEmpty {
            folderNotEmptyWarning = true
            return
        }
        deleteFolderAnyway(withID: withID)
    }
    
    func deleteFolderAnyway(withID: UUID) {
        globalStorage.deleteFolder(withID: withID)
        folders = globalStorage.getAllFolders()
    }
}
