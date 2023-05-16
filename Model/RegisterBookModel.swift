//
//  RegisterBookModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/05/03.
//

import Foundation
import Alamofire

class RegisterBookModel: ApiRequest {
    var headerParam: [String : String]?
    var method: RequestType = .POST
    var path: String = "/v1/library/mylist/book"
    var parameters: Dictionary<String, Any>?
    
    init(title: String, authors: String, publisher: String, translators: String, thumbnail_url: String, isbn: String, total_page: String) {
        self.headerParam = ["user_id": "74d18bfc-14c5-46d2-a1a8-1eb627918859"]
        self.parameters = ["title": title, "content": "", "authors": authors, "publisher": publisher, "translators": translators, "thumbnail_url": thumbnail_url, "isbn": isbn, "total_page": total_page]
    }
}
