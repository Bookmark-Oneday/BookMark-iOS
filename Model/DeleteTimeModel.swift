//
//  DeleteTimeModel.swift
//  BookMark
//
//  Created by BoMin on 2023/05/24.
//

import Foundation

class DeleteTimeModel: ApiRequest {
    var headerParam: [String : String]?
    var method: RequestType = .DELETE
    var path: String = "/v1/library/timer/"
    var parameters: Dictionary<String, Any>?
    var body: Dictionary<String, Any>?
    
    init(bookId: String) {
        self.path += bookId
        self.headerParam = ["user_id": "74d18bfc-14c5-46d2-a1a8-1eb627918859"]
        self.body = ["book_id": bookId]
    }
}
