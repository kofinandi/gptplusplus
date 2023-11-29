import SwiftUI

struct SettingsView: View {
    @StateObject var settings: SettingsViewModel = SettingsViewModel()
    @State private var newAPIKey = ""
    
    var body: some View {
        
        Form {
            Section(header: Text("Manage API keys")) {
                List {
                    ForEach(settings.apiKeys) { apiKey in
                        APIKeyRow(apiKey: apiKey.title, isActive: apiKey.id == settings.selectedAPIKey?.id)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                settings.setActiveAPIKey(apiKey: apiKey)
                            }
                    }
                    .onDelete { indexSet in
                        settings.removeAPIKey(at: indexSet)
                    }
                    NavigationLink(destination: AddApiKeyView(settings: settings)) {
                        Text("Add new API key")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Section(header: Text("Theme")) {
                Picker("Select Theme", selection: $settings.selectedTheme) {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        Text(theme.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: settings.selectedTheme) { value in
                    settings.saveTheme()
                }
            }
            
            Section(header: Text("Prompt Library")) {
                List {
                    ForEach(settings.prompts) { prompt in
                        NavigationLink(destination: EditPromptView(settings: settings, prompt: prompt)) {
                            Text(prompt.title)
                        }
                    }
                    .onDelete(perform: settings.removePrompt)
                }
                
                NavigationLink(destination: AddPromptView(settings: settings)) {
                    Text("Add new prompt")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct APIKeyRow: View {
    var apiKey: String
    var isActive: Bool
    
    var body: some View {
        HStack {
            Text(apiKey)
                .foregroundColor(isActive ? .accentColor : .primary)
            
            Spacer()
            
            if isActive {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.vertical, 4)
    }
}

// Add a temporary preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: SettingsViewModel())
    }
}
