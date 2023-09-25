//
//  AppleAuthenticationController.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-25.
//
import MusicKit

class AppleAuthenticationController: MusicServiceAuthenticationProtocol {
    
    var isAuthorized: Bool {
        return self.authorizationStatus == .authorized
    }
    
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
    
    func authenticate() {
        // Implement Apple Music's authorization process here
        switch self.authorizationStatus {
        case .notDetermined:
            Task {
                let status = await MusicAuthorization.request()
            }
        case .denied:
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        default:
            fatalError("No button should be displayed for current authorization status: \(self.authorizationStatus).")
        }
    }
    
    
}
