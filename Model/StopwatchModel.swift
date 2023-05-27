//
//  StopwatchModel.swift
//  BookMark
//
//  Created by BoMin on 2023/05/22.
//

import Foundation

class StopwatchModel: ApiRequest {
    var headerParam: [String : String]?
    var method: RequestType = .GET
    var path: String = "/v1/library/timer/"
    var parameters: Dictionary<String, Any>?
    var body: Dictionary<String, Any>?
    
    init(bookId: String) {
        self.path += bookId
    }
}
