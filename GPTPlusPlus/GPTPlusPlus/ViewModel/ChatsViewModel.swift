//
//  ChatsViewModel.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation
import Combine

class ChatsViewModel: ObservableObject {
    @Published var chats: [ChatDetails]
    private var cancellables: [AnyCancellable] = []
    let folder: FolderPersisted
    
    init(folder: FolderPersisted) {
        self.folder = folder
        self.chats = globalStorage.getChatDetails(byFolderID: folder.id!)
        
        for chat in self.chats {
            chat.objectWillChange
                .sink { _ in
                    self.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    }
    
    func addNewChat(chatDetails: ChatDetails) {
        chatDetails.objectWillChange
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
        globalStorage.addNewChat(chatDetails: chatDetails)
        chats = globalStorage.getChatDetails(byFolderID: self.folder.id!)
    }
    
    func updateChatDetails(with: ChatDetails) {
        globalStorage.updateChatDetails(with: with)
        chats = globalStorage.getChatDetails(byFolderID: folder.id!)
    }
    
    func deleteChatDetails(withID: UUID) {
        globalStorage.deleteChatDetails(withID: withID)
        chats = globalStorage.getChatDetails(byFolderID: self.folder.id!)
    }
}
