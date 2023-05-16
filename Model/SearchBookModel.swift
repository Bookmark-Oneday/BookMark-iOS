//
//  SearchBookModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/05/16.
//

import Foundation

class SearchBookModel: ApiRequest {
    var headerParam: [String : String]?
    var method: RequestType = .GET
    var path: String = "/v3/search/book"
    var parameters: Dictionary<String, Any>?
    
    init(isbn: String) {
        self.parameters = ["target": "isbn", "query": isbn]
        self.headerParam = ["Authorization": "KakaoAK c68a6c315e578e36648ee925b8bad0dd"]
    }
}
