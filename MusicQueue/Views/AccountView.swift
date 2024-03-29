import SwiftUI

struct AccountView: View {
    @State private var username = "JohnDoe123"
    @State private var email = "johndoe@example.com"
    // Add additional account-related states as needed

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(username)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(email)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    // Add more user details here
                }
                
                Section(header: Text("Settings")) {
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Change Password")
                    }
                    NavigationLink(destination: PrivacySettingsView()) {
                        Text("Privacy Settings")
                    }
                    // Add more settings options here
                }
                
                Section {
                    Button("Log Out", action: handleLogOut)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Account")
        }
    }
    
    func handleLogOut() {
        // Implement the log out functionality
        print("User logged out")
    }
}

// Views for each setting option
struct ChangePasswordView: View {
    var body: some View {
        Text("Change Password View")
        // Implement the change password functionality
    }
}

struct PrivacySettingsView: View {
    var body: some View {
        Text("Privacy Settings View")
        // Implement the privacy settings functionality
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
