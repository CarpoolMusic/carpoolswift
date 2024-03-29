//
//  MusicQueueApp.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-05.
//

import SwiftUI

@main
struct MusicQueueApp: App {
    
    init() {
        DependencyContainer.shared.registerNotificationCenter(NotificationCenter.default as NotificationCenterProtocol)
        
       
        DependencyContainer.shared.registerSessionManager(sessionId: "", sessionName: "", hostName: "")
        
        DependencyContainer.shared.registerAPIManager(APIManager() as APIManagerProtocol)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

