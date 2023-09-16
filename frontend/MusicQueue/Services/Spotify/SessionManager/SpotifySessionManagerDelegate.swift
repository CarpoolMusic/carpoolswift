//
//  SPTSessionManagerDelegate.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-14.
//

extension SpotifySessionManager: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        /// create new session connection
        self.appRemote.connect(accessToken: session.accessToken)
        
        /// Debugging
        print("success", session)
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
        // Send notification to SpotifyMusicService to notidy that the session failed
//        NotificationCenter.default.post(name: NSNotification.Name("SpotifySessionFailed"), object: nil, userInfo: ["error": error])
        // above is wrong and we should handle errors directly through injection or otherwise
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
//        NotificationCenter.default.post(name: NSNotification.Name("SpotifySessionRenewed"), object: nil, userInfo: ["accessToken": session.accessToken])
        // Other implementation details...
    }
}
