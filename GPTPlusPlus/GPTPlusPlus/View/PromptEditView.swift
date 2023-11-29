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
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
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
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
}


extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

