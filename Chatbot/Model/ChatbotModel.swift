//
//  ChatbotModel.swift
//  Chatbot
//
//  Created by Kento Akazawa on 4/24/24.
//

import SwiftUI

// Message structure for both user input and response
struct Message: Decodable {
  let id: UUID
  let chatID: UUID
  let role: SenderRole
  let content: String
  let createAt: Date
}

struct ChatHistory: Identifiable {
  let id: UUID
  let title: String
  let createAt: Date
}
