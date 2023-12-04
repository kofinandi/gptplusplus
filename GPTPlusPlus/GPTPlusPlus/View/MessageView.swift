//
//  MessageView.swift
//  GPTPlusPlus
//
//  Created by KiDani on 2023. 11. 30..
//

import SwiftUI

struct MessageView: View {
    @StateObject var viewModel: MessageViewModel
    @State private var isInsertPopoverVisible = false
    @State private var isEditPopoverVisible = false
    
    init(viewModel: MessageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            if viewModel.message.sender == .user {
                Spacer()
            } else {
                Image(systemName: viewModel.iconName)
                    .font(.system(size: 28))
                    .onTapGesture {
                        withAnimation {
                            viewModel.cycleMessageSender()
                        }
                    }
            }
            
            // Message Text
            VStack(alignment: viewModel.message.sender == .user ? .trailing : .leading, spacing: 4) {
                Text(viewModel.message.sender.name)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(viewModel.message.text)
                    .padding(8)
                    .background(viewModel.message.sender == .user ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .contextMenu {
                        Button("Delete Message") {
                            withAnimation {
                                viewModel.deleteMessage()
                            }
                        }
                        Button("Edit Message") {
                            isEditPopoverVisible = true
                        }
                        Button("Insert Message") {
                            isInsertPopoverVisible = true
                        }
                    }.sheet(isPresented: $isEditPopoverVisible) {
                        ModalView(isPresented: $isEditPopoverVisible, selectedOption: viewModel.message.sender, title: "Edit Message", messageContent: viewModel.message.text) { sender, text in
                            viewModel.updateMessage(sender: sender, text: text)
                        }
                    }.sheet(isPresented: $isInsertPopoverVisible) {
                        ModalView(isPresented: $isInsertPopoverVisible, selectedOption: viewModel.message.sender, title: "Insert Message", messageContent: "") { sender, text in
                            viewModel.insertMessage(sender: sender, text: text)
                        }
                    }
            }
            if viewModel.message.sender != .user {
                Spacer()
            } else {
                Image(systemName: viewModel.iconName)
                    .font(.system(size: 28))
                    .onTapGesture {
                        viewModel.cycleMessageSender()
                    }
            }
        }
    }
}
