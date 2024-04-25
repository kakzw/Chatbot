//
//  ChatbotApp.swift
//  Chatbot
//
//  Created by Kento Akazawa on 4/24/24.
//

import SwiftUI

@main
struct ChatbotApp: App {
  @StateObject private var dataController = DataController()
  
  var body: some Scene {
    WindowGroup {
      ChatView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
    }
  }
}
