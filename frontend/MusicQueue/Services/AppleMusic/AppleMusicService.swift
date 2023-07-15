//
//  AppleMusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI
import MusicKit

class AppleMusicService: MusicService, ObservableObject {
    
    // MARK: - Properties
    
    /// Opens a URL using the appropriate system service.
    @Environment(\.openURL) private var openURL
    
    /// The current authorization status of MusicKit.
    @Published var musicAuthorizationStatus: MusicAuthorization.Status = MusicAuthorization.currentStatus
    
    
    /// The current authorization status
    var authorizationStatus: MusicServiceAuthStatus {
        switch musicAuthorizationStatus {
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        default:
            return .notDetermined
        }
    }
    
    // MARK: - Methods
    
    func authorize() {
        // Implement Apple Music's authorization process here
        switch self.authorizationStatus {
            case .notDetermined:
                Task {
                    let status = await MusicAuthorization.request()
                        DispatchQueue.main.async {
                            self.musicAuthorizationStatus = status
                        }
                }
            case .denied:
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            default:
                fatalError("No button should be displayed for current authorization status: \(musicAuthorizationStatus).")
        }
    }

    func startPlayback(songID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement Apple Music's playback here
    }

    func stopPlayback(completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement Apple Music's stop playback here
    }

    func fetchArtwork(for songID: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Implement Apple Music's fetchArtwork here
    }

    // Other methods as needed...
}
