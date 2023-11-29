import Foundation

struct SettingsModel {
    var apiKeys: [String]
    var selectedAPIKey: String?
    var selectedTheme: Theme
    var prompts: [Prompt]
}

struct Prompt: Identifiable {
    var id = UUID()
    var title: String
    var text: String
}

struct APIKey: Identifiable {
    var id = UUID()
    var title: String
    var key: String
}

enum Theme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}
