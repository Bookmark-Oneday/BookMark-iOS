//
//  Data.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import Foundation

// MARK: B.1
struct MyLib: Decodable {
    var data: [Books]?
    var meta: LibMeta
}

struct Books: Decodable {
    var book_id: String
    var title: String
    var authors: [String]
    var translators: [String]
    var publisher: String
    var titleImage: String
    var reading: Bool
    var favorite: Bool
}

struct LibMeta: Decodable {
    var sortType: String
    var continuousToken: String
    var currentPage: Int
    var totalCount: Int
    var requestId: String
    var now: Int
}

// MARK: - B.2
struct BookDetail: Decodable {
    let data: BookDetailData
    let meta: BookDetailMeta
}

struct History: Decodable {
    let id, date: String
    let time: Int
}

struct BookDetailData: Decodable {
    let book_id, title: String
    let authors, translators: [String]
    let publisher: String
    let titleImage: String
    let current_page, total_page: Int
    let history: [History]?
}

struct BookDetailMeta: Decodable {
    let requestId: String
    let now: Int
}
