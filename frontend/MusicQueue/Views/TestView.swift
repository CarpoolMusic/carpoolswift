//
//  TestView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-11.
//

import SwiftUI

struct MainView: View {
    @State private var isListViewOpen = false
    var body: some View {
        ZStack {
            // Main Content
            VStack {
                Text("Main Content")
                    .font(.largeTitle)
                    .padding()
                
                
                // Button to Open ListView
                Button(action: { withAnimation { self.isListViewOpen.toggle() } }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .zIndex(1) // To ensure Main Content stays in front when ListView is not open.
            
            // ListView
            if isListViewOpen {
                VStack {
                    List {
                        ForEach(0..<20) { item in
                            Text("List Item \(item)")
                        }
                    }
                    Spacer()
                }
                .background(Color.gray.opacity(0.5)) // To provide a visual separation from the Main Content
                .transition(.move(edge: .bottom)) // Transition effect when ListView appears/disappears.
                .offset(y: isListViewOpen ? UIScreen.main.bounds.height * 0.10 : UIScreen.main.bounds.height)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
