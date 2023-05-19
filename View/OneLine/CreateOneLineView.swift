//
//  CreateOneLineView.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/05/19.
//

import UIKit
import SnapKit

// MARK: - 오늘 한 줄 생성 view
class CreateOneLineView {
    let layout_main = UIView()
    let img_backgound = UIImageView()
    
    let layout_content = UIView()
    let label_placeholder = UILabel()
    let tv_oneline = UITextView()
    let label_onelineInfo = UILabel()
    
    let btn_setImg = UIButton()
    let label_setImg = UILabel()
    
    let layout_settings = UIView()
    let btn_font = UIButton()
    let layout_vertical = UIView()
    let btn_color = UIButton()
    
    func initViews(_ superView: UIView) {
        superView.addSubview(layout_main)
        layout_main.snp.makeConstraints() { make in
            make.edges.equalTo(superView)
        }
        layout_main.backgroundColor = UIColor(Hex: 0xE3E3E3)
        layout_main.addSubviews(img_backgound, layout_content, label_placeholder, btn_setImg, label_setImg)
        
        img_backgound.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        img_backgound.backgroundColor = .clear
        img_backgound.contentMode = .scaleAspectFill
        img_backgound.layer.opacity = 0.8
        
        layout_content.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(layout_main.snp.centerY).offset(40)
            make.horizontalEdges.equalToSuperview().inset(60)
            make.height.equalTo(80)
        }
        layout_content.layer.borderColor = UIColor.white.cgColor
        layout_content.layer.borderWidth = 1
        layout_content.addSubviews(tv_oneline, label_onelineInfo)
        
        tv_oneline.snp.makeConstraints() { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(38)
        }
        tv_oneline.isScrollEnabled = false
        tv_oneline.backgroundColor = .clear
        tv_oneline.textContainerInset = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        tv_oneline.font = .suit(size: 17, weight: .w500)
        tv_oneline.textColor = UIColor(Hex: 0x111111)
        tv_oneline.textAlignment = .center
        
        label_placeholder.snp.makeConstraints() { make in
            make.center.equalTo(tv_oneline)
        }
        label_placeholder.setTxtAttribute("텍스트를 입력하세요", size: 17, weight: .w500, txtColor: UIColor(Hex: 0x111111))
        
        label_onelineInfo.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        label_onelineInfo.textAlignment = .center
        label_onelineInfo.setTxtAttribute("책 제목, 저자", size: 13, weight: .w500, txtColor: UIColor(Hex: 0x111111))
        
        btn_setImg.snp.makeConstraints() { make in
            make.bottom.equalToSuperview().inset(49)
            make.leading.equalToSuperview().offset(26)
            make.size.equalTo(29)
        }
        btn_setImg.tintColor = .textBoldGray
        btn_setImg.setImage(UIImage(named: "photoIcon"), for: .normal)
        
        label_setImg.snp.makeConstraints() { make in
            make.top.equalTo(btn_setImg.snp.bottom).offset(3)
            make.centerX.equalTo(btn_setImg)
        }
        label_setImg.setTxtAttribute("배경 설정", size: 10, weight: .w500, txtColor: .textBoldGray)
    }
    
    func didStartEditing(_ superView: UIView) {
        layout_settings.backgroundColor = .white
        layout_settings.addSubviews(btn_font, layout_vertical, btn_color)
        btn_font.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(23)
            make.centerY.equalToSuperview()
            make.width.equalTo(27)
        }
        btn_font.setImage(UIImage(named: "fontIcon"), for: .normal)
        
        layout_vertical.snp.makeConstraints() { make in
            make.height.equalTo(14)
            make.width.equalTo(2)
            make.leading.equalTo(btn_font.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
        layout_vertical.backgroundColor = .semiLightGray
        
        btn_color.snp.makeConstraints() { make in
            make.leading.equalTo(layout_vertical.snp.trailing).offset(15)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        }
        btn_color.layer.cornerRadius = 10
        btn_color.backgroundColor = .textBoldGray
    }
}
