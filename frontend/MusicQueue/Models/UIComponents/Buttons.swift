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

struct PlaybackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.largeTitle) // Increase the size of the button label (icon)
            .frame(width: 60, height: 60) // Set the frame to a square shape
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0) // Scale down when pressed
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct IconButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title2)
            .foregroundColor(isSelected ? .blue : .primary) // Change color if selected
            .background(isSelected ? Color.blue.opacity(0.2) : Color.secondary.opacity(0.1)) // Change background if selected
            .scaleEffect(configuration.isPressed || isSelected ? 0.9 : 1.0) // Scale down when pressed or if selected
            .animation(.spring(), value: configuration.isPressed)
    }
}
