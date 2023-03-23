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
    let label_title = UILabel()
    let line = UIView()
    let img_networkFail = UIImageView()
    let label_explain = UILabel()
    let label_description = UILabel()
    let btn_retry = UIButton()
    
    func initViews(superView: UIView) {
        superView.addSubviews(label_title, line, img_networkFail, label_explain, label_description, btn_retry)
        
        label_title.snp.makeConstraints() { make in
            make.top.equalTo(superView.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(23)
            make.width.equalToSuperview()
            make.height.equalTo(44)
        }
        label_title.setTxtAttribute("책갈피 : 나의 서재", size: 18, weight: .w500, txtColor: .black)
        
        line.snp.makeConstraints() { make in
            make.top.equalTo(label_title.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        line.backgroundColor = .lightGray
        
        label_explain.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label_explain.setTxtAttribute("인터넷 연결이 불안정합니다.", size: 20, weight: .w600, txtColor: .black)
        
        img_networkFail.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.bottom.equalTo(label_explain.snp.top).offset(-32)
            make.centerX.equalToSuperview()
        }
        img_networkFail.image = UIImage(named: "networkFailImg")
        
        label_description.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label_explain.snp.bottom).offset(10)
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
