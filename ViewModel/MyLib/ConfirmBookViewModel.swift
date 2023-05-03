//
//  ConfirmBookViewModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import RxSwift

struct ConfirmBookViewModel {
    var bookImage: Observable<UIImage?>
    var bookTitle: Observable<String>
    var bookAuthor: Observable<String>
    var bookPublisher: Observable<String>
    var bookDate: Observable<String>
    var bookPubAndDate: Observable<String>
    var bookSummary: Observable<String>
    
    var bookImageText: String = "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg"
    var bookTitleText: String = "공포의 계곡"
    var bookAuthorText: String = "아서 코난 도일"
    var bookTranslatorText: String = "박상은"
    var bookPublisherText: String = "문예춘추사"
    var bookSummaryText: String = "봄이 시작되는 3월, 급행열차 한 대가 탈선해 절벽 아래로 떨어졌다. 수많은 중상자를 낸 이 대형 사고 때문에 유가족은 순식간에 사랑하는 가족, 연인을 잃었다. 그렇게 두 달이 흘렀을까. 사람들 사이에서 이상한 소문이 돌기 시작하는데…. 역에서 가장 가까운 역인 ‘니시유이가하마 역’에 가면 유령이 나타나 사고가 일어난 그날의 열차에 오르도록 도와준다는 것. 단 유령이 제시한 네 가지 규칙을 반드시 지켜야만 한다. 그렇지 않으면 자신도 죽게 된다. 이를 알고도 유가족은 한 치의 망설임도 없이 역으로 향한다. 과연 유령 열차가 완전히 하늘로 올라가 사라지기 전, 사람들은 무사히 열차에 올라 사랑하는 이의 마지막을 함께할 수 있을까. 틱톡에 소개되어 일본 독자들 사이에서 크게 입소문이 난 화제작. 현실과 판타지를 넘나들며 단숨에 독자를 이야기의 세계로 빠져들게 하는 무라세 다케시의 소설로, 작가의 여러 작품 중 한국에 처음 소개되는 작품이다. 작가가 쓴 작품 중 단연코 손꼽히는 판타지 휴머니즘 소설."
    var bookIsbn: String = ""
    
    init(isbn: String) {
        self.bookIsbn = isbn
        self.bookImage = UIImage.loadFromUrl("https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788976041548.jpg")
        self.bookTitle = Observable.just("공포의 계곡")
        self.bookAuthor = Observable.just("아서 코난 도일")
        self.bookPublisher = Observable.just("문예춘추사")
        self.bookDate = Observable.just("2000.01.01")
        self.bookPubAndDate = Observable.zip(bookPublisher, bookDate)
            .map { "출판사  \($0)   발행일  \($1)" }
        self.bookSummary = Observable.just("봄이 시작되는 3월, 급행열차 한 대가 탈선해 절벽 아래로 떨어졌다. 수많은 중상자를 낸 이 대형 사고 때문에 유가족은 순식간에 사랑하는 가족, 연인을 잃었다. 그렇게 두 달이 흘렀을까. 사람들 사이에서 이상한 소문이 돌기 시작하는데…. 역에서 가장 가까운 역인 ‘니시유이가하마 역’에 가면 유령이 나타나 사고가 일어난 그날의 열차에 오르도록 도와준다는 것. 단 유령이 제시한 네 가지 규칙을 반드시 지켜야만 한다. 그렇지 않으면 자신도 죽게 된다. 이를 알고도 유가족은 한 치의 망설임도 없이 역으로 향한다. 과연 유령 열차가 완전히 하늘로 올라가 사라지기 전, 사람들은 무사히 열차에 올라 사랑하는 이의 마지막을 함께할 수 있을까. 틱톡에 소개되어 일본 독자들 사이에서 크게 입소문이 난 화제작. 현실과 판타지를 넘나들며 단숨에 독자를 이야기의 세계로 빠져들게 하는 무라세 다케시의 소설로, 작가의 여러 작품 중 한국에 처음 소개되는 작품이다. 작가가 쓴 작품 중 단연코 손꼽히는 판타지 휴머니즘 소설.")
    }
    
    func registerBook(totalPage: Int) {
        let request = RegisterBookModel(title: self.bookTitleText, content: self.bookSummaryText, authors: self.bookAuthorText, publisher: self.bookPublisherText, translators: self.bookTranslatorText, thumbnail_url: self.bookImageText, isbn: self.bookIsbn, total_page: totalPage)
        Network().sendRequest(apiRequest: request)
    }
}
