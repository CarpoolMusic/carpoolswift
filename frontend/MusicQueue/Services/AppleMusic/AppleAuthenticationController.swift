// MARK: - CodeAI Output
/**
 This code is a Swift implementation of an AppleAuthenticationController class that conforms to the MusicServiceAuthenticationProtocol. It provides functionality for authenticating with the MusicKit framework and checking the authorization status.

 The class has the following properties:
 - `isAuthorized`: A computed property that returns a boolean indicating whether the user is authorized.
 - `authorizationStatus`: A computed property that returns the current authorization status using the MusicAuthorization.currentStatus property.

 The class has the following methods:
 - `authenticate(authenticated:)`: A method that takes a closure as a parameter and authenticates the user. It checks the authorization status and performs different actions based on it.
 - `openSettings()`: A private method that opens the device settings if authorization is denied.

 To use this code, you need to import the MusicKit framework.
 */

import MusicKit

class AppleAuthenticationController: MusicServiceAuthenticationProtocol {
    
    /**
     A computed property that returns a boolean indicating whether the user is authorized.
     */
    var isAuthorized: Bool {
        return self.authorizationStatus == .authorized
    }
    
    /**
     A computed property that returns the current authorization status using the MusicAuthorization.currentStatus property.
     */
    var authorizationStatus: MusicServiceAuthStatus {
        switch MusicAuthorization.currentStatus {
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        default:
            return .denied
        }
    }
    
    /**
     Authenticates the user by checking the authorization status and performing different actions based on it.
     
     - Parameters:
       - authenticated: A closure that takes a boolean parameter indicating whether authentication was successful or not.
     */
    func authenticate(authenticated: @escaping ((Bool) -> (Void))) {
        switch self.authorizationStatus {
        case .authorized:
            authenticated(true)
            
        case .notDetermined:
            Task {
                let status = await MusicAuthorization.request()
                authenticated(status == .authorized)
            }
            
        case .denied:
            openSettings()
        }
    }
    
    /**
     Opens the device settings if authorization is denied.
     */
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        UIApplication.shared.open(settingsURL)
    }
}
