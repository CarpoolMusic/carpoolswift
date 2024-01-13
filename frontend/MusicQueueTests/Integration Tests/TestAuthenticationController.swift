//
//  TestAuthenticationController.swift
//  MusicQueueTests
//
//  Created by Nolan Biscaro on 2023-12-05.
//

import XCTest
@testable import MusicQueue

final class TestAuthenticationController: XCTestCase {
    
    var spotifyAuthenticationController: SpotifyAuthenticationController!
    var sessionManager: SpotifySessionManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sessionManager = SpotifySessionManager()
        spotifyAuthenticationController = SpotifyAuthenticationController(sessionManager: sessionManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        spotifyAuthenticationController = nil
        sessionManager = nil
    }
    
    func testSpotifyAuthenticaitonController() throws {
        let expectation = self.expectation(description: "Spotify Authentication Controller Test Success")
        
        spotifyAuthenticationController.authenticate { authenticated in
            if authenticated {
                XCTAssertNotNil(SpotifyAuthenticationController.getTokenFromKeychain(), "Access token should not be nil")
                expectation.fulfill()
            } else {
                XCTFail("Authentication Failed.")
            }
        }
        
        // Wait for the expecations to be fulfilled
        waitForExpectations(timeout: 10, handler: nil)
    }

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
