//
//  Sidebar.swift
//  Chatbot
//
//  Created by Kento Akazawa on 4/24/24.
//

import SwiftUI
import CoreData

struct SidebarContentView: View {
  var context: NSManagedObjectContext
  
  @ObservedObject var viewModel: ChatViewModel
  @Binding var showSidebar: Bool
  
  var body: some View {
    VStack {
      List {
        if viewModel.getChatID(context: context).isEmpty {
          Text("No History")
        } else {
          ForEach(viewModel.getChatID(context: context)) { ele in
            Text(ele.title)
              .onTapGesture {
                viewModel.viewChatHistory(id: ele.id, context: context)
                showSidebar = false
              }
          }
        }
      }
      .padding(.vertical)
      .padding(.top)
    }
    .frame(width: 300)
    .frame(maxHeight: .infinity)
  }
}

struct Sidebar<RenderView: View>: View {
  @Binding var isShowing: Bool
  var direction: Edge
  @ViewBuilder var content: RenderView
  
  var body: some View {
    ZStack(alignment: .leading) {
      if isShowing {
        Color.black
          .opacity(0.3)
          .ignoresSafeArea()
          .onTapGesture {
            isShowing.toggle()
          }
        content
          .transition(.move(edge: direction))
          .background { Color.white }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .ignoresSafeArea()
    .animation(.easeInOut, value: isShowing)
  }
}
