//
//  SignUpView.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-06-30.
//

import Foundation

import SwiftUI

struct CreateAccountView: View {
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @ObservedObject private var signUpViewModel = CreateAccountViewModel()

    var body: some View {
        VStack {
            Spacer()

            // Logo
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 30)

            // Title
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .padding(.bottom, 10)

            // Subtitle
            Text("Sign up to get started")
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .padding(.bottom, 30)

            // Input Fields
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 20)

            Button(action: {
                signUpViewModel.handleSignUpButtonPressed(email: email, username: username, password: password, confirmPassword: confirmPassword)
            }) {
                if signUpViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 32)
                        .padding(.top, 20)
                } else {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 32)
                        .padding(.top, 20)
                }
            }

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .alert(isPresented: $signUpViewModel.isShowingAlert) {
            Alert(title: Text("Error"), message: Text(signUpViewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

import Foundation
import Combine

class CreateAccountViewModel: ObservableObject {
    @Injected private var logger: CustomLoggerProtocol
    @Injected private var apiManager: APIManagerProtocol
    
    @Published var isShowingAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    func handleSignUpButtonPressed(email: String, username: String, password: String, confirmPassword: String) {
        if email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Please fill in all fields."
            isShowingAlert = true
            return
        }

        if password != confirmPassword {
            alertMessage = "Passwords do not match."
            isShowingAlert = true
            return
        }

        isLoading = true
        Task {
            do {
                _ = try await apiManager.createAccountRequest(email: email, username: username, passsword: password)
                DispatchQueue.main.async {
                    self.alertMessage = "Sign up successful!"
                    self.isShowingAlert = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertMessage = error.localizedDescription
                    self.isShowingAlert = true
                }
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
