//
//  Pomodoro.swift
//  Tomato
//
//  Created by AD0502-ADE-MB-1 on 07/11/2023.
//

import Foundation

class PomodoroWorker: ObservableObject {
    
    @Published var currentTimerState: TimerState?
    @Published var currentSessionState: SessionState?
    
    @Published var timerCountdown: String = ""
    @Published var imageIcon: String = "default"
    
    private let sessionStateWorker: SessionStateWorker
    private var timerWorker: TimerWorkerProtocol
    private let timer: Timer = Timer()

    private var timeLeft: TimeInterval = 0
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()

    init(
        sessionStateWorker: SessionStateWorker = SessionStateWorker(),
        timerWorker: TimerWorkerProtocol = TimerWorker(),
        timerState: TimerState? = nil,
        sessionType: SessionState? = nil
    ) {
        self.sessionStateWorker = sessionStateWorker
        self.timerWorker = timerWorker
        self.currentTimerState = timerState
        self.currentSessionState = sessionType
        self.timerWorker.timerListener = { [weak self] duration in
            guard let self else { return }
            print(duration)
            if duration == 0 {
                self.sessionStateWorker.nextState()
                self.timerWorker.setDuration(self.sessionStateWorker.getCurrentState().duration)
                self.refreshState()
            }
            self.updateCountdown(timeLeft: duration)
        }
    }
    
    func resume() {
        currentTimerState = .start
        timerWorker.resume()
    }
    
    func stop() {
        currentTimerState = .stop
        resetTimer()
        refreshState()
        self.timerCountdown = ""
    }

    func start() {
        sessionStateWorker.nextState()
        timerWorker.setDuration(sessionStateWorker.getCurrentState().duration)
        timerWorker.start()
        refreshState()
    }
    
    func pause() {
        currentTimerState = .pause
        timerWorker.pause()
    }

    private func resetTimer() {
        sessionStateWorker.resetState()
        timerWorker.stop()
        updateCountdown(timeLeft: 0)
    }
    
    private func updateCountdown(timeLeft: TimeInterval) {
        guard let formattedCountdown = timeFormatter.string(from: timeLeft) else { return }
        self.timerCountdown = formattedCountdown
    }
    
    private func refreshState() {
        currentTimerState = timerWorker.getState()
        currentSessionState = sessionStateWorker.getCurrentState()
        updateIcon()
    }
    
    private func updateIcon() {
        switch currentSessionState {
        case .idle:
            imageIcon = "default"
        case .shortBreak:
            imageIcon = "rest.short"
        case .longBreak:
            imageIcon = "rest.long"
        case .work:
            imageIcon = "work.\(sessionStateWorker.workStateCount)"
        default:
            break
        }
    }
}
