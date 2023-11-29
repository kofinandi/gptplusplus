import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var apiKeys: [APIKey]
    @Published var selectedAPIKey: APIKey?
    @Published var apiKeyError: String? = nil
    @Published var selectedTheme: Theme
    @Published var prompts: [Prompt]
    
    init() {
        self.apiKeys = []
        self.selectedTheme = Theme(rawValue: UserDefaults.standard.string(forKey: "selectedTheme") ?? "") ?? .system
        self.prompts = []
    }

    func setActiveAPIKey(apiKey: APIKey) {
        selectedAPIKey = apiKey
    }

    // Add or remove API keys
    func addAPIKey(apiKey: APIKey) {
        if apiKey.title.isEmpty {
            apiKeyError = "Title cannot be empty"
            return
        }
        if apiKey.key.isEmpty {
            apiKeyError = "API key cannot be empty"
            return
        }
        if apiKeys.contains(where: { key in
            return key.title == apiKey.title
        }){
            apiKeyError = "API key with the same title already exists"
            return
        }
        apiKeyError = nil
        apiKeys.append(apiKey)
    }

    func removeAPIKey(at offsets: IndexSet) {
        let removed = apiKeys[offsets.first!]
        apiKeys.remove(atOffsets: offsets)
        if selectedAPIKey?.id == removed.id {
            selectedAPIKey = nil
        }
    }
    
    func dismissAPIError(){
        apiKeyError = nil
    }

    // Add or remove prompts
    func addPrompt(prompt: Prompt) {
        prompts.append(prompt)
    }

    func editPrompt(prompt: Prompt, id: UUID) {
        if let index = prompts.firstIndex(where: { $0.id == id }) {
            prompts[index] = prompt
        }
    }

    func removePrompt(at offsets: IndexSet) {
        prompts.remove(atOffsets: offsets)
    }
}
