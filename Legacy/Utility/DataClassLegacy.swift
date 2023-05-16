//
//  DataClass.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/01/17.
//

import Foundation

// MARK: - 네트워킹 result 열거형
enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
    case decodeFail
}

