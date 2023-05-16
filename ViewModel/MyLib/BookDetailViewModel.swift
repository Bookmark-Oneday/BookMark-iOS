//
//  BookDetailViewModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import RxSwift
import RxCocoa

class BookDetailViewModel {
    let disposeBag = DisposeBag()
    var bookId: String = ""
    var bookImage = PublishSubject<String>()
    var bookTitle = PublishSubject<String>()
    var bookAuthorAndTranslator = PublishSubject<String>()
    var bookAuthor = PublishSubject<String>()
    var bookTranslator = PublishSubject<String>()
    var bookIsFavorite = BehaviorRelay<Bool>(value: false)
    
    var currentPage = PublishSubject<Int>()
    var totalPage = PublishSubject<Int>()
    
    var firstReadDate = Observable.just("2023.01.09")
    var totalReadingTime = Observable.just("12:28.00")
    
    var readingPercent = PublishSubject<Float>()
    var readingHistory = PublishSubject<[History]?>()
    
    init(bookId: String) {
        self.bookId = bookId
        let getApi: Observable<BookDetail> = Network().sendRequest(apiRequest: BookDetailModel(bookId: bookId))

        getApi
            .map { $0.data }
            .subscribe(onNext: { [weak self] data in
                self?.bookAuthor.onNext(data.authors[0])
                self?.bookImage.onNext(data.titleImage)
                self?.bookTitle.onNext(data.title)
                self?.bookTranslator.onNext(data.translators[0])
                self?.currentPage.onNext(data.current_page)
                self?.totalPage.onNext(data.total_page)
                self?.readingHistory.onNext(data.history)
            })
            .disposed(by: disposeBag)

        Observable.zip(bookAuthor, bookTranslator)
            .map { "\($0) ◦ \($1) 번역" }
            .bind(onNext: { str in
                self.bookAuthorAndTranslator.onNext(str)
            })
            .disposed(by: disposeBag)
        
        Observable.zip(currentPage, totalPage)
            .map { Float(Double($0) / Double($1) * 100) }
            .bind(onNext: { res in
                self.readingPercent.onNext(res)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteBook() {
        let request = DeleteBookModel(bookId: self.bookId)
        Network().sendRequest(apiRequest: request)
            .subscribe(onNext: { rescode in
                
            })
    }
    
}
