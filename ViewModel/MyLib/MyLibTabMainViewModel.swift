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
    var streak: Observable<Int>
    var readCount: Observable<String>?
    var follower: Observable<String>
    var following: Observable<String>
    let getApi: Observable<MyLib>
    var books = BehaviorSubject<[Books]>(value: [Books(book_id: 0, title: "", authors: [""], translators: [""], publisher: "", titleImage: "", reading: false, favorite: false)])  // [book_id, title, author, translators, publisher, titleImage, reading, favorite]

    init() {
        self.streak = Observable.just(0)
        self.follower = Observable.just(0).map { String($0) }
        self.following = Observable.just(0).map { String($0) }
        
        self.userBackgroundImg = Observable.just(UIImage())
        self.userName = Observable.just("김독서")
        self.userImg = Observable.just(UIImage(named: "noProfileImg") ?? UIImage())
       
        getApi = Network().sendRequest(apiRequest: MyLibModel())

        getApi
            .map { $0.data }
            .catchAndReturn([])
            .filter { $0.isEmpty }
            .map {
                var books = $0
                books.insert(Books(book_id: 0, title: "", authors: [""], translators: [""], publisher: "", titleImage: "", reading: false, favorite: false), at: 0)
                return books
            }
            .bind(to: self.books)
            .disposed(by: disposeBag)

//        getApi
//            .map { $0.meta.totalCount }
//            .map { String($0) }
//            .subscribe(onNext: { [weak self] cnt in
//                self?.readCount = Observable<String>.just(cnt)
//            })
//            .disposed(by: disposeBag)
    }

    deinit {
        disposeBag = DisposeBag()
    }
}
