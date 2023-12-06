//
//  ChatPopupView.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import SwiftUI

struct ChatPopupView: View {
    let title: String
    let showExport: Bool
    @StateObject var chatPopupViewModel: ChatPopupViewModel
    @State private var showShareSheet = false
    @State private var selectedSystemPromptTitle: String?
    @State private var selectedTitlePromptTitle: String
    
    init(title: String, chatDetails: ChatDetails, showExport: Bool = false) {
        self.title = title
        self._chatPopupViewModel = StateObject(wrappedValue: ChatPopupViewModel(chatDetails: chatDetails))
        self.showExport = showExport
        selectedSystemPromptTitle = chatDetails.systemGreetingPrompt?.title
        selectedTitlePromptTitle = chatDetails.titleGenPrompt.title
    }
    
    var body: some View {
        Form {
            Section(header: Text("Chat title")) {
                TextField("Chat title", text: $chatPopupViewModel.chatDetails.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Section(header: Text("Chat settings")) {
                Picker("Chat API", selection: $chatPopupViewModel.chatDetails.api) {
                    ForEach(APITypes.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                Toggle("Auto generate title", isOn: $chatPopupViewModel.chatDetails.autoGenerateTitle)
                Toggle("Show markdown", isOn: $chatPopupViewModel.chatDetails.showMarkdown)
            }
            Section(header: Text("Temperature")){
                Slider(value: $chatPopupViewModel.chatDetails.temperature, in: 0.0...1.0, minimumValueLabel: Image(systemName: "thermometer.low"), maximumValueLabel: Image(systemName: "thermometer.high")) {
                    Text("Temperature")
                }
            }
            Section(header: Text("Max token number")) {
                HStack {
                    Slider(value: $chatPopupViewModel.chatDetails.maxTokens, in: 10...20000, step: 1.0)
                    Text(String(Int(chatPopupViewModel.chatDetails.maxTokens)))
                }
            }
            Section(header: Text("TopP")){
                HStack{
                    Slider(value: $chatPopupViewModel.chatDetails.topP, in: 0.0...1.0, step: 0.01){
                        Text("TopP")
                    }
                    Text(String(format: "%.2f", chatPopupViewModel.chatDetails.topP))
                }
            }
            Section(header: Text("Prompts")){
                HStack {
                    Text("Title prompt:")
                    Spacer()
                    Menu(selectedTitlePromptTitle){
                        ForEach(chatPopupViewModel.prompts, id: \.self) { element in
                            Button(action: {
                                chatPopupViewModel.chatDetails.titleGenPrompt = element
                                selectedTitlePromptTitle = element.title
                            }) {
                                HStack {
                                    Text(element.title)
                                    if selectedTitlePromptTitle == element.title {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
                HStack {
                    Text("Greeting prompt:")
                    Spacer()
                    Menu(selectedSystemPromptTitle ?? "Select"){
                        ForEach(chatPopupViewModel.prompts, id: \.self) { element in
                            Button(action: {
                                chatPopupViewModel.chatDetails.systemGreetingPrompt = element
                                selectedSystemPromptTitle = element.title
                            }) {
                                HStack {
                                    Text(element.title)
                                    if selectedSystemPromptTitle == element.title {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (showExport) {
                Section {
                    Button("Export") {
                        chatPopupViewModel.exportChat()
                        self.showShareSheet = true
                    }
                }
            }
        }
        .navigationTitle(title)
        .onAppear {
            chatPopupViewModel.updatePrompts()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(fileURL: getFileURL(filename: chatPopupViewModel.filename))
        }
    }
}

struct ChatPopupView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPopupView(title: "Configure chat", chatDetails: globalStorage.getChatDetails(byFolderID: globalStorage.getAllFolders()[0].id!)[0], showExport: true)
    }
}
