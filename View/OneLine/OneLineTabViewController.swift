//
//  OneLineTabViewController.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/01/08.
//

import UIKit
import SnapKit

// MARK: - 오늘 한줄 탭
class OneLineTabViewController: UIViewController {
    let oneLineView = OneLineTabView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        oneLineView.initViews(self.view)
        oneLineView.btn_create.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        oneLineView.btn_more.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.unselectedItemTintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.unselectedItemTintColor = .textBoldGray
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func didTapCreateButton(_ sender: UIButton) {
        self.navigationController?.pushViewControllerTabHidden(CreateOneLineViewController(), animated: true)
    }
    
    @objc func didTapMoreButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "도움말", preferredStyle: .actionSheet)
        let report = UIAlertAction(title: "신고하기", style: .default, handler: { _ in
            self.view.makeToast("신고되었습니다", duration: 1.5, point: CGPoint(x: ((self.tabBarController?.tabBar.frame.minX ?? 0) + (self.tabBarController?.tabBar.frame.maxX ?? 0)) / 2, y: (self.tabBarController?.tabBar.frame.minY ?? 0) - ((self.tabBarController?.tabBar.frame.height ?? 0)) - 30), title: nil, image: nil, completion: nil)
        })
        let remove = UIAlertAction(title: "삭제하기", style: .default, handler: { _ in
            // MARK: - todo 삭제 로직 구현
            
            self.view.makeToast("삭제되었습니다", duration: 1.5, point: CGPoint(x: ((self.tabBarController?.tabBar.frame.minX ?? 0) + (self.tabBarController?.tabBar.frame.maxX ?? 0)) / 2, y: (self.tabBarController?.tabBar.frame.minY ?? 0) - ((self.tabBarController?.tabBar.frame.height ?? 0)) - 30), title: nil, image: nil, completion: nil)
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(report)
        alert.addAction(remove)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

// MARK: - 오늘 한 줄 tab view
class OneLineTabView {
    let layout_main = UIView()
    let label_title = UILabel()
    let btn_create = UIButton()
    let img_background = UIImageView()
    let layout_black = UIView()
    let label_onelineContent = UILabel()
    let label_onelineInfo = UILabel()
    let layout_line = UIView()
    let img_profile = UIImageView()
    let label_name = UILabel()
    let label_time = UILabel()
    let btn_more = UIButton()

    func initViews(_ superView: UIView) {
        superView.addSubview(layout_main)
        layout_main.snp.makeConstraints() { make in
            make.edges.equalTo(superView)
        }
        layout_main.isUserInteractionEnabled = true
        layout_main.addSubviews(label_title, btn_create, img_background, layout_black, label_onelineContent, label_onelineInfo, layout_line, img_profile, label_name, label_time, btn_more)
        
        label_title.snp.makeConstraints() { make in
            make.top.equalTo(superView.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(23)
        }
        label_title.sizeToFit()
        label_title.setTxtAttribute("책갈피 : 오늘 한줄", size: 18, weight: .w500, txtColor: .white)
        label_title.layer.zPosition = 999
        
        btn_create.snp.makeConstraints() { make in
            make.centerY.equalTo(label_title)
            make.size.equalTo(16)
            make.trailing.equalToSuperview().inset(24)
        }
        btn_create.layer.zPosition = 999
        btn_create.setImage(UIImage(systemName: "plus"), for: .normal)
        btn_create.tintColor = .white
        
        img_background.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        img_background.image = UIImage(named: "backImg")
        img_background.contentMode = .scaleAspectFill

        layout_black.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        layout_black.isUserInteractionEnabled = false
        layout_black.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)

        img_profile.snp.makeConstraints() { make in
            make.top.equalTo(label_title.snp.bottom).offset(16)
            make.leading.equalTo(label_title)
            make.size.equalTo(30)
        }
        img_profile.clipsToBounds = true
        img_profile.layer.cornerRadius = 15
        img_profile.image = UIImage(named: "noProfileImg")

        label_name.snp.makeConstraints() { make in
            make.centerY.equalTo(img_profile)
            make.leading.equalTo(img_profile.snp.trailing).offset(7)
        }
        label_name.sizeToFit()
        label_name.layer.zPosition = 999
        label_name.setTxtAttribute("플레이스", size: 14, weight: .w500, txtColor: .white)

        label_time.snp.makeConstraints() { make in
            make.centerY.equalTo(label_name)
            make.leading.equalTo(label_name.snp.trailing).offset(7)
        }
        label_time.setTxtAttribute("2시간전", size: 11, weight: .w500, txtColor: .lightLightGray)
        label_time.layer.zPosition = 999
        
        btn_more.snp.makeConstraints() { make in
            make.centerY.equalTo(img_profile)
            make.size.equalTo(17)
            make.trailing.equalToSuperview().inset(23)
        }
        btn_more.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn_more.tintColor = .white
        
        layout_line.snp.makeConstraints() { make in
            make.top.equalTo(img_profile.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        layout_line.backgroundColor = .lightLightGray
        
        label_onelineContent.snp.makeConstraints() { make in
            make.horizontalEdges.equalToSuperview().inset(23)
            make.centerY.equalToSuperview()
        }
        label_onelineContent.numberOfLines = 0
        label_onelineContent.textAlignment = .center
        label_onelineContent.layer.zPosition = 999
        label_onelineContent.setTxtAttribute("사랑에는 늘 약간의 망상이 들어 있다.", size: 17, weight: .w500, txtColor: .white)
        
        label_onelineInfo.snp.makeConstraints { make in
            make.top.equalTo(label_onelineContent.snp.bottom).offset(22)
            make.horizontalEdges.equalToSuperview().inset(23)
        }
        label_onelineInfo.numberOfLines = 0
        label_onelineInfo.layer.zPosition = 999
        label_onelineInfo.textAlignment = .center
        label_onelineInfo.setTxtAttribute("차라투스트라는 이렇게 말했다, 프리드리히 니체", size: 13, weight: .w500, txtColor: .white)
    }
    
}
