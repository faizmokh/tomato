//
//  SessionStateTests.swift
//  TomatoTests
//
//  Created by AD0502-ADE-MB-1 on 08/11/2023.
//

import XCTest
@testable import Tomato

final class SessionStateTests: XCTestCase {

    var sut: SessionState!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = .idle
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.setUpWithError()
    }
    
    func testSessionState_idleState_shouldHaveNilDuration() {
        sut = .idle
        
        XCTAssertNil(sut.duration)
    }
    
    func testSessionState_workState_shouldHave25MinutesDuration() {
        sut = .work
        
        XCTAssertEqual(sut.duration, 25 * 60)
    }
    
    func testSessionState_shortBreakState_shouldHave5MinutesDuration() {
        sut = .shortBreak
        
        XCTAssertEqual(sut.duration, 5 * 60)
    }
    
    func testSessionState_longBreakState_shouldHave10MinutesDuration() {
        sut = .longBreak
        
        XCTAssertEqual(sut.duration, 10 * 60)
    }
}
