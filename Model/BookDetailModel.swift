//
//  BookDetailModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/04/11.
//

import Foundation

class BookDetailModel: ApiRequest {
    var headerParam: [String : String]?
    var method: RequestType = .GET
    var path: String = "/v1/library/mylist/"
    var parameters: [String: String]?
    
    init(bookId: String) {
        self.path += bookId
    }
}
