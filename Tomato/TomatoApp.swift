//
//  TomatoApp.swift
//  Tomato
//
//  Created by AD0502-ADE-MB-1 on 07/11/2023.
//

import SwiftUI

@main
struct TomatoApp: App {
    
    @StateObject var pomodoro = PomodoroWorker()
    
    var headerText: String {
        switch pomodoro.currentSessionState {
        case .work:
            return "Work session"
        case .longBreak:
            return "Long break"
        case .shortBreak:
            return "Short break"
        default:
            return "No session"
        }
    }
    var startButtonText: String {
        if pomodoro.currentTimerState == .stop || pomodoro.currentTimerState == nil {
            return "Start"
        } else if pomodoro.currentTimerState == .pause {
            return "Resume"
        } else {
            return "Pause"
        }
    }
    
    var body: some Scene {
        MenuBarExtra {
            Text(headerText)
            Divider()
            Button {
                if pomodoro.currentTimerState == .stop || pomodoro.currentTimerState == nil {
                    pomodoro.start()
                } else if pomodoro.currentTimerState == .pause {
                    pomodoro.resume()
                } else {
                    pomodoro.pause()
                }
            } label: {
                Text(startButtonText)
            }
            if pomodoro.currentTimerState != .stop {
                Button {
                    pomodoro.stop()
                } label: {
                    Text("Stop")
                }
            }
            Divider()
            Button("About") {
                
            }
            Button("Quit") {
                NSApplication.shared.terminate(self)
            }.keyboardShortcut("q")
        } label: {
            HStack {
                Image(pomodoro.imageIcon)
                    .foregroundStyle(.white)
                    .padding(.trailing, 5)
                Text(pomodoro.timerCountdown)
            }
            .monospacedDigit()
        }
    }
}
