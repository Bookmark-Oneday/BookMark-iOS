//
//  UINavigationController+Extension.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import UIKit

// MARK: - Tab bar hidden 용 extension
extension UINavigationController {
    func pushViewControllerTabHidden(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        self.pushViewController(viewController, animated: animated)
    }
}
