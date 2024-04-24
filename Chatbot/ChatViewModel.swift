//
//  ChatViewModel.swift
//  Chatbot
//
//  Created by Kento Akazawa on 4/24/24.
//

import SwiftUI

// View model for ChatView
class ChatViewModel: ObservableObject {
  @Published var messages: [Message] = []
  @Published var currentInput: String = ""
  @Published var isLoading = false
  @Published private(set) var lastMessageId = UUID()
  
  private let openAIService = OpenAIService()
  
  func sendMessage() {
    isLoading = true
    let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
    lastMessageId = newMessage.id
    // add new message to @messages so that all messages can be displayed
    messages.append(newMessage)
    // reset the text field text to empty string
    currentInput = ""
    
    Task {
      let response = await openAIService.sendMessage(messages: messages)
      guard let receivedOpenAIMessage = response?.choices.first?.message else {
        print("Had no received message")
        isLoading = false
        return
      }
      await MainActor.run {
        let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
        lastMessageId = receivedMessage.id
        messages.append(receivedMessage)
        for m in receivedMessage.content.components(separatedBy: "\n") {
          print(m)
        }
        isLoading = false
      }
    }
  }
}

// Message structure for both user input and response
struct Message: Decodable {
  let id: UUID
  let role: SenderRole
  let content: String
  let createAt: Date
}
