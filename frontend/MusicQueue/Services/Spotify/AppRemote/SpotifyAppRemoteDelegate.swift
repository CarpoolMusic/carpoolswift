////
////  SpotifyAppRemoteDelegate.swift
////  MusicQueue
////
////  Created by Nolan Biscaro on 2023-07-14.
////
//
//extension SpotifyAppRemoteManager: SPTAppRemoteDelegate {
//    
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        // Connection was successful, you can begin issuing commands
//        self.appRemote = appRemote 
//        self.connectionStatus = .success
//        print("ESTABLISHED CONNECTION")
//    }
//    
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        let errMsg = "Disconneted From Spotify"
//        print(errMsg)
//            if let error = error {
//                print("Error: \(error)")
//            }
//        connectionStatus = .failure(errMsg)
//    }
//    
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        let errMsg = "Disconnected from Spotify"
//        print("Disconnected from Spotify")
//        if let error = error {
//            print("Error: \(error)")
//        }
//        connectionStatus = .failure(errMsg)
//    }
//}
