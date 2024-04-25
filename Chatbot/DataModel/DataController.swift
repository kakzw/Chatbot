//
//  DataController.swift
//  Chatbot
//
//  Created by Kento Akazawa on 4/24/24.
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "DataModel")
  
  init() {
    container.loadPersistentStores { desc, error in
      if let error = error {
        print("Failed to load the data \(error.localizedDescription)")
      }
    }
  }
  
  func save(context: NSManagedObjectContext) {
    do {
      try context.save()
      print("Data saved")
    } catch {
      print("\(error.localizedDescription)")
      print("could not save the data...")
    }
  }
  
  func addMessage(_ msg: Message, context: NSManagedObjectContext) {
    let message = Messages(context: context)
    message.id = msg.id
    message.chatID = msg.chatID
    message.role = msg.role.rawValue
    message.content = msg.content
    message.createAt = msg.createAt
    
    save(context: context)
  }
  
  func getMessages(context: NSManagedObjectContext) -> [Message] {
    var messages: [Message] = []
    let fetchRequest: NSFetchRequest<Messages> = Messages.fetchRequest()
    
    do {
      let result = try context.fetch(fetchRequest)
      messages = result.map { Message(id: $0.id!, chatID: $0.chatID!, role: SenderRole(rawValue: $0.role!)!, content: $0.content!, createAt: $0.createAt!) }
    } catch {
      print("Error fetching messages: \(error.localizedDescription)")
    }
    
    return messages
  }
  
  func addChatID(_ chatHistory: ChatHistory, context: NSManagedObjectContext) {
    let chatID = ChatIDs(context: context)
    chatID.id = chatHistory.id
    chatID.title = chatHistory.title
    chatID.createAt = chatHistory.createAt
    
    save(context: context)
  }
  
  func deleteChatID(_ chatID: ChatIDs, context: NSManagedObjectContext) {
    context.delete(chatID)
    
    save(context: context)
  }
  
  func getChatID(context: NSManagedObjectContext) -> [ChatHistory] {
    var chatHistory = [ChatHistory]()
    let fetchRequest: NSFetchRequest<ChatIDs> = ChatIDs.fetchRequest()
    
    let sortDescriptor = NSSortDescriptor(key: "createAt", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    do {
      let res = try context.fetch(fetchRequest)
      chatHistory = res.map { ChatHistory(id: $0.id!, title: $0.title!, createAt: $0.createAt!) }
    } catch {
      print("Error fetching messages: \(error.localizedDescription)")
    }
    
    return chatHistory
  }
}
