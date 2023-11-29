//
//  ChatsViewModel.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation

class ChatsViewModel: ObservableObject {
    @Published var chats: [ChatDetails]
    
    init(folder: Folder) {
        chats = globalStorage.getChatDetails(byFolderID: folder.id)
    }
    
    func getChatDetailsById(id: UUID) -> ChatDetails {
        return chats[0]
    }
}
