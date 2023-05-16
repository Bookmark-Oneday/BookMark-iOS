//
//  SignUpUserInfo.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/05/16.
//

import Foundation
import UIKit

final class SignUpUserInfo {
    static let shared = SignUpUserInfo()
    var userNickName: String?
    var userImg: UIImage?
    var userMessage: String?
    var userGoal: Int?
}
