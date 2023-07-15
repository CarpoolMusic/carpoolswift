//
//  ChatView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI

struct ChatView: View {
    
    // MARK: - Properties
    
    @State private var newMessage = ""
    @State private var messages = [
        "Hello",
        "Hi, how are you?",
        "I'm good, thanks! What about you?",
        "I'm great too, thanks for asking!"
    ]
    
    // MARK: - View

    var body: some View {
        VStack {
            List {
                ForEach(messages, id: \.self) { message in
                    Text(message)
                }
            }

            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    sendMessage()
                }) {
                    Text("Send")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
        
    private func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        messages.append(newMessage)
        newMessage = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
