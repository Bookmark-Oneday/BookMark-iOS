//
//  DeleteBookModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/05/03.
//

import Foundation

class DeleteBookModel: ApiRequest {
    var headerParam: [String : String]?
    var method: RequestType = .DELETE
    var path: String = "/v1/library/mylist/"
    var parameters: Dictionary<String, Any>?
    var body: Dictionary<String, Any>?
    
    init(bookId: String) {
        self.path += bookId
    }
}
