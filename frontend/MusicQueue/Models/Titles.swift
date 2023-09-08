//
//  Titles.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-06.
//
import SwiftUI

struct AppTitleView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.primary)
            .font(.largeTitle.weight(.semibold))
            .shadow(radius: 2)
            .padding(.bottom, 1)
        Text(subtitle)
            .foregroundColor(.primary)
            .font(.title2.weight(.medium))
            .multilineTextAlignment(.center)
            .shadow(radius: 1)
            .padding(.bottom, 16)
    }
}

struct TitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.primary)
            .font(.largeTitle.weight(.semibold))
            .shadow(radius: 2)
            .padding(.bottom, 1)
    }
}

struct TextFieldView: View {
    let displayText: String
    let inputText: Binding<String>
    
    var body: some View {
        TextField(displayText, text: inputText)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
