//
//  ChatDetails.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation

class ChatDetails: Identifiable, ObservableObject, NSCopying {
    @Published var id: UUID
    @Published var title: String
    @Published var api: APITypes
    @Published var autoGenerateTitle: Bool
    @Published var showMarkdown: Bool
    @Published var folderID: UUID
    
    init(folderID: UUID) {
        self.id = UUID()
        self.title = ""
        self.api = .jo
        self.autoGenerateTitle = false
        self.showMarkdown = false
        self.folderID = folderID
    }
    
    init(id: UUID, title: String, api: APITypes, autoGenerateTitle: Bool, showMarkdown: Bool, folderID: UUID) {
        self.id = id
        self.title = title
        self.api = api
        self.autoGenerateTitle = autoGenerateTitle
        self.showMarkdown = showMarkdown
        self.folderID = folderID
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ChatDetails(id: self.id, title: self.title, api: self.api, autoGenerateTitle: self.autoGenerateTitle, showMarkdown: self.showMarkdown, folderID: self.folderID)
        return copy
    }
    
    func copy(from: ChatDetails) {
        self.id = from.id
        self.title = from.title
        self.api = from.api
        self.autoGenerateTitle = from.autoGenerateTitle
        self.showMarkdown = from.showMarkdown
        self.folderID = folderID
    }
    
    func resetValues() {
        self.id = UUID()
        self.title = ""
        self.api = .jo
        self.autoGenerateTitle = false
        self.showMarkdown = false
    }
}
