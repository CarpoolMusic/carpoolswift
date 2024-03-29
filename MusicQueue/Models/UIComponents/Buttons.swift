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
            .foregroundColor(isSelected ? .blue : .primary)
            .padding()
            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.blue, lineWidth: isSelected ? 2 : 0)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut, value: configuration.isPressed)
    }
}

struct AuthenticationButton: View {
    let action: () -> Void
    let text: String
    let systemImageName: String
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImageName)
                    .foregroundColor(.white)
                Text(text)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PlaybackButton: View {
    let systemImageName: String
    let action: () -> Void
    var buttonSize: CGFloat = 50
    var backgroundColors: [Color] = [Color.blue, Color.purple]
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = 25

    // State for the button's scale effect to animate on tap
    @State private var buttonScale: CGFloat = 1.0

    var body: some View {
        Button(action: {
            // Temporarily scale down the button to give feedback on tap
            self.buttonScale = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.action()
                self.buttonScale = 1.0
            }
        }) {
            Image(systemName: systemImageName)
                .foregroundColor(foregroundColor)
                .frame(width: buttonSize, height: buttonSize)
                .background(LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(cornerRadius)
                .scaleEffect(buttonScale) // Apply the scale effect
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0), value: buttonScale)
    }
}
