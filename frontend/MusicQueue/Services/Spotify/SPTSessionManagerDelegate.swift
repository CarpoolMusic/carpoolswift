//
//  SPTSessionManagerDelegate.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-14.
//

class SpotifySessionManagerDelegate: NSObject, SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        // Send notification to SpotifyMusicService to notify that session was initiated
        NotificationCenter.default.post(name: NSNotification.Name("SpotifySessionInitiated"), object: nil, userInfo: ["accessToken": session.accessToken])
        print("I AM IN INTIATED")
        print("success", session)
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
        // Send notification to SpotifyMusicService to notidy that the session failed
        NotificationCenter.default.post(name: NSNotification.Name("SpotifySessionFailed"), object: nil, userInfo: ["error": error])
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
        NotificationCenter.default.post(name: NSNotification.Name("SpotifySessionRenewed"), object: nil, userInfo: ["accessToken": session.accessToken])
        // Other implementation details...
    }
}
