//
//  SessionStateWorker.swift
//  Tomato
//
//  Created by AD0502-ADE-MB-1 on 08/11/2023.
//

import Foundation

/// Handles sessions state changes
class SessionStateWorker {
    private var currentState: SessionState {
        didSet {
            if currentState == .work {
                workStateCount += 1
            }
        }
    }
    private(set) var workStateCount: Int
    
    init(
        state: SessionState = .idle,
        workStateCount: Int = 0
    ) {
        self.currentState = state
        self.workStateCount = workStateCount
    }
    
    func getCurrentState() -> SessionState {
        return currentState
    }
    
    func resetState() {
        workStateCount = 0
        currentState = .idle
    }
    
    func nextState() {
        if workStateCount == 4 {
            currentState = .longBreak
            workStateCount = 1
            return
        }
        
        switch currentState {
        case .idle:
            currentState = .work
        case .work:
            currentState = .shortBreak
        case .shortBreak:
            currentState = .work
        case .longBreak:
            currentState = .work
        }
    }
}
