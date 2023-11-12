//
//  SessionState.swift
//  Tomato
//
//  Created by AD0502-ADE-MB-1 on 08/11/2023.
//

import Foundation

enum SessionState {
    case idle
    case work
    case shortBreak
    case longBreak
    
    var duration: TimeInterval {
        switch self {
        case .idle:
            return 0
        case .work:
            return 2 * 60
//            return 25 * 60
        case .shortBreak:
            return 1 * 30
//            return 5 * 60
        case .longBreak:
            return 1 * 60
//            return 10 * 60
        }
    }
}
