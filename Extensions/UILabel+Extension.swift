//
//  UILabel+Extension.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import UIKit

// MARK: - UILabel extension
extension UILabel {
    func setTxtAttribute(_ title: String, size: CGFloat, weight: UIFont.Weight, txtColor: UIColor) {
        self.text = title
        self.font = .suit(size: size, weight: weight)
        self.textColor = txtColor
    }
}
