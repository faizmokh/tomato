//
//  TimerWorker.swift
//  Tomato
//
//  Created by AD0502-ADE-MB-1 on 08/11/2023.
//

import Foundation

// Timer state
enum TimerState {
    case start
    case stop
    case pause
}

protocol TimerWorkerProtocol {
    func start()
    func setDuration(_ duration: TimeInterval)
    func getState() -> TimerState
    func stop()
    func pause()
    func resume()
    
    var timerListener: ((TimeInterval) -> Void)? { get set }
}

class TimerWorker: TimerWorkerProtocol {
    private var timer: Timer?
    private var duration: TimeInterval
    private var state: TimerState
    
    var timerListener: ((TimeInterval) -> Void)?
    
    init(
        duration: TimeInterval = 0,
        state: TimerState = .stop
    ) {
        self.duration = duration
        self.state = state
    }
    
    func setDuration(_ duration: TimeInterval) {
        self.duration = duration
    }
    
    func getState() -> TimerState {
        return state
    }
        
    func start() {
        state = .start
        updateTimer()
    }
    
    func stop() {
        state = .stop
        timer?.invalidate()
        timer = nil
        duration = 0
    }
    
    func pause() {
        timer?.invalidate()
        state = .pause
    }
    
    func resume() {
        state = .start
        updateTimer()
    }
    
    func updateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self else { return }
            if self.duration > 0 {
                self.duration -= 1
            }
            self.timerListener?(self.duration)
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
}
