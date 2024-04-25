//
//  ChatViewModel.swift
//  Chatbot
//
//  Created by Kento Akazawa on 4/24/24.
//

import SwiftUI
import CoreData

// View model for ChatView
class ChatViewModel: ObservableObject {
  @Published var messages: [Message] = []
  @Published var currentInput: String = ""
  @Published var isLoading = false
  @Published private(set) var lastMessageId = UUID()
  private var chatID = UUID()
  private var isFirstChat = true
  
  private let openAIService = OpenAIService()
  private let chatHistoryLen = 30
  
  // MARK: - Public Functions
  
  func sendMessage(context: NSManagedObjectContext) {
    if isFirstChat {
      let title = currentInput.count < chatHistoryLen ? currentInput : "\(currentInput.prefix(chatHistoryLen))..."
      DataController().addChatID(ChatHistory(id: chatID, title: title, createAt: Date()), context: context)
      isFirstChat = false
    }
    isLoading = true
    let newMessage = Message(id: UUID(), chatID: chatID, role: .user, content: currentInput, createAt: Date())
    lastMessageId = newMessage.id
    // add new message to @messages so that all messages can be displayed
    messages.append(newMessage)
    DataController().addMessage(newMessage, context: context)
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
        let receivedMessage = Message(id: UUID(), chatID: chatID, role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
        lastMessageId = receivedMessage.id
        messages.append(receivedMessage)
        DataController().addMessage(receivedMessage, context: context)
        isLoading = false
      }
    }
  }
  
  func newChat(context: NSManagedObjectContext) {
    isFirstChat = true
    chatID = UUID()
    messages = []
  }
  
  func getChatID(context: NSManagedObjectContext) -> [ChatHistory] {
    return DataController().getChatID(context: context)
  }
  
  func viewChatHistory(id: UUID, context: NSManagedObjectContext) {
    isFirstChat = false
    chatID = id
    messages = []
    let tmp = DataController().getMessages(context: context)
    for m in tmp {
      if m.chatID == id {
        messages.append(m)
      }
    }
  }
}
