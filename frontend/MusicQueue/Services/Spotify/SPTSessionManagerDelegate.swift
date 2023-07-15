//
//  SPTSessionManagerDelegate.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-14.
//

class SpotifySessionManagerDelegate: NSObject, SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("success", session)
        // Other implementation details...
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
        // Other implementation details...
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
        // Other implementation details...
    }
}
