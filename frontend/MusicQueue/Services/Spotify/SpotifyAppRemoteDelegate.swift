//
//  SpotifyAppRemoteDelegate.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-14.
//

class SpotifyAppRemoteDelegate: NSObject, SPTAppRemoteDelegate {
    
    private let playerStateDelegate = SpotifyPlayerStateDelegate()
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        // Connection was successful, you can begin issuing commands
        appRemote.playerAPI?.delegate = playerStateDelegate
        appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        print("Connection to app remote success")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Disconnected from Spotify")
            if let error = error {
                print("Error: \(error)")
            }
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Disconnected from Spotify")
        if let error = error {
            print("Error: \(error)")
        }
    }    
}
