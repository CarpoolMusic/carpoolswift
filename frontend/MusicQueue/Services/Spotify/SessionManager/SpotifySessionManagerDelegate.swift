////
////  SPTSessionManagerDelegate.swift
////  MusicQueue
////
////  Created by Nolan Biscaro on 2023-07-14.
////

extension SpotifySessionManager: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("success", session)
        TokenVault.upsertTokenToKeychain(token: session.accessToken)
        self.authenticated?(true)
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Failed to establish session with error \(error)")
        self.authenticated?(false)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Void {
        print("Handling the URL open")
        print("URL", url)
        sessionManager.application(app, open: url, options: options)
        
    }
    
}
