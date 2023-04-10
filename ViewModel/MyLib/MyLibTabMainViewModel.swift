//
//  MainViewModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import RxSwift

class MyLibTabMainViewModel {
    var disposeBag = DisposeBag()
    var userBackgroundImg: Observable<UIImage>
    var userName: Observable<String>
    var userImg: Observable<UIImage>
    var streak = PublishSubject<String>()
    var readCount = PublishSubject<String>()
    var follower: Observable<String>
    var following: Observable<String>
    var books = BehaviorSubject<[Books]>(value: [Books(book_id: "", title: "", authors: [""], translators: [""], publisher: "", titleImage: "", reading: false, favorite: false)])  // [book_id, title, author, translators, publisher, titleImage, reading, favorite]

    init() {
        self.follower = Observable.just(0).map { String($0) }
        self.following = Observable.just(0).map { String($0) }
        
        self.userBackgroundImg = Observable.just(UIImage())
        self.userName = Observable.just("김독서")
        self.userImg = Observable.just(UIImage(named: "noProfileImg") ?? UIImage())
       
        let getApi: Observable<MyLib> = Network().sendRequest(apiRequest: MyLibModel())

        getApi
            .filter { $0.data != nil }
            .map { $0.data! }
            .map {
                var books = $0
                books.insert(Books(book_id: "", title: "", authors: [""], translators: [""], publisher: "", titleImage: "", reading: false, favorite: false), at: 0)
                return books
            }
            .subscribe(onNext: {
                self.books.onNext($0)
            })
            .disposed(by: disposeBag)
        
        getApi
            .map { $0.meta }
            .subscribe(onNext: { meta in
                self.readCount.onNext(String(meta.totalCount))
                self.streak.onNext(meta.continuousToken)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}
