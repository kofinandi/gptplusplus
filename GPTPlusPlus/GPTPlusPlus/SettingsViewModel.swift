import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var apiKeys: [String]
    @Published var selectedAPIKey: String?
    @Published var apiKeyError: String? = nil
    @Published var selectedTheme: Theme
    @Published var prompts: [Prompt]
    
    init() {
        // Initialize with some default values or load from UserDefaults
        self.apiKeys = UserDefaults.standard.stringArray(forKey: "apiKeys") ?? []
        self.selectedTheme = Theme(rawValue: UserDefaults.standard.string(forKey: "selectedTheme") ?? "") ?? .system
        self.prompts = []
    }

    func setActiveAPIKey(apiKey: String) {
        selectedAPIKey = apiKey
    }

    // Add or remove API keys
    func addAPIKey(apiKey: String) {
        if apiKey.isEmpty {
            apiKeyError = "API key cannot be empty"
            return
        }
        if apiKeys.contains(apiKey) {
            apiKeyError = "API key already exists"
            return
        }
        apiKeyError = nil
        apiKeys.append(apiKey)
    }

    func removeAPIKey(at offsets: IndexSet) {
        let removed = apiKeys[offsets.first!]
        apiKeys.remove(atOffsets: offsets)
        if selectedAPIKey == removed {
            selectedAPIKey = nil
        }
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
