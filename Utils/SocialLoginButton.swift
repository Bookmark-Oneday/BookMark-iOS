//
//  SocialLoginButton.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/05/16.
//

import UIKit

class SocialLoginButton: UIView {
    let title = UILabel()
    let logo = UIImageView()
    let line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout("")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupLayout("")
    }
    
    convenience init(social: String, logo: UIImage?) {
        self.init(frame: .zero)
        self.setupLayout(social, logo)
    }

    private func setupLayout(_ social: String, _ img: UIImage? = nil) {
        self.addSubviews(title, line, logo)
        self.backgroundColor = .white
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.layer.cornerRadius = 30
        
        logo.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(62)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        logo.image = img
        
        line.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(1)
            make.leading.equalToSuperview().offset(115)
        }
        line.backgroundColor = .semiLightGray
        
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(line.snp.trailing).offset(29)
        }
        title.setTxtAttribute("\(social)계정으로 시작", size: 15, weight: .w500, txtColor: .black)
    }
}
