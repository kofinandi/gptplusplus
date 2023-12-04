//
//  ChatViewModelTest.swift
//  GPTPlusPlus
//
//  Created by KiDani on 2023. 11. 30..
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var chatDetails: ChatDetails
    @Published var messageViewModels: [MessageViewModel] = []
    @Published var apiError: String? = nil
    @Published var showApiError: Bool = false
    @Published var requestInProgress: Bool = false
    @Published var scrollToBottomAnimated = false
    @Published var prompts: [Prompt] = []

    private let chatGPTAPI: ChatGPTAPI
    
    init(chatDetails: ChatDetails) {
        self.chatDetails = chatDetails
        self.chatGPTAPI = ChatGPTAPI(chatDetails: chatDetails)
        messageViewModels = globalStorage.getChatMessages(byChatDetails: chatDetails).map { MessageViewModel(message: $0, chatViewModel: self) }
        if messageViewModels.isEmpty, let systemGreetingPrompt: Prompt = chatDetails.systemGreetingPrompt {
            let message = Message(sender: .system, text: systemGreetingPrompt.text)
            messageViewModels.append(MessageViewModel(message: message, chatViewModel: self))
            globalStorage.addChatMessage(byChatDetails: chatDetails, message: message)
        }
        prompts = SettingsStorage.instance.prompts
    }

    func reloadData() {
        let messages = globalStorage.getChatMessages(byChatDetails: chatDetails)
        // Delete the messageViewModels that are not in the messages array
        messageViewModels.removeAll { messageViewModel in
            !messages.contains { message in
                message.id == messageViewModel.message.id
            }
        }
        // Add the messages that are not in the messageViewModels array
        messages.forEach { message in
            if !messageViewModels.contains(where: { messageViewModel in
                messageViewModel.message.id == message.id
            }) {
                messageViewModels.append(MessageViewModel(message: message, chatViewModel: self))
            }
        }
        prompts = SettingsStorage.instance.prompts
    }
    
    func sendMessage(text: String, sender: Message.Sender = .user) {
        let message = Message(sender: sender, text: text, chatDetailsID: chatDetails.id, idx: messageViewModels.count)
        messageViewModels.append(MessageViewModel(message: message, chatViewModel: self))
        globalStorage.addChatMessage(byChatDetails: chatDetails, message: message)
        scrollToBottomAnimated.toggle()

        generateChatResponse()
    }

    private func generateChatResponse() {
        do {
            requestInProgress = true
            apiError = nil
            if chatDetails.autoGenerateTitle && chatDetails.title.isEmpty {
                try chatGPTAPI.generateChatTitle { [unowned self] response in
                    handleTitleResponse(response: response)
                }
            } else {
                try chatGPTAPI.generateChatResponse { [unowned self] response in
                    handleResponse(response: response)
                }
            }
        } catch {
            handleResponse(response: .failure(error))
        }
    }

    private func handleTitleResponse(response: Result<String, Error>) {
        DispatchQueue.main.async {
            guard self.requestInProgress else { return }
            switch response {
            case .success(let response):
                self.chatDetails.title = response
                globalStorage.updateChatDetails(with: self.chatDetails)
                self.generateChatResponse()
            case .failure(let error):
                self.apiError = error.localizedDescription
                self.showApiError = true
                self.requestInProgress = false
            }
        }
    }

    private func handleResponse(response: Result<String, Error>) {
        DispatchQueue.main.async {
            guard self.requestInProgress else { return }
            self.requestInProgress = false
            switch response {
            case .success(let response):
                let message = Message(sender: .gpt, text: response)
                self.messageViewModels.append(MessageViewModel(message: message, chatViewModel: self))
                globalStorage.addChatMessage(byChatDetails: self.chatDetails, message: message)
                self.scrollToBottomAnimated.toggle()
            case .failure(let error):
                self.apiError = error.localizedDescription
                self.showApiError = true
            }
        }
    }

    func regenerateLastResponse() {
        guard let lastMessage = messageViewModels.last?.message else { return }
        if lastMessage.sender == .gpt {
            deleteMessage(message: lastMessage)
        }
        generateChatResponse()
    }

    func stopCurrentRequest() {
        chatGPTAPI.cancelCurrentTask()
        requestInProgress = false
    }
    
    func deleteMessage(message: Message) {
        messageViewModels.removeAll { $0.message.id == message.id }
        globalStorage.deleteChatMessage(byChatDetails: chatDetails, message: message)
    }
    
    func insertMessage(message: Message, bellow: Message) {
        guard let index = messageViewModels.firstIndex(where: { $0.message.id == bellow.id }) else { return }
        messageViewModels.insert(MessageViewModel(message: message, chatViewModel: self), at: index + 1)
        globalStorage.insertChatMessage(byChatDetails: chatDetails, message: message, bellow: bellow)
    }
    
    func updateChatDetails(with: ChatDetails) {
        globalStorage.updateChatDetails(with: with)
        self.chatDetails = with
    }
}
