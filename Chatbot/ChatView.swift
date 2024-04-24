//
//  ContentView.swift
//  Chatbot
//
//  Created by Kento Akazawa on 4/24/24.
//

import SwiftUI

// MARK: - ChatView

struct ChatView: View {
  @ObservedObject var viewModel = ChatViewModel()
  
  var body: some View {
    ZStack {
      VStack {
        TitleTextView()
        
        // display all the messages from user and response
        ScrollViewReader { proxy in
          ScrollView {
            ForEach(viewModel.messages.filter({ $0.role != .system } ), id: \.id) { message in
              messageView(message: message)
            }
          }
          .onAppear {
            // display latest message
            proxy.scrollTo(viewModel.lastMessageId)
          }
          .onChange(of: viewModel.lastMessageId) { oldId, newId in
            // display latest message
            proxy.scrollTo(newId, anchor: .bottom)
          }
          
          TextFieldView(viewModel: viewModel)
        }
        .padding()
      }
      .font(.title3)
      
      // display loading view while getting response from API
      if viewModel.isLoading {
        LoadingView()
      }
    }
  }
  
  // message that user typed and response from ChatGPT
  private func messageView(message: Message) -> some View {
    // display on right for user message
    // display on left for response message
    ChatBubble(direction: message.role == .user ? .right : .left, content: {
      Text(message.content)
        .padding(12)
    })
  }
}

// MARK: - TextFieldView

struct TextFieldView: View {
  @ObservedObject var viewModel: ChatViewModel
  
  var body: some View {
    HStack {
      TextField("Type here...", text: $viewModel.currentInput)
        .onSubmit {
          // when the user hit enter
          // send currently entered message
          if viewModel.currentInput != "" {
            viewModel.sendMessage()
          }
        }
      
      // if the user typed something
      // display a button to delete all text
      // that has been entered
      if viewModel.currentInput != ""{
        Button(action: {
          // delete the text
          viewModel.currentInput = ""
        }, label: {
          Image(systemName: "delete.left")
            .foregroundColor(.secondary)
        })
      }
      
      // button to send message
      Button(action: {
        // sends currently entered message
        viewModel.sendMessage()
      }, label: {
        Image(systemName: "paperplane.fill")
      })
      // cannot tap if nothing is entered
      .disabled(viewModel.currentInput == "")
    }
    .padding(8)
    .padding(.horizontal, 4)
    .overlay {
      // rounded rectable around text
      RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 1)
    }
  }
}

// MARK: - LoadingView

struct LoadingView: View {
  var body: some View {
    ZStack {
      // make the background blury
      Color(.secondarySystemBackground)
        .ignoresSafeArea()
        .opacity(0.9)
      
      VStack {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
          .scaleEffect(5)
        
        Spacer()
          .frame(height: 50)
        
        Text("Generating Response...")
          .font(.title2)
          .bold()
          .foregroundColor(.black)
      }
    }
  }
}

// MARK: - TitleTextView

struct TitleTextView: View {
  var body: some View {
    ZStack {
        Rectangle()
            .fill(Color.orange)
            .edgesIgnoringSafeArea(.top)
        
        Text("Chatbot")
            .font(.largeTitle)
            .bold()
            .foregroundStyle(Color.white)
            .padding(.top, 20)
            .padding(.bottom, 10)
    }
    .frame(maxHeight: 30)
  }
}

#Preview {
  ChatView()
}
