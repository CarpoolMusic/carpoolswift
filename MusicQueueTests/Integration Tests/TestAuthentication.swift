//
//  TestAuthentication.swift
//  MusicQueueTests
//
//  Created by Nolan Biscaro on 2023-12-05.
//

import XCTest
@testable import MusicQueue

final class TestAuthentication: XCTestCase {
    
    var viewModel: AuthorizationViewModel!

    override func setUpWithError() throws {
        viewModel = AuthorizationViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testAppleMusicAuthenticationSuccess() throws {
        let expectation = self.expectation(description: "Apple Music Authentication Success")
        viewModel.authenticated = { authenticated in
            XCTAssertTrue(authenticated)
            XCTAssertEqual(self.viewModel.musicServiceType, .apple)
            XCTAssertTrue(self.viewModel.isAuthenticated)
            expectation.fulfill()
        }
        viewModel.handleAppleButtonPressed()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSpotifyAuthenticationSuccess() throws {
        let expectation = self.expectation(description: "Spotify Authentication Success")
        viewModel.authenticated = { authenticated in
            XCTAssertTrue(authenticated)
            XCTAssertEqual(self.viewModel.musicServiceType, .spotify)
            XCTAssertTrue(self.viewModel.isAuthenticated)
            expectation.fulfill()
        }
        viewModel.handleSpotifyButtonPressed()
        waitForExpectations(timeout: 5, handler: nil)
        }
    
    func testSpotifyAuthenticationController() throws {
        let expectation = self.expectation(description: "Spotiy Authentication Controller Success ")
        
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
