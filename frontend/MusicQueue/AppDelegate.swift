//
//  AppDelegate.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-10-07.
//

import Foundation

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    /// notify session manager that the user has returned to the app
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let sessionManager: SpotifySessionManager = SpotifySessionManager()
    }
}
