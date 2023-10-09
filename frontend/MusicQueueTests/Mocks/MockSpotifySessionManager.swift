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
    let mockAccessToken: String? = ""
    
}

class MockCoder: NSCoder {
    
}

class MockSpotifySessionManager: NSObject, ServiceSessionManagerProtocol {
    // Mock data
    var shouldSucceed: Bool = true
    
    var initiateSessionCalled = false
    var returnFromURLCalled = false
    
    var didInitiateCalled = false
    var didFailWithCalled  = false
    var didRenewCalled = false
    
    let mockSpotifyClientID = "Mock Id"
    let mockSpotifyRedirectURL = URL(string: "mock redirect url")
    
    var authenticated: ((Bool) -> (Void))?
    
    let mockSPTSession: MockSession = MockSession(coder: MockCoder())!
    
    /// Manually set ths in the delegate methods
    var mockAccessToken: String?
    
    override init() {
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
    
    
    func initiateSession(scope: SPTScope, authenticated: @escaping ((Bool) -> (Void))) {
        self.authenticated = authenticated
        /// simulate the callback being triggered when the user returns
        let app = UIApplication()
        let mockUrl: URL = URL(string: "mock url")!
        let options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        returnFromURL(UIApplication(), open: mockUrl, options: options)
    }
    
    func returnFromURL(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        returnFromURLCalled = true
        
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
        self.authenticated?(true)
        self.mockAccessToken = session.accessToken
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        self.authenticated?(false)
        self.didFailWithCalled = true
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        self.authenticated?(false)
        self.didRenewCalled = true
    }
    
}
