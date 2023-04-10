//
//  Data.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import Foundation

struct MyLib: Decodable {
    var data: [Books]?
    var meta: Metas
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

struct Metas: Decodable {
    var sortType: String
    var continuousToken: String
    var currentPage: Int
    var totalCount: Int
    var requestId: String
    var now: Int
}


// MARK: - Welcome
struct Welcome: Codable {
    let data: [Datum]
    let meta: Meta?
}

// MARK: - Datum
struct Datum: Codable {
    let bookID, title: String
    let authors, translators: [String]
    let publisher: String
    let titleImage: String
    let reading, favorite: Bool

    enum CodingKeys: String, CodingKey {
        case bookID = "book_id"
        case title, authors, translators, publisher, titleImage, reading, favorite
    }
}

// MARK: - Meta
struct Meta: Codable {
    let sortType, continuousToken: String?
    let currentPage, totalCount: Int?
    let requestID: String
    let now: Int

    enum CodingKeys: String, CodingKey {
        case sortType, continuousToken, currentPage, totalCount
        case requestID = "requestId"
        case now
    }
}
