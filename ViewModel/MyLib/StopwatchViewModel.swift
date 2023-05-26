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
    
    var timeColor: Observable<UIColor> {
        return timeLabelColorSubject.asObservable()
    }
    
    var totalButtonColor: Observable<UIColor> {
        return totalButtonColorSubject.asObservable()
    }
    
    private let timeElapsedSubject = BehaviorSubject<TimeInterval>(value: 0)
    private let totalTimeSubject = BehaviorSubject<TimeInterval>(value: 0)
    
    var durationFromAPI: BehaviorSubject<TimeInterval> = BehaviorSubject(value: 120)
    
    let disposeBag = DisposeBag()
    let stopwatch: Stopwatch
    
    var bookId: String = ""
    var readHistory: [[String]] = [[""]]
    
    var isRunning = false {
        didSet {
            
//            startPauseTitleSubject.onNext(isRunning ? "Reset" : "Start")
//            startPauseColorSubject.onNext(isRunning ? .systemRed : .systemGreen)
            startPauseButtonImage.onNext(isRunning ? "resume" : "play")
            
        }
    }
    
    private let timeLabelColorSubject = PublishSubject<UIColor>()
    private let totalButtonColorSubject = PublishSubject<UIColor>()
    
    var startPauseButtonImage = BehaviorSubject<String>(value: "play")
    
    private var timerSubscription: Disposable?
    
    private var startTime: Date?
    private var startPauseDate: Date?
    
    private var elapsedTimeCache: TimeInterval = 0
    
    private var sendTimeSubscription: Disposable?
    
    var stopwatchisRunning = BehaviorRelay<Bool>(value: false)
    
    private var historyList: [History] = []

    let historyListObservable: BehaviorSubject<[History]> = BehaviorSubject(value: [])
    
    let rowHeights = BehaviorSubject<Int>(value: 50)
    let rowCount = BehaviorSubject<Int>(value: 0)
    
    
    init(stopwatch: Stopwatch, bookId: String) {
        self.stopwatch = stopwatch
        self.bookId = bookId
        scheduleDateCheck()
        getData()
        getHistoryData()
    }
    
    func getData() {
        let getApi: Observable<StopWatch> = Network().sendRequest(apiRequest: StopwatchModel(bookId: bookId))

        getApi
            .map { $0.data }
            .subscribe(onNext: { [weak self] data in
                
                guard let strongSelf = self else { return }
                
                let dailyTime = TimeInterval(data.daily)
                let targetTime = TimeInterval(data.target_time)

//                strongSelf.timeElapsedSubject.onNext(dailyTime)
                
//                strongSelf.elapsedTimeCache = dailyTime
                strongSelf.elapsedTimeCache += dailyTime
                strongSelf.timeElapsedSubject.onNext(strongSelf.elapsedTimeCache)
                
                strongSelf.totalTimeSubject.onNext(targetTime)
                strongSelf.bookId = data.book.book_id
                strongSelf.durationFromAPI.onNext(TimeInterval(targetTime))
                                
//                print(data.book.book_id)
//                print(data.daily)
//                print(data.target_time)
                
            })
            .disposed(by: disposeBag)
        
    }
    
    func getHistoryData() {
        let getApi: Observable<StopWatch> = Network().sendRequest(apiRequest: StopwatchModel(bookId: bookId))
        
        getApi
            .map { $0.data.book.history }
            .subscribe(onNext: { [weak self] historyList in
                self?.historyList = historyList
                self?.historyListObservable.onNext(historyList)
                
                print(historyList)
                
                historyList.forEach {
                    print($0.date)
                    print($0.time)
                    print("---")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func sendTime(readingTime: Int) {
        
        let requestModel = SendTimeModel(bookId: bookId, readingTime: readingTime)
        
        Network().sendRequestWithNoResponse(apiRequest: requestModel)
            .subscribe(
                onNext: { statusCode in
                    print("Server responded with status code: \(statusCode)")
                },
                onError: { error in
                    print("An error occurred while sending the request: \(error)")
                    
                }
            )
            .disposed(by: disposeBag)
    }
    
    func deleteTime() {
        let request = DeleteTimeModel(bookId: self.bookId)
        Network().sendRequestWithNoResponse(apiRequest: request)
            .subscribe(onNext: { rescode in
                print(rescode)
            })
            .disposed(by: disposeBag)
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
        stopwatch.pause()
        
        if Calendar.current.isDateInToday(startPauseDate ?? Date()) {
            let currentTime = try? timeElapsedSubject.value()
            totalTimeSubject.onNext((try! totalTimeSubject.value() ) + (currentTime ?? 0))
        } else {
            stopwatch.reset()
            timeElapsedSubject.onNext(0)
            elapsedTimeCache = 0
        }
    }
    
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
        sendTimeSubscription?.dispose()
    }
    
    private func pause() {
//        guard let startTime = startTime else { return }
//        let currentValue = try? timeElapsedSubject.value()
//        elapsedTimeCache = currentValue ?? 0
//        self.sendTimeSubscription = self.timeElapsedSubject.subscribe(onNext: { value in
//            print("Value:", value)
//            let elapsedTime = Int(value)
//            self.sendTime(readingTime: elapsedTime)
//        })
//        timerSubscription?.dispose()
//        timerSubscription = nil
        
        guard let startTime = startTime else { return }
        let currentValue = try? timeElapsedSubject.value() // 현재 Observable의 값을 가져옵니다.
        let elapsedTime = (currentValue ?? 0) - elapsedTimeCache // 마지막으로 pause되었던 시간을 뺀다.
        elapsedTimeCache = 0  // 여기서 elapsedTimeCache를 0으로 reset합니다.
        self.sendTimeSubscription = self.timeElapsedSubject.subscribe(onNext: { [weak self] _ in
            print(elapsedTime)
            self?.sendTime(readingTime: Int(elapsedTime)) // elapsedTime만큼 읽었다는 것을 서버로 보낸다.
        })
        timerSubscription?.dispose()
        timerSubscription = nil
    }
    
    func timeString(time: TimeInterval) -> String {
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
    
    func historyStringFormat(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        if hours >= 1 {
            return String(format: "%02dh %02dm", hours, minutes)
        } else {
            if (minutes != 0) {
                return String(format: "%02dm", minutes)
            } else {
                if seconds >= 10 {
                    return String(format: "%02ds", seconds)
                } else {
                    return String(format: "%ds", seconds)
                }
            }
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
