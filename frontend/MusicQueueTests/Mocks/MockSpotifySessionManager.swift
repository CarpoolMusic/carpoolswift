//
//  MockSessionManager.swift
//  MusicQueueTests
//
//  Created by Nolan Biscaro on 2023-10-07.
//

@testable import MusicQueue

enum MockError: Error {
    case initiationError(String)
}

class MockSession: SPTSession {
    let mockAccessToken: String?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MockCoder: NSCoder {
    
}

class MockSpotifySessionManager: NSObject, ServiceSessionManagerProtocol {
    // Mock data
    var shouldSucceed: Bool = true
    
    var didInitiateCalled = false
    var didFailWithCalled  = false
    var didRenewCalled = false
    let mockSPTSession: SPTSession
    
    let mockSpotifyClientID = "Mock Id"
    let mockSpotifyRedirectURL = URL(string: "mock redirect url")
    
    /// Manually set ths in the delegate methods
    var mockAccessToken: String?
    
    init(mockSPTSession: MockSession) {
        let mockCoder = MockCoder()
        self.mockSPTSession = mockSPTSession
    }
    
    lazy var configuration = SPTConfiguration(
        clientID: mockSpotifyClientID,
        redirectURL: mockSpotifyRedirectURL!)
    
    lazy var mockSessionManager: SPTSessionManager = {
        if let mockTokenSwapURL = URL(string: "mock token swap URL"),
           let mockTokenRefreshURL = URL(string: "mock token refresh URL") {
            self.configuration.tokenSwapURL = mockTokenSwapURL
            self.configuration.tokenRefreshURL = mockTokenRefreshURL
            /// normally this is set bu the authentication process
            self.configuration.playURI = ""
        }
        return SPTSessionManager(configuration: self.configuration, delegate: self)
    }()
    
    
    func initiateSession(scope: SPTScope) {
        let mockUrl: URL = URL(string: "mock url")!
        /// simulate the callback being triggered when the user returns
        notifyReturnFromAuth(url: mockUrl)
    }
    
    
    func notifyReturnFromAuth(url: URL) {
        if (shouldSucceed) {
            self.sessionManager(manager: mockSessionManager, didInitiate: mockSPTSession)
        }
        else {
            self.sessionManager(manager: mockSessionManager, didFailWith: MockError.initiationError("Mock failed"))
        }
    }
}

extension MockSpotifySessionManager: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        self.didInitiateCalled = true
        self.mockAccessToken = session.accessToken
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        self.didFailWithCalled = true
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        self.didRenewCalled = true
    }
    
}
