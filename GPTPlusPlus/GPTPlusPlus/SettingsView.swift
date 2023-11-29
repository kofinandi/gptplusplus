import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: SettingsViewModel
    @State private var newAPIKey = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API Keys")) {
                    VStack {
                        HStack {
                            TextField("Enter a new API key", text: $newAPIKey)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button(action: {
                                settings.addAPIKey(apiKey: newAPIKey)
                                if settings.apiKeyError == nil {
                                    newAPIKey = ""
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }) {
                                Text("Add")
                            }.padding(.horizontal)		
                        }

                        if let apiKeyError = settings.apiKeyError {
                            Text(apiKeyError)
                                .foregroundColor(.red)
                        }

                        List {
                            ForEach(settings.apiKeys, id: \.self) { apiKey in
                                APIKeyRow(apiKey: apiKey, isActive: apiKey == settings.selectedAPIKey)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        settings.setActiveAPIKey(apiKey: apiKey)
                                    }
                            }
                            .onDelete { indexSet in
                                settings.removeAPIKey(at: indexSet)
                            }
                        }
                    }
                    // Center the text if there are no API keys
                    if settings.apiKeys.isEmpty {
                        Text("No API keys added")
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("Theme")) {
                    Picker("Select Theme", selection: $settings.selectedTheme) {
                        ForEach(Theme.allCases, id: \.self) { theme in
                            Text(theme.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
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
                        Text("Add New Prompt")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct APIKeyRow: View {
    var apiKey: String
    var isActive: Bool

    var body: some View {
        HStack {
            Text(apiKey)
                .foregroundColor(isActive ? .blue : .black)

            Spacer()

            if isActive {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
}

// Add a temporary preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: SettingsViewModel())
    }
}
