//
//  UIViewController+Extension.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import UIKit

extension UIViewController {
    func setNavigationCustom(title: String, tintColor: UIColor = .black) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.tintColor = tintColor
    }
    
    func setNavigationImageButton(imageName: [String], action: [Selector]) {
        var arr: [UIBarButtonItem] = []
        for i in 0..<imageName.count {
            let btn = UIBarButtonItem(image: UIImage(named: imageName[i]), style: .plain, target: self, action: action[i])
            btn.width = 27
            arr.insert(btn, at: arr.startIndex)
        }
        
        self.navigationItem.rightBarButtonItems = arr
    }
    
    func setNavigationLabelButton(title: String, action: Selector) {
        let btn = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        btn.tintColor = .textOrange
        
        self.navigationItem.rightBarButtonItem = btn
    }
}
