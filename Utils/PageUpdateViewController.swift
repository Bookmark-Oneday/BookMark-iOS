//
//  PageUpdateViewController.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/05/16.
//

import UIKit
import SnapKit

class PageUpdateViewController: UIViewController {
    let alertView = PageUpdateView()
    var confirmCompletion: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.initViews(self.view)
        alertView.btn_ok.addTarget(self, action: #selector(didTapOkButton), for: .touchUpInside)
        alertView.btn_cancel.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    @objc private func didTapOkButton() {
        self.closeModal(self.confirmCompletion)
    }
    
    @objc private func didTapCancelButton() {
        self.closeModal()
    }
    
    private func closeModal(_ completed: ((String, String) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true)
            completed?(self.alertView.tf_page.text ?? "0", self.alertView.tf_total.text ?? "0")
        }
    }
}

// MARK: - Custom Alert 뷰
class PageUpdateView {
    let layout_main = UIView()
    let left_img = UIImageView()
    let label_title = UILabel()
    let label_subtitle = UILabel()
    let tf_page = UITextField()
    let label_slash = UIImageView()
    let tf_total = UITextField()
    let btn_ok = UIButton()
    let btn_cancel = UIButton()
    
    func initViews(_ superView: UIView) {
        superView.addSubview(layout_main)

        layout_main.snp.makeConstraints() { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(220)
        }
        layout_main.backgroundColor = .white
        layout_main.layer.shadowColor = UIColor.black.cgColor
        layout_main.layer.shadowOffset = CGSize(width: 5, height: 5)
        layout_main.layer.shadowOpacity = 0.3
        layout_main.layer.shadowRadius = 20
        layout_main.layer.cornerRadius = 20
        
        layout_main.addSubviews(left_img, label_title, label_subtitle, tf_page, label_slash, tf_total, btn_ok, btn_cancel)
        
        left_img.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.top.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(27)
        }
        left_img.image = UIImage(named: "leftImg")
        
        label_title.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(31)
            make.centerX.equalToSuperview()
        }
        label_title.setTxtAttribute("책갈피", size: 20, weight: .w600, txtColor: .black)
        
        label_subtitle.snp.makeConstraints() { make in
            make.top.equalTo(label_title.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
        label_subtitle.setTxtAttribute("몇 페이지까지 읽으셨나요?", size: 16, weight: .w500, txtColor: .textGray)
        
        tf_page.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.top.equalTo(label_subtitle.snp.bottom).offset(22)
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
        tf_page.textAlignment = .center
        tf_page.layer.borderColor = UIColor(Hex: 0xDFDFDF).cgColor
        tf_page.layer.borderWidth = 1
        tf_page.layer.cornerRadius = 7
        tf_page.textColor = .textOrange
        tf_page.font = .suit(size: 17, weight: .w600)
        
        label_slash.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label_subtitle.snp.bottom).offset(26)
            make.width.equalTo(27)
            make.height.equalTo(13)
        }
        label_slash.image = UIImage(named: "slash")
        
        tf_total.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(29)
            make.top.equalTo(label_subtitle.snp.bottom).offset(22)
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
        tf_total.font = .suit(size: 17, weight: .w600)
        tf_total.textAlignment = .center
        tf_total.layer.borderColor = UIColor(Hex: 0xDFDFDF).cgColor
        tf_total.layer.borderWidth = 1
        tf_total.layer.cornerRadius = 7
        
        btn_cancel.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(15)
            make.height.equalTo(14)
        }
        btn_cancel.setImage(UIImage(named: "cancel"), for: .normal)
        
        btn_ok.snp.makeConstraints() { make in
            make.top.equalTo(tf_page.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(40)
        }
        btn_ok.backgroundColor = .lightOrange
        btn_ok.layer.cornerRadius = 18
        btn_ok.setTitle("입력", size: 16, weight: .w600, color: .white)
    }
}
