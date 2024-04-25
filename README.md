# SwiftUI Chatbot

SwiftUI Chatbot is a simple iOS application that allows users to chat with an AI-powered assistant built on OpenAI's GPT-3.5 model. This project demonstrates how to integrate SwiftUI with Core Data for managing chat history and Alamofire for making API requests to the OpenAI service.

## Features

- **Real-time Chat**: Users can engage in real-time conversations with the AI assistant.
- **Chat History**: Previous chat sessions are saved using Core Data, allowing users to view past conversations.
- **Dynamic UI**: SwiftUI is used to create a dynamic user interface that updates in response to user input and API responses.
- **Loading Indicator**: A loading indicator is displayed while waiting for the AI assistant's response.

## Screenshots

<img src="https://github.com/kakzw/Quiz/assets/167830553/0e0e204c-f346-427c-b7c5-09155deec476" width="300">
<img src="https://github.com/kakzw/Quiz/assets/167830553/3a49c75d-72e2-4cc8-b192-3268c4fcbd2b" width="300">
<img src="https://github.com/kakzw/Quiz/assets/167830553/d204f722-8086-4251-8d24-6cd5c4f8e3c2" width="300">
<img src="https://github.com/kakzw/Quiz/assets/167830553/dcf64d62-7f42-4a8d-8704-1be94c889396" width="300">

## Installation

- To run this app, make sure you have `XCode` installed.
- Clone this repository.
- Open `Chatbot.xcodeproj` in `XCode`.
- Open `constants.swift` and enter your API key for `OpenAI`. Please visit <a href="https://openai.com/blog/openai-api">here</a> to obtain API key.
  <img width="700" alt="constants" src="https://github.com/kakzw/Quiz/assets/167830553/2172d55c-4df6-4b3b-a2ce-126ab65d2683">
- Build and run the app on your iOS device or simulator.

## Usage

1. Upon launching the app, users are greeted with a chat interface.
2. Type a message in the text field at the bottom and press "Send" or hit Enter to send the message to the AI assistant.
3. The AI assistant will respond with a message, which will appear in the chat interface.
4. Users can view their chat history by opening the sidebar and selecting a previous chat session.

## Dependencies

- **Alamofire**: Used for making HTTP requests to the OpenAI API.
- **Core Data**: Manages chat history storage and retrieval.
