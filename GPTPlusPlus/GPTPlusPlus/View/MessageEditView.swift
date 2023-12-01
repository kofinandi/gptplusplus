//
//  MessageEditView.swift
//  GPTPlusPlus
//
//  Created by KiDani on 2023. 12. 01..
//

import SwiftUI

struct ModalView: View {
    @Binding var isPresented: Bool
    @State var selectedOption: Int
    
    var title: String
    @State private var messageContent: String = ""
    @State private var error: String? = nil
    
    var saveCallback: (Message.Sender, String) -> Void
    
    init(isPresented: Binding<Bool>, selectedOption: Message.Sender, title: String, messageContent: String, saveCallback: @escaping (Message.Sender, String) -> Void) {
        self._isPresented = isPresented
        self._selectedOption = State(initialValue: selectedOption.rawValue)
        self.title = title
        self._messageContent = State(initialValue: messageContent)
        self.saveCallback = saveCallback
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Sender")) {
                    Picker("", selection: $selectedOption) {
                        ForEach(Message.Sender.allCases, id: \.self.rawValue) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Message Content")) {
                    TextEditor(text: $messageContent)
                        .frame(minHeight: 100)
                        .onChange(of: messageContent) { _ in
                            withAnimation {
                                error = nil
                            }
                        }
                    if let error = error {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button("Save") {
                        if messageContent.isEmpty {
                            withAnimation {
                                error = "Message content cannot be empty"
                            }
                        } else {
                            saveCallback(Message.Sender(rawValue: selectedOption)!, messageContent)
                            isPresented = false
                        }
                    }
                }
            }
            .navigationTitle(title)
        }
    }
}
