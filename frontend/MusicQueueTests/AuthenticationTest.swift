//
//  AuthenticationTest.swift
//  MusicQueueTests
//
//  Created by Nolan Biscaro on 2023-10-07.
//

import XCTest
@testable import MusicQueue

final class AuthenticationTest: XCTestCase {
    
    var authController: SpotifyAuthenticationController!
    var mockSession: MockSession!
    var mockSessionManager: MockSpotifySessionManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let coder: NSCoder = MockCoder()
        mockSession = MockSession(coder: coder)
        mockSessionManager = MockSpotifySessionManager()
        authController = SpotifyAuthenticationController(sessionManager: mockSessionManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
//    func testAuthenticationSuccessful() throws {
//        self.authController.authenticate() { authenticated in
//            XCTAssertTrue(authenticated)
//            XCTAssertTrue(self.mockSessionManager.initiateSessionCalled)
//            XCTAssertTrue(self.mockSessionManager.returnFromURLCalled)
//            XCTAssertTrue(self.mockSessionManager.didInitiateCalled)
//            
//        }
//    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
