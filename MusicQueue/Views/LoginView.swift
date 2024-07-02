import SwiftUI
import Combine

struct LoginView: View {
    @State private var identifier: String = ""
    @State private var password: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToHome: Bool = false
    
    @ObservedObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Logo
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 30)
                    .background(Color.clear)
                
                // Title
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 10)
                
                // Subtitle
                Text("Sign in to continue")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 30)
                
                // Input Fields
                VStack(spacing: 15) {
                    TextField("Username or email", text: $identifier)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
                
                Button(action: {
                    if identifier.isEmpty || password.isEmpty {
                        alertMessage = "Please fill in all fields."
                        isShowingAlert = true
                    } else {
                        loginViewModel.handleLoginButtonPressed(identifier: identifier, password: password)
                    }
                }) {
                    if loginViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 32)
                            .padding(.top, 20)
                    } else {
                        Text("Login")
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
                
                // Toggle to Sign Up
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.top, 10)
                
                // SSO Buttons
                VStack(spacing: 15) {
                    Text("or continue with")
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            // Handle SSO with Google
                        }) {
                            Image(systemName: "globe")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            // Handle SSO with Facebook
                        }) {
                            Image(systemName: "f.square")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            // Handle SSO with Apple
                        }) {
                            Image(systemName: "applelogo")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // NavigationLink to HomeView
                NavigationLink(destination: HomeView(), isActive: $loginViewModel.isLoginSuccessful) {
                    EmptyView()
                }
                .hidden()
            }
            .background(Color.white.ignoresSafeArea())
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onReceive(loginViewModel.$isLoginSuccessful) { isLoginSuccessful in
                if isLoginSuccessful {
                    navigateToHome = true
                } else if let errorMessage = loginViewModel.errorMessage {
                    alertMessage = errorMessage
                    isShowingAlert = true
                }
            }
        }
    }
}

class LoginViewModel: ObservableObject {
    @Injected private var logger: CustomLoggerProtocol
    @Injected private var apiManager: APIManagerProtocol
    
    @Published var isShowingAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoginSuccessful: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func handleLoginButtonPressed(identifier: String, password: String) {
        if identifier.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields."
            isShowingAlert = true
            return
        }
        
        do {
            try login(identifier, password)
        } catch let error as CustomError {
            logger.error(error)
        } catch {
            logger.error("Unknown error")
        }
    }
    
    private func login(_ identifier: String, _ password: String) throws {
        self.isLoading = true
        
        Task {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            do {
                guard let response = try await apiManager.loginRequest(idenitifier: identifier, password: password) as? LoginResponse else {
                    throw UnknownResponseError(message: "Unexpected response.")
                }
            
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isLoginSuccessful = true
                    self.errorMessage = nil
                }
                
                let accessTokenData = Data(response.accessToken.utf8)
                let refreshTokenData = Data(response.refreshToken.utf8)
                
                KeychainHelper.standard.save(accessTokenData, service: "com.poles.carpoolapp", account: "accessToken")
                KeychainHelper.standard.save(refreshTokenData, service: "com.poles.carpoolapp", account: "refreshToken")
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isLoginSuccessful = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
