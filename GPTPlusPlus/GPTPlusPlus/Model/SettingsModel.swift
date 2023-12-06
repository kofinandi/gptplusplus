import Foundation

struct Prompt: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var text: String
    
    func hash(into hasher: inout Hasher) {
        // Combine the hash value of the UUID property
        hasher.combine(id)
    }
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
