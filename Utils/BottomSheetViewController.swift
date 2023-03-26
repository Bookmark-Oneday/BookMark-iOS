//
//  BottomSheetViewController.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/24.
//

import UIKit

final class BottomSheetViewController: UIViewController {
    private let contentView: UIView = UIView()
    private let topLine: UIView = UIView()
    private let deleteButton: UIButton = UIButton()
    var deleteCompletion: (() -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.backgroundColor = .black.withAlphaComponent(0.6)
        }
    }
    
    private func close(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true) {
                completion?()
            }
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = .clear
        self.contentView.isUserInteractionEnabled = true
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        self.view.addSubview(self.contentView)
        self.contentView.addSubviews(self.topLine, self.deleteButton)
        
        self.contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(98)
        }
        
        self.topLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(40)
            make.height.equalTo(2)
            make.centerX.equalToSuperview()
        }
        self.topLine.backgroundColor = .textLightGray
        self.topLine.layer.cornerRadius = 5
        
        self.deleteButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(23)
            make.top.equalTo(self.topLine.snp.bottom).offset(20)
        }
        self.deleteButton.contentHorizontalAlignment = .left
        self.deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        self.deleteButton.setTitle("책 목록에서 삭제", size: 16, weight: .w500, color: UIColor(Hex: 0xFF0F0F))
    }
    
    @objc func didTapDeleteButton(_ sender: UIButton) {
        self.close(self.deleteCompletion)
    }
}
