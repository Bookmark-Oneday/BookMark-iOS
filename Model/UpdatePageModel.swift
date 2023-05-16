//
//  UpdatePageModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/05/16.
//

import Foundation
import Alamofire

class UpdatePageModel: ApiRequest {
    var headerParam: [String : String]?
    var method: RequestType = .POST
    var path: String = "/v1/library/lastpage/"
    var parameters: Dictionary<String, Any>?
    
    init(bookId: String, currentPage: String, total_page: String) {
        self.path += bookId
        self.headerParam = ["user_id": "74d18bfc-14c5-46d2-a1a8-1eb627918859"]
        self.parameters = ["book_id": bookId, "current_page": currentPage, "total_page": total_page]
    }
}
