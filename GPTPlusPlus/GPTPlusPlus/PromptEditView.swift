import SwiftUI

struct AddPromptView: View {
    @ObservedObject var settings: SettingsViewModel
    @State private var title = ""
    @State private var text = ""

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Form {
            Section(header: Text("Prompt Details")) {
                TextField("Title", text: $title)
                TextEditor(text: $text)
            }

            Section {
                Button("Save"){
                    let prompt = Prompt(title: title, text: text)
                    settings.addPrompt(prompt: prompt)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Add Prompt")
    }
}

struct EditPromptView: View {
    @ObservedObject var settings: SettingsViewModel
    var prompt: Prompt
    @State private var title = ""
    @State private var text = ""

    init(settings: SettingsViewModel, prompt: Prompt) {
        self.settings = settings
        self.prompt = prompt
        self._title = State(initialValue: prompt.title)
        self._text = State(initialValue: prompt.text)
    }

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Form{
            Section(header: Text("Prompt Details")) {
                TextField("Title", text: $title)
                TextEditor(text: $text)
            }

            Section {
                Button("Save"){
                    settings.editPrompt(prompt: Prompt(title: title, text: text), id: prompt.id)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Edit Prompt")
    }
}
