//
//  ChatDetails.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation

class ChatDetails: Identifiable, ObservableObject, NSCopying, Hashable {
    private var viewContext = PersistenceController.shared.container.viewContext
    static func == (lhs: ChatDetails, rhs: ChatDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    @Published var id: UUID
    @Published var title: String
    @Published var api: APITypes
    @Published var autoGenerateTitle: Bool
    @Published var temperature: Double
    @Published var showMarkdown: Bool
    @Published var folderID: UUID
    @Published var titleGenPrompt: Prompt
    @Published var systemGreetingPrompt: Prompt?
    @Published var maxTokens: Double
    @Published var topP: Double

    private static let defaultTitleGenPrompt = Prompt(title: "Default", text: "Generate a short title (without quotation marks) for the following conversation: ")
    
    init(folderID: UUID) {
        self.id = UUID()
        self.title = ""
        self.api = .jo
        self.autoGenerateTitle = false
        self.showMarkdown = false
        self.temperature = 0.0
        self.folderID = folderID
        self.maxTokens = 1024.0
        self.topP = 1.0
        self.titleGenPrompt = ChatDetails.defaultTitleGenPrompt
    }
    
    init(id: UUID, title: String, api: APITypes, autoGenerateTitle: Bool, showMarkdown: Bool, folderID: UUID, temperature: Double = 0.0, maxTokens: Double = 1024.0, topP: Double = 1.0, titleGenPrompt: Prompt, systemGreetingPrompt: Prompt?) {
        self.id = id
        self.title = title
        self.api = api
        self.autoGenerateTitle = autoGenerateTitle
        self.showMarkdown = showMarkdown
        self.temperature = temperature
        self.folderID = folderID
        self.topP = topP
        self.maxTokens = maxTokens
        self.titleGenPrompt = titleGenPrompt
        self.systemGreetingPrompt = systemGreetingPrompt
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ChatDetails(id: self.id, title: self.title, api: self.api, autoGenerateTitle: self.autoGenerateTitle, showMarkdown: self.showMarkdown, folderID: self.folderID, temperature: self.temperature, maxTokens: self.maxTokens, topP: self.topP, titleGenPrompt: self.titleGenPrompt, systemGreetingPrompt: self.systemGreetingPrompt)
        return copy
    }
    
    func copy(from: ChatDetails) {
        self.id = from.id
        self.title = from.title
        self.api = from.api
        self.autoGenerateTitle = from.autoGenerateTitle
        self.showMarkdown = from.showMarkdown
        self.folderID = from.folderID
        self.topP = from.topP
        self.maxTokens = from.maxTokens
        self.titleGenPrompt = from.titleGenPrompt
        self.systemGreetingPrompt = from.systemGreetingPrompt
    }
    
    func resetValues() {
        self.id = UUID()
        self.title = ""
        self.api = .jo
        self.autoGenerateTitle = false
        self.showMarkdown = false
        self.maxTokens = 1024
        self.topP = 1.0
        self.titleGenPrompt = ChatDetails.defaultTitleGenPrompt
        self.systemGreetingPrompt = nil
    }
    
    func hash(into hasher: inout Hasher) {
        // Combine the hash value of the UUID property
        hasher.combine(id)
    }
    
    static func fromPersisted(_ from: ChatDetailsPersisted) -> ChatDetails {
        let titleGenPrompt = SettingsStorage.instance.prompts.first { $0.id == from.titleGenPromptId } ?? defaultTitleGenPrompt
        let systemGreetingPrompt = SettingsStorage.instance.prompts.first { $0.id == from.greetingPromptId }
        return ChatDetails(id: from.id!, title: from.title!, api: APITypes(rawValue: from.api!)!, autoGenerateTitle: from.autoGenerateTitle, showMarkdown: from.showMarkdown, folderID: from.folderID!, maxTokens: from.maxTokens, topP: from.topP, titleGenPrompt: titleGenPrompt, systemGreetingPrompt: systemGreetingPrompt)
    }

    func toPersisted() -> ChatDetailsPersisted {
        let chatDetails = ChatDetailsPersisted(context: viewContext)
        chatDetails.id = self.id
        chatDetails.title = self.title
        chatDetails.api = self.api.rawValue
        chatDetails.autoGenerateTitle = self.autoGenerateTitle
        chatDetails.showMarkdown = self.showMarkdown
        chatDetails.folderID = self.folderID
        chatDetails.topP = self.topP
        chatDetails.maxTokens = self.maxTokens
        chatDetails.titleGenPromptId = self.titleGenPrompt.id
        chatDetails.greetingPromptId = self.systemGreetingPrompt?.id
        
        return chatDetails
    }
}
