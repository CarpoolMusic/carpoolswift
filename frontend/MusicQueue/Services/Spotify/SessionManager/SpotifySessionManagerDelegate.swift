//
//  SPTSessionManagerDelegate.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-14.
//

extension SpotifySessionManager: SPTSessionManagerDelegate, UIApplicationDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("success", session)
        // STORE IN USER DEFAULTS IS TEMP AND FOR TESTING ONLY
        // this will evenutally be a request to the backend to store the token
        let accessToken: String = session.accessToken
        let refreshToken: String = session.refreshToken
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(refreshToken, forKey: "accessToken")
        
        /// set the authentication closure to notify the caller of authentication status
        self.authenticated?(true)
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
