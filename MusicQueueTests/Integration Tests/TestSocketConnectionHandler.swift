//
//  TestSessionManager.swift
//  MusicQueueTests
//
//  Created by Nolan Biscaro on 2023-10-08.
//

import XCTest
import Combine

@testable import MusicQueue

final class TestSocketConnectionHandler: XCTestCase {
    
    var socketConnectionHandler: Socket!
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        socketConnectionHandler = Socket()
        // Assume that the initial state is unconnected
        XCTAssertFalse(socketConnectionHandler.connected)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        socketConnectionHandler.disconnect()
        
        super.tearDown()
    }
    
    func testConnectionToServer() throws {
        let expectation = XCTestExpectation(description: "Socket should connect")
        
        socketConnectionHandler.$connected
            .filter { $0 == true }
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        socketConnectionHandler.connect()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testDisconnectionFromServer() throws {
        let disconnectionExpectation = XCTestExpectation(description: "Socket should disconnect")
        
        // First, ensure connection
        let connectionExpectation = XCTestExpectation(description: "Socket should connect")
        
        socketConnectionHandler.$connected
            .filter { $0 == true }
            .sink { _ in
                connectionExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        socketConnectionHandler.connect()
        
        wait(for: [connectionExpectation], timeout: 5)
        
        // Now, test disconnection
        socketConnectionHandler.$connected
            .filter { $0 == false }
            .sink { _ in
                disconnectionExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        socketConnectionHandler.disconnect()
        
        wait(for: [disconnectionExpectation], timeout: 5)
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
