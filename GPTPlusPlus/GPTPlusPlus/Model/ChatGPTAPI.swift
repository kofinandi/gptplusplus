//
//  ChatGPTAPI.swift
//  GPTPlusPlus
//
//  Created by KiDani on 2023. 12. 01..
//

import Foundation

class ChatGPTAPI {
    private var currentTask: URLSessionTask?
    private let chatDetails: ChatDetails

    init(chatDetails: ChatDetails) {
        self.chatDetails = chatDetails
    }

    func cancelCurrentTask() {
        currentTask?.cancel()
    }

    deinit {
        cancelCurrentTask()
    }

    func generateChatResponse(completion: @escaping (Result<String, Error>) -> Void) throws {
        let messages = globalStorage.getChatMessages(byChatDetails: chatDetails)
        try generateResponse(messages: messages, completion: completion)
    }

    func generateChatTitle(completion: @escaping (Result<String, Error>) -> Void) throws {
        var messages = globalStorage.getChatMessages(byChatDetails: chatDetails)
        messages.insert(Message(sender: .system, text: chatDetails.titleGenPrompt?.text ?? ChatDetails.defaultTitleGenPrompt), at: 0)
        try generateResponse(messages: messages, completion: completion)
    }

    private func generateResponse(messages: [Message], completion: @escaping (Result<String, Error>) -> Void) throws {
        guard let apiKey = SettingsStorage.instance.activeKey?.key else {
            throw NSError(domain: "ChatGPTAPI", code: 1, userInfo: [NSLocalizedDescriptionKey: "No API key was selected as active"])
        }

        let apiUrl = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        //the role is the following mapping: user -> user, gpt -> assistant, system -> system
        let roleMapping: [Message.Sender: String] = [
            .user: "user",
            .gpt: "assistant",
            .system: "system"
        ]

        let senderMessagePairs = messages.map { message in
            return [
                "role": roleMapping[message.sender] ?? "user",
                "content": message.text
            ]
        }

        print(senderMessagePairs)

        let requestBody: [String: Any] = [
            "model": chatDetails.api.rawValue,
            "messages": senderMessagePairs,
            "temperature": chatDetails.temperature,
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        currentTask = URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "ChatGPTAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to get a valid response from the API"])))
                return
            }

            do {
                print(String(data: data, encoding: .utf8)!)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let choices = json?["choices"] as? [[String: Any]],
                   let assistantMessage = choices.first?["message"] as? [String: Any],
                   let content = assistantMessage["content"] as? String {
                    completion(.success(content))
                } else {
                    completion(.failure(NSError(domain: "ChatGPTAPI", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        currentTask?.resume()
    }
}


