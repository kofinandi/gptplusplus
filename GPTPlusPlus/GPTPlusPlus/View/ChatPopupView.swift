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
    
    init(title: String, chatDetails: ChatDetails, showExport: Bool = false) {
        self.title = title
        self._chatPopupViewModel = StateObject(wrappedValue: ChatPopupViewModel(chatDetails: chatDetails))
        self.showExport = showExport
    }
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text(title)
                        .font(.title)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    Spacer()
                }
                HStack {
                    Text("Chat title").font(.title3)
                    Spacer()
                }
                HStack {
                    TextField("Chat title", text: $chatPopupViewModel.chatDetails.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                    Spacer()
                }
                Divider()
            }
            Group {
                HStack {
                    Text("Chat API").font(.title3)
                    Spacer()
                }
                HStack {
                    Picker("Chat API", selection: $chatPopupViewModel.chatDetails.api) {
                        ForEach(APITypes.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    Spacer()
                }
                Divider()
                Toggle("Auto generate title", isOn: $chatPopupViewModel.chatDetails.autoGenerateTitle)
                Toggle("Show markdown", isOn: $chatPopupViewModel.chatDetails.showMarkdown)
            }
            Spacer()
            if (showExport) {
                Button("Export") {
                    chatPopupViewModel.exportChat()
                }
            }
        }
    }
}

struct ChatPopupView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPopupView(title: "Configure chat", chatDetails: globalStorage.getChatDetails(byFolderID: globalStorage.getAllFolders()[0].id!)[0], showExport: true)
    }
}
