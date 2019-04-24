//
//  GameClock.swift
//  DSBv2
//
//  Created by Nazario Ayala on 4/25/19.
//  Copyright © 2019 Nazario Ayala. All rights reserved.
//

import Foundation

protocol GameTimerDelegate: class {
    func clockReachedZero(_ clockName: String) -> Void
    func timeHasChangedFor(_ clockName: String, time timeInSeconds: Int) -> Void
}

class GameTimer {
    weak var delegate: GameTimerDelegate?

    private var clockName: String
    private var secondsLeft = 0
    private var durration = 0
    private var clockRunning = false

    private var hours = 0
    private var minutes = 0
    private var seconds = 0
    private var timer: Timer?

    init?(_ clockName: String, _ timerDuration: Int, _ delegate: GameTimerDelegate?) {
        self.clockName = clockName
        self.durration = timerDuration
        self.delegate = delegate
        resetClock()
    }

    func isRunning() -> Bool {
        return self.clockRunning;
    }

    func startClock() -> Void {
        if !isRunning() {
            print("Start clock \(self.clockName)")
            countdownTimer()
        }
    }

    func stopClock() -> Void {
        if self.isRunning() {
            print("Stop clock \(self.clockName)")
            self.pauseClock()
            self.resetClock()
        }
    }

    func pauseClock() -> Void {
        if self.isRunning() {
            print("Pause clock \(self.clockName)")
            self.timer?.invalidate()
            self.timer = nil
            self.clockRunning = false
        }
    }

    func resetClock(_ seconds: Int? = nil) -> Void {
        print("Reset clock \(self.clockName) to \(seconds ?? self.durration)")
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
        self.secondsLeft = seconds ?? self.durration
        self.clockRunning = false
    }

    func timerDuration() -> Int {
        return self.durration;
    }

    private func countdownTimer() {
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        self.clockRunning = true
    }

    @objc private func updateCounter() -> Void {
        if self.secondsLeft > 0 {
            self.secondsLeft = self.secondsLeft - 1
            self.delegate?.timeHasChangedFor(self.clockName, time: self.secondsLeft)
        } else {
            self.stopClock()
            self.delegate?.clockReachedZero(self.clockName)
        }
    }

    static func getHoursFromTimeIn(_ seconds: Int) -> Int {
        return seconds / 3600
    }

    static func getMinutesFromTimeIn(_ seconds: Int) -> Int {
        return (seconds % 3600) / 60
    }

    static func getSecondsFromTimeIn(_ seconds: Int) -> Int {
        return (seconds % 3600) % 60
    }
}
