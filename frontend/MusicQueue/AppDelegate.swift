////
////  AppDelegate.swift
////  MusicQueue
////
////  Created by Nolan Biscaro on 2023-10-07.
////
//
//import Foundation
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    static var shared: AppDelegate!
//
//    var sessionManager: SpotifySessionManager?
//
//    override init() {
//        super.init()
//        AppDelegate.shared = self
//    }
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        print("Done launching")
//        return true
//    }
//
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        self.sessionManager?.returnFromURL(app, open: url, options: options)
//        return true
//    }
//}
