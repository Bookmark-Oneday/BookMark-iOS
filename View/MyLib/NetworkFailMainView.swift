//
//  NetworkFailMainView.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import UIKit
import SnapKit

// MARK: - MyLibTab 네트워크 연결 실패 view
class NetworkFailMainView {
    let img_networkFail = UIImageView()
    let label_title = UILabel()
    let label_description = UILabel()
    let btn_retry = UIButton()
    
    func initViews(superView: UIView) {
        superView.addSubviews(img_networkFail, label_title, label_description, btn_retry)
        
        label_title.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label_title.setTxtAttribute("인터넷 연결이 불안정합니다.", size: 20, weight: .w600, txtColor: .black)
        
        img_networkFail.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.bottom.equalTo(label_title.snp.top).offset(-32)
            make.centerX.equalToSuperview()
        }
        img_networkFail.image = UIImage(named: "networkFailImg")
        
        label_description.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label_title.snp.bottom).offset(10)
        }
        label_description.numberOfLines = 0
        label_description.textAlignment = .center
        label_description.setTxtAttribute("인터넷 연결이 불안정하여\n데이터를 불러올 수 없습니다.", size: 16, weight: .w500, txtColor: .textGray)
        
        btn_retry.snp.makeConstraints { make in
            make.top.equalTo(label_description.snp.bottom).offset(32)
            make.height.equalTo(38)
            make.width.equalTo(148)
            make.centerX.equalToSuperview()
        }
        btn_retry.setTitle("재시도", size: 16, weight: .w600, color: .white)
        btn_retry.backgroundColor = .lightOrange
        btn_retry.layer.cornerRadius = 20
        btn_retry.clipsToBounds = true
    }
    
}
