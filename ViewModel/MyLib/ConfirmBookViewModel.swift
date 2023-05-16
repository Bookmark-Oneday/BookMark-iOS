//
//  ConfirmBookViewModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import RxSwift

class ConfirmBookViewModel {
    var bookImage = PublishSubject<String>()
    var bookTitle = PublishSubject<String>()
    var bookAuthor = PublishSubject<String>()
    var bookPublisher = PublishSubject<String>()
    var bookDate = PublishSubject<String>()
    var bookSummary = PublishSubject<String>()
    var disposeBag = DisposeBag()
    
    var bookImageText: String = ""
    var bookTitleText: String = ""
    var bookAuthorText: String = ""
    var bookTranslatorText: String = ""
    var bookPublisherText: String = ""
    var bookIsbn: String = ""
    
    init(isbn: String) {
        let getApi: Observable<BookSearch> = Network().sendKakaoRequest(apiRequest: SearchBookModel(isbn: isbn))

        getApi
            .filter { $0.meta.total_count > 0 }
            .map { $0.documents!.first! }
            .subscribe(onNext: { [weak self] in
                let arr = $0.isbn.components(separatedBy: " ")
                self?.bookIsbn = arr[0]
                self?.bookImage.onNext($0.thumbnail)
                self?.bookTitle.onNext($0.title)
                self?.bookAuthor.onNext($0.authors.reduce("") { result, x in result+x+" " })
                self?.bookPublisher.onNext($0.publisher)
                self?.bookDate.onNext($0.datetime.dateFormat(startOffset: 0, endOffset: 10, replacer: "."))
                self?.bookSummary.onNext($0.contents)
                
                self?.bookImageText = $0.thumbnail
                self?.bookTitleText = $0.title
                self?.bookAuthorText = $0.authors.reduce("") { result, x in result+x+" " }
                self?.bookPublisherText = $0.publisher
                self?.bookTranslatorText = $0.translators.reduce("") { result, x in result+x+" " }
            })
            .disposed(by: disposeBag)
    }
    
    func registerBook(totalPage: String) {
        let request = RegisterBookModel(title: self.bookTitleText, authors: self.bookAuthorText, publisher: self.bookPublisherText, translators: self.bookTranslatorText, thumbnail_url: self.bookImageText, isbn: self.bookIsbn, total_page: totalPage)
        
        Network().sendRequest(apiRequest: request)
            .subscribe(onNext: { rescode in
                print("rescode: \(rescode)")
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}
