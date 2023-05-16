//
//  Network.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/01/15.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Foundation

public enum RequestType: String {
    case GET, POST, DELETE
}

protocol ApiRequest{
    var method : RequestType { get }
    var path : String { get }
    var parameters : Dictionary<String, Any>? {get}
    var headerParam: [String: String]? {get}
}

extension ApiRequest {
    func request(with baseURL : URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("url errror")
        }
        components.queryItems = parameters?.map {
            return URLQueryItem(name: String($0.key), value: String(describing: $0.value))
        }
        guard let url = components.url else {
            fatalError("url error")
        }
        
        let request : URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headerParam
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }()
        
        return request
    }
}

class Network {
    public static let sessionManager: Session = {

        let serverTrustPolices = ServerTrustManager(evaluators: ["api.bmonlner.me": DisabledTrustEvaluator()])

        let configuration = URLSessionConfiguration.af.default

        configuration.timeoutIntervalForRequest = 30

        return Session(configuration: configuration, serverTrustManager: serverTrustPolices)
    }()
    
    func sendRequest(apiRequest: ApiRequest) -> Observable<Int> {
        return Observable<Int>.create { observer in
            guard let requestURL = URL(string: "https://api.bmonlner.me") else {
                return Disposables.create()
            }
            let request = apiRequest.request(with: requestURL)
            
            let dataRequest = Network.sessionManager.request(request).responseData {
                response in
                switch response.result {
                case .success(_) :
                    guard let code = response.response?.statusCode else {
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(code)
                case .failure(let error):
                    print("failed")
                    observer.onError(error)
                }
                observer.onCompleted()
            }

            return Disposables.create() {
                dataRequest.cancel()
            }
        }
    }
    
    func sendRequest<T: Decodable>(apiRequest: ApiRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            guard let requestURL = URL(string: "https://api.bmonlner.me") else {
                return Disposables.create()
                
            }
            let request = apiRequest.request(with: requestURL)
            
            let dataRequest = Network.sessionManager.request(request).responseData {
                response in
                switch response.result {
                case .success(let data) :
                    do {
                        let model: T = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(model)
                    } catch let error {
                        print("failed")
                        observer.onError(error)
                    }
                case .failure(let error):
                    print("failed")
                    observer.onError(error)
                }
                observer.onCompleted()
            }

            return Disposables.create() {
                dataRequest.cancel()
            }
        }
    }
    
    func sendKakaoRequest<T: Decodable>(apiRequest: ApiRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            guard let requestURL = URL(string: "https://dapi.kakao.com") else {
                return Disposables.create()
                
            }
            
            let request = apiRequest.request(with: requestURL)
            
            let dataRequest = AF.request(request).responseData {
                response in
                switch response.result {
                case .success(let data) :
                    do {
                        let model: T = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(model)
                    } catch let error {
                        print("decode failed")
                        observer.onError(error)
                    }
                case .failure(let error):
                    print("failed")
                    observer.onError(error)
                }
                observer.onCompleted()
            }

            return Disposables.create() {
                dataRequest.cancel()
            }
        }
    }
}
