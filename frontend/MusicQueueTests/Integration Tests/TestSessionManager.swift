//
//  TestSessionManager.swift
//  MusicQueueTests
//
//  Created by Nolan Biscaro on 2023-10-08.
//

import XCTest
@testable import MusicQueue

final class TestSessionManager: XCTestCase {
    
    var socketConnectionHandler: SocketConnectionHandler!
    var sessionManager: SessionManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        socketConnectionHandler = SocketConnectionHandler()
        sessionManager = SessionManager(socketConnectionHandler: socketConnectionHandler)
        
        // ensure that we start with no active sessions
        XCTAssertFalse(sessionManager.isActive)
        
        // ensure that the connection handler is connected
        // NOTE: in the app all buttons will be disabled until connection is achieved
        // Waiting for expecations is used in testing only and simulates this
        let connectionHandlerExpecation = expectation(description: "Connection handler should be created and connected")
        let cancellable = socketConnectionHandler.$connected.sink { connected in
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
        socketConnectionHandler.disconnect()
        
        super.tearDown()
    }
    
    func testCreateSession() throws {
        let sessionCreatedExpectation = expectation(description: "Session should be created and is active should be true.")
        // Observe the 'isActive' property
        let cancellable = sessionManager.$isActive.sink { isActive in
            if isActive {
                sessionCreatedExpectation.fulfill()
            }
        }
        
        // Trigger the session creation on the client
        try sessionManager.createSession()
            
        
        // Wait for the expecations to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
        
        // Clean up
        cancellable.cancel()
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
