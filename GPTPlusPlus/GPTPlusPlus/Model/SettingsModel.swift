import Foundation

struct Prompt: Identifiable, Codable {
    var id = UUID()
    var title: String
    var text: String
}

struct APIKey: Identifiable, Codable {
    var id = UUID()
    var title: String
    var key: String
}

enum Theme: String, CaseIterable, Codable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}
