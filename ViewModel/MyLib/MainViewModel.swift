//
//  MainViewModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import RxSwift

struct MyLibTabMainViewModel {
    var userBackgroundImg: Observable<UIImage>
    var userName: Observable<String>
    var userImg: Observable<UIImage>
    var streak: Observable<Int>
    var readCount: Observable<String>
    var follower: Observable<String>
    var following: Observable<String>
    
    // [item.book_id, item.img_url, item.title, item.author]
    var books = BehaviorSubject<[Book]>(value: [Book(bookID: 0, bookImgUrl: "", bookTitle: "", bookAuthor: ""), Book(bookID: 1, bookImgUrl: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg", bookTitle: "공포의 계곡", bookAuthor: "아서 코난 도일"), Book(bookID: 2, bookImgUrl: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg", bookTitle: "공포의 계곡", bookAuthor: "아서 코난 도일"), Book(bookID: 3, bookImgUrl: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg", bookTitle: "공포의 계곡", bookAuthor: "아서 코난 도일"), Book(bookID: 4, bookImgUrl: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg", bookTitle: "공포의 계곡", bookAuthor: "아서 코난 도일"), Book(bookID: 5, bookImgUrl: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg", bookTitle: "공포의 계곡", bookAuthor: "아서 코난 도일"), Book(bookID: 6, bookImgUrl: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg", bookTitle: "공포의 계곡", bookAuthor: "아서 코난 도일"), Book(bookID: 7, bookImgUrl: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg", bookTitle: "공포의 계곡", bookAuthor: "아서 코난 도일"), Book(bookID: 8, bookImgUrl: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg", bookTitle: "공포의 계곡", bookAuthor: "아서 코난 도일")])

    init() {
        self.userBackgroundImg = Observable.just(UIImage())
        self.userName = Observable.just("김독서")
        self.userImg = Observable.just(UIImage(named: "noProfileImg") ?? UIImage())
        self.streak = Observable.just(5)
        self.readCount = Observable.just(45).map { String($0) }
        self.follower = Observable.just(32).map { String($0) }
        self.following = Observable.just(59).map { String($0) }
    }
}
