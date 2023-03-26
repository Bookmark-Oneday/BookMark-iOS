//
//  BookDetailViewModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import RxSwift
import RxCocoa

struct History {
    var date: String
    var time: Int
}

struct BookDetailViewModel {
    var bookImage: Observable<UIImage?>
    var bookTitle: Observable<String>
    var bookAuthorAndTranslator: Observable<String>
    var bookAuthor: Observable<String>
    var bookTranslator: Observable<String>
    var bookIsFavorite: BehaviorRelay<Bool>
    
    var currentPage: Observable<Int>
    var totalPage: Observable<Int>
    
    var firstReadDate: Observable<String>
    var totalReadingTime: Observable<String>
    
    var readingPercent: Observable<Float>
    var readingHistory: Observable<[History]>?
    
    init() {
        self.bookImage = UIImage.loadFromUrl("https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg")
        self.bookTitle = Observable.just("공포의 계곡")
        self.bookAuthor = Observable.just("아서 코난 도일")
        self.bookTranslator = Observable.just("김나민")
        self.bookAuthorAndTranslator = Observable.zip(bookAuthor, bookTranslator)
            .map { "\($0) ◦ \($1) 번역" }
        
        self.currentPage = Observable.just(120)
        self.totalPage = Observable.just(354)
        self.readingPercent = Observable.zip(currentPage, totalPage)
            .map { Float(Double($0) / Double($1) * 100) }
        
        self.firstReadDate = Observable.just("2023.01.09")
        self.totalReadingTime = Observable.just("12:28.00")
        
        self.readingHistory = Observable.of([History(date: "12/23", time: 62),
                                             History(date: "12/24", time: 15),
                                             History(date: "12/25", time: 32),
                                             History(date: "12/26", time: 44),
                                             History(date: "12/27", time: 44),
                                             History(date: "12/28", time: 29),
                                             History(date: "12/29", time: 45),
                                             History(date: "12/30", time: 23),
                                             History(date: "12/31", time: 10),
                                             History(date: "1/1", time: 83)])
        
        self.bookIsFavorite = BehaviorRelay<Bool>(value: false)
    }
}
