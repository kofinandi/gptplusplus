//
//  SwiftUIView.swift
//  GPTPlusPlus
//
//  Created by iOS Student on 2023. 11. 29..
//

import SwiftUI

struct AddApiKeyView: View {
    @ObservedObject var settings: SettingsViewModel
    @State private var title = ""
    @State private var key = ""
    
    init(settings: SettingsViewModel, title: String = "", key: String = "") {
        self.settings = settings
        self.title = title
        self.key = key
    }

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Form {
            Section(header: Text("Add a new API key")) {
                TextField("Title", text: $title)
                TextEditor(text: $key)
                .placeholder(when: key.isEmpty) {
                    Text("Key")
                        .foregroundColor(Color(UIColor.placeholderText))
                }
                if let apiKeyError = settings.apiKeyError {
                    Text(apiKeyError)
                        .foregroundColor(.red)
                }
            }

            Section {
                Button("Save"){
                    let key = APIKey(title: title, key: key)
                    settings.addAPIKey(apiKey: key)
                    if settings.apiKeyError == nil{
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationTitle("Add Prompt")
        .onAppear{
            settings.dismissAPIError()
        }
    }
}

extension View {
    @ViewBuilder
    func placeholder<Content: View>(when shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder content: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            content().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
