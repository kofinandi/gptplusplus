//
//  SettingsStorage.swift
//  GPTPlusPlus
//
//  Created by iOS Student on 2023. 11. 29..
//

import Foundation


class SettingsStorage {
    static let instance = SettingsStorage()

    private let apiKeysKey = "APIKeys"

    private var _apiKeys: [APIKey]
    
    var apiKeys: [APIKey] {
        set {
            _apiKeys = newValue
            save()
        }
        get {
            
        }
    }

    private init() {
        // Load API keys from UserDefaults
        if let savedAPIKeys = UserDefaults.standard.object(forKey: apiKeysKey) as? Data,
           let decodedAPIKeys = try? JSONDecoder().decode([APIKey].self, from: savedAPIKeys) {
            self.apiKeys = decodedAPIKeys
        } else {
            self.apiKeys = []
        }
    }

    func save() {
        if let encodedAPIKeys = try? JSONEncoder().encode(apiKeys) {
            UserDefaults.standard.set(encodedAPIKeys, forKey: apiKeysKey)
        }
    }

    // You can call this method to reset the API keys in UserDefaults
    func reset() {
        UserDefaults.standard.removeObject(forKey: apiKeysKey)
        self.apiKeys = []
    }
}
