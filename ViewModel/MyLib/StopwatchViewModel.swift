//
//  StopwatchViewModel.swift
//  BookMark
//
//  Created by BoMin on 2023/04/04.
//

import RxSwift
import RxRelay

//MARK: -StopwatchViewModel
class StopwatchViewModel {
    
    var elapsedTime: Observable<String> {
        return timeElapsedSubject.asObservable().map { self.timeString(time: $0) }
    }
    
    var elapsedTimeValue: Observable<TimeInterval> {
        return timeElapsedSubject.asObservable()
    }
    
//    var startPauseTitle: Observable<String> {
//        return startPauseTitleSubject.asObservable()
//    }
    
//    var startPauseColor: Observable<UIColor> {
//        return startPauseColorSubject.asObservable()
//    }
    
//    var resetButtonIsEnabled: Observable<Bool> {
//        return resetButtonIsEnabledSubject.asObservable()
//    }
    
//    var strokeColor: Observable<UIColor> {
//        return strokeColorSubject.asObservable()
//    }
    
    var timeColor: Observable<UIColor> {
        return timeLabelColorSubject.asObservable()
    }
    
    var totalButtonColor: Observable<UIColor> {
        return totalButtonColorSubject.asObservable()
    }
    
    private let timeElapsedSubject = BehaviorSubject<TimeInterval>(value: 0)
    private let totalTimeSubject = BehaviorSubject<TimeInterval>(value: 0)
    
    private let disposeBag = DisposeBag()
    private let stopwatch: Stopwatch
    
    private var isRunning = false {
        didSet {
//            startPauseTitleSubject.onNext(isRunning ? "Reset" : "Start")
//            startPauseColorSubject.onNext(isRunning ? .systemRed : .systemGreen)
        }
    }
    
//    private var startPauseTitleSubject = BehaviorSubject<String>(value: "Start")
//    private var startPauseColorSubject = BehaviorSubject<UIColor>(value: .systemGreen)

//    private let strokeColorSubject = PublishSubject<UIColor>()
    private let timeLabelColorSubject = PublishSubject<UIColor>()
    private let totalButtonColorSubject = PublishSubject<UIColor>()
    
    private var timerSubscription: Disposable?
    
    private var startTime: Date?
    private var startPauseDate: Date?
    
    private var elapsedTimeCache: TimeInterval = 0
    
    
    init(stopwatch: Stopwatch) {
        self.stopwatch = stopwatch
        scheduleDateCheck()
    }

    func startOrPause() {
        if isRunning {
            reset()
        } else {
            start()
        }
        isRunning = !isRunning
    }
    
    func reset() {
        pause()
        if Calendar.current.isDateInToday(startPauseDate ?? Date()) {
            let currentTime = try? timeElapsedSubject.value()
            totalTimeSubject.onNext((try! totalTimeSubject.value() ) + (currentTime ?? 0))
        } else {
            stopwatch.reset()
            timeElapsedSubject.onNext(0)
            elapsedTimeCache = 0
        }
    }
    
//    func changeStrokeColor() {
//        strokeColorSubject.onNext(.systemBlue)
//    }
//
//    func revertStrokeColor() {
//        strokeColorSubject.onNext(.systemOrange)
//    }
    
    func changeTimeLabelColor() {
        timeLabelColorSubject.onNext(.systemOrange)
    }
    
    func reverTimeLabelColor() {
        timeLabelColorSubject.onNext(UIColor(red: 0.262, green: 0.262, blue: 0.262, alpha: 1))
    }
    
    func changeTotalButtonColor() {
        totalButtonColorSubject.onNext(.white)
    }
    
    func revertTotalButtonColor() {
        totalButtonColorSubject.onNext(.lightOrange)
    }
    
    private func start() {
        startTime = Date()
        timerSubscription = Observable<Int>.interval(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let startTime = self.startTime else { return }
                let elapsedTime = Date().timeIntervalSince(startTime) + self.elapsedTimeCache
                self.timeElapsedSubject.onNext(elapsedTime)
            })
    }
    
    private func pause() {
        guard let startTime = startTime else { return }
        elapsedTimeCache += Date().timeIntervalSince(startTime)
        timerSubscription?.dispose()
        timerSubscription = nil
    }
    
    private func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time - Double(Int(time))) * 100)
        
        if hours >= 1 {
            return String(format: "%02d:%02d", hours, minutes)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func scheduleDateCheck() {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        
        if let elevenFiftyNine = calendar.date(bySettingHour: 23, minute: 59, second: 0, of: Date()) {
            let timeInterval = elevenFiftyNine.timeIntervalSince(Date())
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                print("11:59")
                self.checkForDateChange()
            }
        }
    }
    
    private func checkForDateChange() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) { [weak self] in
            guard let self = self else { return }
            
            self.reset()
            self.scheduleDateCheck()
        }
    }
}
