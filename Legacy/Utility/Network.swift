//
//  Network.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/01/15.
//

import Foundation
import Alamofire

// MARK: - 네트워킹 용 클래스 나중에 싱글톤으로 만들기
class Network {
    // base Url
    let baseUrl = "https://port-0-bookmark-oneliner-luj2cldx5nm16.sel3.cloudtype.app"
    
    // 책 등록 POST
    func postRegisterBooks(title: String, img_url: String, author: String, pubilsher: String, isbn: String, totalPage: Int, completion: @escaping (() -> Void)) {
        let params: Parameters = ["title": title, "img_url": img_url, "author": author, "publisher": pubilsher, "isbn": isbn, "total_page": totalPage]
        
        let URL = baseUrl + "/register/book/\(UserInfo.shared.userID)"
        let datarequest = AF.request(URL, method: .post, parameters: params, encoding: JSONEncoding.default).validate()
        
        datarequest.responseData(completionHandler: { response in
            switch response.result {
            case .success:
                completion()
            case .failure(let e):
                print("failed")
                print(e)
            }
        })
    }
    
    // 책 세부내용 조회 GET
    func getBookDetail(bookId: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = baseUrl + "/shelf/book/" + bookId
        let datarequest = AF.request(URL, method: .get, encoding: JSONEncoding.default)
        
        datarequest.responseData(completionHandler: { res in
            switch res.result {
            case .success:
                guard let value = res.value else {return}
                guard let rescode = res.response?.statusCode else {return}
                
                let networkResult = self.judgeStatus(object: 2, by: rescode, value)
                completion(networkResult)
                
            case .failure(let e):
                print(e)
                completion(.pathErr)
            }
        
        })
    }
    
    // 서재 조회 GET
    func getShelf(completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = baseUrl + "/shelf/\(UserInfo.shared.userID)"
        let datarequest = AF.request(URL, method: .get, encoding: JSONEncoding.default)
        
        datarequest.responseData(completionHandler: {res in
            switch res.result {
            case .success:
                guard let value = res.value else { return }
                guard let rescode = res.response?.statusCode else {return}

                let networkResult = self.judgeStatus(object: 1, by: rescode, value)

                completion(networkResult)
                
            case .failure(let e):
                print(e)
                completion(.pathErr)
            }
        })
    }
    
    // 책 검색(바코드) GET
    func getBookSearch(isbn: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = baseUrl + "/search/book/\(UserInfo.shared.userID)/?query=" + isbn
   
        let dataRequest = AF.request( URL,
                                      method: .get,
                                      encoding: JSONEncoding.default)

        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }

                guard let value = dataResponse.value else { return }

                let networkResult = self.judgeStatus(object: 0, by: statusCode, value)
                completion(networkResult)

            case .failure:
                completion(.pathErr)
            }
        }
    }

    // timer 시작 post
    func postTimerStart(completion: @escaping (() -> Void)) {
        let URL = baseUrl + "/timer/start/1/2"
        let dataRequest = AF.request( URL,
                                      method: .post,
                                      encoding: JSONEncoding.default ).validate()
        
        dataRequest.responseData(completionHandler: { dataResponse in
            switch dataResponse.result {
            case .success(let res):
                print("SUCCESS")
                print("응답 데이터 :: ", String(data: res, encoding: .utf8) ?? "")
            case .failure(let e):
                print("ERROR")
                print(e)
            }
            
//MARK: todo2 - completion에 NetworkResult<AnyObject>으로 추가하기 나중에
            completion()
        })
    }
    
    // timer 종료 post
    func postTimerStop(completion: @escaping (() -> Void)) {
        let params: Parameters = [
            "total_reading_time": 1000,
            "current_reading_time": 100
        ]
        let URL = baseUrl + "/timer/finish/1/1"
        let dataRequest = AF.request( URL,
                                      method: .post,
                                      parameters: params,
                                      encoding: JSONEncoding.default ).validate()
        
        dataRequest.responseData(completionHandler: { dataResponse in
            switch dataResponse.result {
            case .success(_):
                completion()
                
            case .failure(let e):
                print("ERROR: \(e)")
            }
        })
    }
    
    // Apple Login identity token post
    func postAppleLoginIdentityToken(identityToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let params: Parameters = ["identityToken": identityToken]
        
        let URL = baseUrl + "/apple/auth"
        let datarequest = AF.request(URL, method: .post, parameters: params, encoding: JSONEncoding.default).validate()
        
        datarequest.responseData(completionHandler: { response in
            switch response.result {
            case .success:
                guard let value = response.value else {return}
                guard let rescode = response.response?.statusCode else {return}
                
                let networkResult = self.judgeStatus(object: 3, by: rescode, value)
                completion(networkResult)
                
            case .failure(let e):
                print(e)
                completion(.pathErr)
            }
        
        })
    }
}

// MARK: - NetworkResult 용 extension
extension Network {
    private func judgeStatus(object: Int = 0, by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200:
            // 책 검색 용
            if (object == 0) {
                return isValidData_BookSearch(data: data)
            }
            // 서재 조회 용
            else if (object == 1) {
                return isValidData_Shelf(data: data)
            }
            // 책 세부 내용 용
            else if (object == 2) {
                return isValidData_BookDetail(data: data)
            }
            else {
                return .success(data)
            }
        case 400: return .pathErr // 요청이 잘못됨
        case 500: return .serverErr // 서버 에러
        default: return .networkFail // 네트워크 에러
        }
    }
    
    private func isValidData_BookSearch(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(BookSearch.self, from: data) else {
            return .decodeFail }
    
        return .success(decodedData)
    }
    
    private func isValidData_Shelf(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()

        guard let decodedData = try? decoder.decode(Shelf.self, from: data) else {
            return .decodeFail }
        
        return .success(decodedData)
    }
    
    private func isValidData_BookDetail(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(BookDetail.self, from: data) else {
            return .decodeFail
        }

        return .success(decodedData)
    }
}
