//
//  BarcodeRecognizeView.swift
//  BookMark
//
//  Created by BoMin on 2023/04/06.
//

import UIKit
import SnapKit
import AVFoundation

class BarcodeRecognizeView: UIView {
    
    private let previewLayer = AVCaptureVideoPreviewLayer()
    private let maskLayer = CAShapeLayer()
    private let barcodeAreaLayer = CALayer()
    private let redLineLayer = CALayer()
    private let label_message = UILabel()
    
    private let widthRatio: CGFloat = 390.0 / 286.0
    private let heightRatio: CGFloat = 797.0 / 137.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)

        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.addSublayer(maskLayer)

        barcodeAreaLayer.borderWidth = 2
        barcodeAreaLayer.borderColor = UIColor.red.cgColor
        layer.addSublayer(barcodeAreaLayer)

        redLineLayer.backgroundColor = UIColor.red.cgColor
        layer.addSublayer(redLineLayer)
        
        setupMessageLabel()
    }
    
    func setupMessageLabel() {
        label_message.text = "책의 바코드를 인식해 주세요."
        label_message.textColor = .white
        label_message.font = UIFont.systemFont(ofSize: 17)
        label_message.textAlignment = .center
        addSubview(label_message)
    }
    
    func updatePreviewLayer(session: AVCaptureSession) {
        previewLayer.session = session
        previewLayer.frame = bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let safeArea = self.safeAreaLayoutGuide.layoutFrame
        let barcodeFrameWidth = safeArea.width / widthRatio
        let barcodeFrameHeight = safeArea.height / heightRatio
        let barcodeFrame = CGRect(x: (safeArea.width - barcodeFrameWidth) / 2,
                                  y: (safeArea.height - barcodeFrameHeight) / 2,
                                  width: barcodeFrameWidth,
                                  height: barcodeFrameHeight)
        

        updateMask(with: barcodeFrame)
        updateRedLine(in: barcodeFrame)
        
        label_message.snp.makeConstraints { make in
            make.left.equalTo(safeAreaLayoutGuide.snp.left)
            make.right.equalTo(safeAreaLayoutGuide.snp.right)
            make.top.equalTo(self.snp.top).offset(barcodeFrame.maxY + 21)
            make.height.equalTo(20)
        }
        
    }
    
    private func updateMask(with rect: CGRect) {
        let path = UIBezierPath(rect: bounds)
        path.append(UIBezierPath(rect: rect).reversing())
        maskLayer.path = path.cgPath
    }

    private func updateRedLine(in rect: CGRect) {
        let lineHeight: CGFloat = 2
        redLineLayer.frame = CGRect(x: rect.minX, y: rect.midY - lineHeight / 2, width: rect.width, height: lineHeight)
    }
    
    func showDetectedAnimation() {
        
    }
}
