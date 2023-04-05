//
//  Stopwatch.swift
//  BookMark
//
//  Created by BoMin on 2023/04/04.
//

import Foundation
import RxSwift
import RxRelay

//MARK: -StopwatchModel
class Stopwatch {
    private var startTime: Date?
    private var timer: Timer?
    private(set) var elapsedTime: TimeInterval = 0
    
    var isRunning: Bool {
        return timer?.isValid ?? false
    }
    
    func start() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in
            self?.updateElapsedTime()
        })
    }
    
    func pause() {
        timer?.invalidate()
        updateElapsedTime()
    }
    
    func reset() {
        startTime = nil
        timer?.invalidate()
        elapsedTime = 0
    }
    
    private func updateElapsedTime() {
        if let startTime = startTime {
            elapsedTime = -startTime.timeIntervalSinceNow
        }
    }
}

