//
//  UIImageView+Extension.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import UIKit

//MARK: - UIImageView extension: Image URL 로드용
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func setImageUrl(url: String) {
        let imgURL = URL(string: url)
        guard let url = imgURL else {return}
        self.load(url: url)
    }
}
