//
//  MyLibModel.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/04/08.
//

import Foundation
import RxCocoa
import RxSwift

enum SortType: String {
    case latest = "latest"
    case past = "past"
    case favorite = "favorite"
    case reading = "reading"
}

class MyLibModel: ApiRequest {
    var headerParam: [String : String]?
    var method: RequestType = .GET
    var path: String = "/v1/library/mylist"
    var parameters: [String: String]
    
    init(sortType: SortType = .latest) {
        self.parameters = ["sortType": sortType.rawValue, "perPage": "3", "continuousToken": "0"]
        self.headerParam = ["user_id": "74d18bfc-14c5-46d2-a1a8-1eb627918859"]
    }
}
