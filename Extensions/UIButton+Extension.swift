//
//  UIButton+Extension.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import UIKit

// MARK: - UIButton extension
extension UIButton {
    func setTitle(_ title: String, size: CGFloat, weight: UIFont.Weight, color: UIColor, when: UIControl.State = .normal) {
        if #available(iOS 15.0, *) {
            var attributedTitle = AttributedString(title)
            attributedTitle.font = .suit(size: size, weight: weight)
            attributedTitle.foregroundColor = color
            var configuration = self.configuration ?? .plain()
            configuration.attributedTitle = attributedTitle
            self.configuration = configuration
        } else {
            self.setTitle(title, for: when)
            self.titleLabel?.font = .systemFont(ofSize: size, weight: weight)
            self.setTitleColor(color, for: when)
        }
    }
}
