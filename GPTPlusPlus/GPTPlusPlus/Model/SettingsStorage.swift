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
    private let activeApiKeyKey = "ActiveAPIKey"
    private let promptsKey = "Prompts"
    private let selectedThemeKey = "SelectedTheme"
    
    var apiKeys: [APIKey] {
        didSet {
            if let encodedAPIKeys = try? JSONEncoder().encode(apiKeys) {
                UserDefaults.standard.set(encodedAPIKeys, forKey: apiKeysKey)
            }
        }
    }
    
    var activeKey: APIKey? {
        didSet {
            if let tmp = activeKey {
                if let encodedAPIKeys = try? JSONEncoder().encode(tmp) {
                    UserDefaults.standard.set(encodedAPIKeys, forKey: activeApiKeyKey)
                }
            }else{
                UserDefaults.standard.removeObject(forKey: activeApiKeyKey)
            }
        }
    }

    var selectedTheme: Theme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: selectedThemeKey)
        }
    }
    
    var prompts: [Prompt] {
        didSet {
            if let encodedPrompts = try? JSONEncoder().encode(prompts) {
                UserDefaults.standard.set(encodedPrompts, forKey: promptsKey)
            }
        }
    }
    
    private init() {
        if let savedAPIKeys = UserDefaults.standard.object(forKey: apiKeysKey) as? Data,
           let decodedAPIKeys = try? JSONDecoder().decode([APIKey].self, from: savedAPIKeys) {
            self.apiKeys = decodedAPIKeys
        } else {
            self.apiKeys = []
        }
        if let savedActiveKey = UserDefaults.standard.object(forKey: activeApiKeyKey) as? Data,
           let decodedActiveKey = try? JSONDecoder().decode(APIKey.self, from: savedActiveKey) {
            self.activeKey = decodedActiveKey
        }
        if let savedPrompts = UserDefaults.standard.object(forKey: promptsKey) as? Data,
           let decodedPrompts = try? JSONDecoder().decode([Prompt].self, from: savedPrompts) {
            self.prompts = decodedPrompts
        } else {
            self.prompts = []
        }
        if let savedTheme = UserDefaults.standard.object(forKey: selectedThemeKey) as? String,
           let decodedTheme = Theme(rawValue: savedTheme) {
            self.selectedTheme = decodedTheme
        } else {
            self.selectedTheme = .system
        }
    }
    
    func reset() {
        UserDefaults.standard.removeObject(forKey: apiKeysKey)
        self.apiKeys = []
        UserDefaults.standard.removeObject(forKey: activeApiKeyKey)
        self.activeKey = nil
        UserDefaults.standard.removeObject(forKey: promptsKey)
        self.prompts = []
        UserDefaults.standard.removeObject(forKey: selectedThemeKey)
        self.selectedTheme = .system
    }
}
