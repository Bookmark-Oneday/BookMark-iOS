//
//  CustomAlertViewController.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/02/06.
//

import UIKit
import SnapKit

// MARK: - Custom Alert 뷰 컨트롤러
class CustomAlertViewController: UIViewController {
    let alertView = CustomAlertView()
    private var titleStr: String = ""
    private var subTitleStr: String = ""
    private var btnTitleStr: String = ""
    var confirmCompletion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.initViews(self.view)
        alertView.btn_ok.addTarget(self, action: #selector(didTapOkButton), for: .touchUpInside)
        alertView.btn_cancel.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alertView.label_title.setTxtAttribute(titleStr, size: 18, weight: .w600, txtColor: .black)
        alertView.label_subtitle.setTxtAttribute(subTitleStr, size: 15, weight: .w500, txtColor: .textGray)
        alertView.btn_ok.setTitle(btnTitleStr, size: 16, weight: .w600, color: .white)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - setting
    func setAlertLabel(title: String, subtitle: String, okButtonTitle: String) {
        self.titleStr = title
        self.subTitleStr = subtitle
        self.btnTitleStr = okButtonTitle
    }
    
    // MARK: - Actions
    @objc private func didTapOkButton() {
        self.closeModal(self.confirmCompletion)
    }
    
    @objc private func didTapCancelButton() {
        self.closeModal()
    }
    
    private func closeModal(_ completed: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true)
            completed?()
        }
    }
}

// MARK: - Custom Alert 뷰
class CustomAlertView {
    let layout_main = UIView()
    let label_title = UILabel()
    let label_subtitle = UILabel()
    let btn_ok = UIButton()
    let btn_cancel = UIButton()
    
    func initViews(_ superView: UIView) {
        superView.addSubview(layout_main)

        layout_main.snp.makeConstraints() { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(165)
        }
        layout_main.backgroundColor = .white
        layout_main.layer.shadowColor = UIColor.black.cgColor
        layout_main.layer.shadowOffset = CGSize(width: 5, height: 5)
        layout_main.layer.shadowOpacity = 0.3
        layout_main.layer.shadowRadius = 20
        layout_main.layer.cornerRadius = 20
        
        layout_main.addSubviews(label_title, label_subtitle, btn_ok, btn_cancel)
        
        label_title.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(31)
            make.centerX.equalToSuperview()
        }
        label_title.setTxtAttribute("", size: 18, weight: .w600, txtColor: .black)
        
        label_subtitle.snp.makeConstraints() { make in
            make.top.equalTo(label_title.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
        label_subtitle.setTxtAttribute("", size: 15, weight: .w500, txtColor: .textGray)
        
        btn_cancel.snp.makeConstraints() { make in
            make.top.equalTo(label_subtitle.snp.bottom).offset(23)
            make.leading.equalToSuperview().offset(33)
            make.width.equalTo(130)
            make.height.equalTo(38)
        }
        btn_cancel.backgroundColor = .systemGray4
        btn_cancel.layer.cornerRadius = 18
        btn_cancel.setTitle("취소", size: 16, weight: .w600, color: .white)
        
        btn_ok.snp.makeConstraints() { make in
            make.top.equalTo(btn_cancel)
            make.trailing.equalToSuperview().offset(-33)
            make.width.equalTo(130)
            make.height.equalTo(38)
        }
        btn_ok.backgroundColor = .lightOrange
        btn_ok.layer.cornerRadius = 18
        btn_ok.setTitle("", size: 16, weight: .w600, color: .white)
    }
}
