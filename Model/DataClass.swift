//
//  Data.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import Foundation

struct MyLib: Decodable {
    var data: [Books]
    var meta: Meta
}

struct Books: Decodable {
    var book_id: Int
    var title: String
    var authors: [String]
    var translators: [String]
    var publisher: String
    var titleImage: String
    var reading: Bool
    var favorite: Bool
}

struct Meta: Decodable {
    var sortType: String
    var continuousToken: String
    var currentPage: Int
    var totalCount: Int
    var requestId: String
    var now: Int
}
