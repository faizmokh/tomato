//
//  SessionStateWorkerTests.swift
//  TomatoTests
//
//  Created by AD0502-ADE-MB-1 on 08/11/2023.
//

import XCTest
@testable import Tomato

final class SessionStateWorkerTests: XCTestCase {

    var sut: SessionStateWorker!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SessionStateWorker()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testSessionState_initialCurrentState_shouldBeIdle() {
        sut = SessionStateWorker()
        
        XCTAssertEqual(sut.getCurrentState(), .idle)
    }

    func testSessionState_fromIdleState_nextStateShouldBeWorkState() {
        sut = SessionStateWorker(state: .idle)
        
        sut.nextState()
        
        XCTAssertEqual(sut.getCurrentState(), .work)
    }
    
    func testSessionState_fromWorkState_nextStateShouldBeShortBreakState() {
        sut = SessionStateWorker(state: .work)
        
        sut.nextState()
        
        XCTAssertEqual(sut.getCurrentState(), .shortBreak)
    }
    
    func testSessionState_fromShortBreakState_nextStateShouldBeWorkStateAgain() {
        sut = SessionStateWorker(state: .shortBreak)
        
        sut.nextState()
        
        XCTAssertEqual(sut.getCurrentState(), .work)
    }
    
    func testSessionState_initialWorkStateCount_shouldBeZero() {
        sut = SessionStateWorker()
        
        XCTAssertEqual(sut.workStateCount, 0)
    }
    
    func testSessionState_whenReachWorkState_WorkStateCountShouldIncrease() {
        sut = SessionStateWorker()
        
        sut.nextState()
        
        XCTAssertEqual(sut.workStateCount, 1)
        
        sut.nextState() // short break
        sut.nextState() // work
        
        XCTAssertEqual(sut.workStateCount, 2)
    }
    
    func testSessionState_whenWorkStateCountIsFour_nextStateShouldBeLongBreakState() {
        sut = SessionStateWorker()
        
        sut.nextState() // work
        XCTAssertEqual(sut.getCurrentState(), .work)
        XCTAssertEqual(sut.workStateCount, 1)
        sut.nextState() // short break
        XCTAssertEqual(sut.getCurrentState(), .shortBreak)
        sut.nextState() // work
        XCTAssertEqual(sut.getCurrentState(), .work)
        XCTAssertEqual(sut.workStateCount, 2)
        sut.nextState() // short break
        XCTAssertEqual(sut.getCurrentState(), .shortBreak)
        sut.nextState() // work
        XCTAssertEqual(sut.getCurrentState(), .work)
        XCTAssertEqual(sut.workStateCount, 3)
        sut.nextState() // short break
        XCTAssertEqual(sut.getCurrentState(), .shortBreak)
        sut.nextState() // work
        XCTAssertEqual(sut.getCurrentState(), .work)
        XCTAssertEqual(sut.workStateCount, 4)

        sut.nextState()
        XCTAssertEqual(sut.getCurrentState(), .longBreak)
        XCTAssertEqual(sut.workStateCount, 1) // reset back work count
    }
    
    func testSessionState_whenSessionReset_theCurrentStateShouldBeIdle() {
        sut.resetState()
        
        XCTAssertEqual(sut.getCurrentState(), .idle)
    }
}
