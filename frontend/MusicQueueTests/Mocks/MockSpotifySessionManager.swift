//
//  MockSessionManager.swift
//  MusicQueueTests
//
//  Created by Nolan Biscaro on 2023-10-07.
//

@testable import MusicQueue

class MockSpotifySessionManager: ServiceSessionManagerProtocol {
    
    private lazy var mockSessionManager: SPTSessionManager = {
        
    }
    
    
    func initiateSession(scope: SPTScope) {
        <#code#>
    }
    
    func notifyReturnFromAuth(url: URL) {
        <#code#>
    }
    
    
}
