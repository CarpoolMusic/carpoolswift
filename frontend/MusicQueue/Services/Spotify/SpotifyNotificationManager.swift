//
//  SpotifyNotificationManager.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-28.
//


// Notifications from Delegates or UIApplication
//func setupNotificationObservers(authorizationController: SpotifyAuthenticationController) {
//    addReconnectionObserver(authorizationController)
//    addDisconnectObserver()
//    addSessionInitiatedObserver()
//    addTokenSwapObserver()
//}
//
///// LIstens for Re-connect when the user re-opens the application and will reconnect if so
//func addReconnectionObserver(authorizationController: SpotifyAuthenticationController) {
//    NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
//        print("Active again")
//        if let _ = self?.retrieveAccessTokenFromKeychain() {
//            print("RECOONNECTING")
//            self?.appRemote.connect()
//        }
//    }
//}
//
///// Listens for the user disconnecting and cleans up if so
//func addDisconnectObserver() {
//    NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
//        if self?.appRemote.isConnected == true {
//            self?.appRemote.disconnect()
//        }
//    }
//}
//
///// Set Access Token and Connect when the user initiates a session
//func addSessionInitiatedObserver() {
//    NotificationCenter.default.addObserver(forName: NSNotification.Name("SpotifySessionInitiated"), object: nil, queue: .main) { [weak self] notification in
//        if let token = notification.userInfo?["accessToken"] as? String {
//            self?.appRemote.connectionParameters.accessToken = token
//            self?.appRemote.connect()
//            // Save the token in the keychain for session persistence
//            self?.saveAccessTokenToKeychain(token)
//            // update the authorzations status of the user
//            // Note that we only confirm authorization once we have the token
//            self?.authorizationStatus = .authorized
//        }
//    }
//}
//
//
///// Update the user token when session manager performs token swap
//func addTokenSwapObserver() {
//    NotificationCenter.default.addObserver(forName: NSNotification.Name("SpotifySessionRenewed"), object: nil, queue: .main) { [weak self] notification in
//        if let token = notification.userInfo?["accessToken"] as? String {
//            // Save the token in the keychain for session persistence
//            self?.saveAccessTokenToKeychain(token)
//        }
//    }
//}
//
