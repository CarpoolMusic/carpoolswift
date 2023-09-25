//
//  Buttons.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-06.
//
import SwiftUI

struct ButtonImageTextView: View {
        let action: () -> Void
        let buttonText: Text
        let buttonStyle: ButtonBackgroundStyle
        let buttonImage: Image
        
        var body: some View {
            Button(action: action) {
                HStack {
                    buttonText
                    buttonImage
                }
            }
            .buttonStyle(ButtonBackgroundStyle())
        }
    }

struct ButtonImageView: View {
    let action: () -> Void
    let buttonImage: Image
    
    var body: some View {
        Button(action: action) {
            HStack {
                buttonImage
            }
        }
    }
}

struct ButtonTextView: View {
        let action: () -> Void
        let buttonText: Text
        let buttonStyle: ButtonBackgroundStyle
        
        var body: some View {
            Button(action: action) {
                HStack {
                    buttonText
                }
            }
            .buttonStyle(ButtonBackgroundStyle())
        }
    }
    
    struct ButtonBackgroundStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(configuration.isPressed ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8.0)
        }
    }
