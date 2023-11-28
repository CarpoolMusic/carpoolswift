//
//  TestSessionManager.swift
//  MusicQueueTests
//
//  Created by Nolan Biscaro on 2023-10-08.
//

import XCTest
@testable import MusicQueue

final class TestSessionManager: XCTestCase {
    
    var sessionManager: SessionManager!
    var otherSessionManager: SessionManager!
    let TEST_HOST_NAME: String = "testHost"
    let TEST_SESSION_NAME: String = "testSession"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sessionManager = SessionManager()
        
        // ensure that we start with no active sessions
        XCTAssertFalse(sessionManager.isConnected)
        
        // connect session manager to server
        sessionManager.connect()
        
        // ensure that the connection handler is connected
        // NOTE: in the app all buttons will be disabled until connection is achieved
        // Waiting for expecations is used in testing only and simulates this
        let connectionHandlerExpecation = expectation(description: "Session Manager should be connected and isConnceted should be true")
        let cancellable = sessionManager.$isConnected.sink { connected in
            if connected {
                connectionHandlerExpecation.fulfill()
            }
        }
        
        // Wait for the expecations to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
        
        // Clean up
        cancellable.cancel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateSessionSuccess() throws {
        let sessionCreatedExpectation = expectation(description: "Session should be created and is active should be true. Session information should be returned")
        // Observe the 'isActive' property
        let cancellable = sessionManager.$isActive.sink { isActive in
            if isActive {
                sessionCreatedExpectation.fulfill()
            }
        }
        
        // Trigger the session creation on the client
        try sessionManager.createSession(hostName: TEST_HOST_NAME, sessionName: TEST_SESSION_NAME)
            
        
        // Wait for the expecations to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotEqual("", sessionManager.sessionId)
        
        
        // Clean up
        cancellable.cancel()
    }
    
    func testCreateSessionDisconnected() throws {
        // Disconnect from the session to simulate a break in the connection
        sessionManager.disconnect()
        let connectionDisconnectedExpecation = expectation(description: "Session should be disconnected and connected variable set to false")
        let cancellable = sessionManager.$isConnected.sink { connected in
            if !connected {
                connectionDisconnectedExpecation.fulfill()
            }
        }
        
        // Wait for the expecations to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertThrowsError(try sessionManager.createSession(hostName: TEST_HOST_NAME, sessionName: TEST_SESSION_NAME)) { error in
            XCTAssertEqual(error as? SocketError, SocketError.notConnected)
        }
        
        cancellable.cancel()
        // THIS IS TEMP DONT RELY ON THIS
        sessionManager.isActive = false
    }
    
    func testAddSong() throws {
        
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
