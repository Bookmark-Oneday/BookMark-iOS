//
//  BarcodeRecognizeViewController.swift
//  BookMark
//
//  Created by BoMin on 2023/04/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AVFoundation

class BarcodeRecognizeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let barcodeView = BarcodeRecognizeView()
    
    private var barcodeScanner: BarcodeScanner?
    private var viewModel: BarcodeRecognizeViewModel?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationCustom(title: "바코드 인식")
        
        view.addSubview(barcodeView)
        barcodeView.frame = view.bounds
        barcodeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        barcodeScanner = BarcodeScanner()
        if let barcodeScanner = barcodeScanner {
            viewModel = BarcodeRecognizeViewModel(barcodeScanner: barcodeScanner)
            barcodeView.updatePreviewLayer(session: barcodeScanner.captureSession)
            
            viewModel?.barcodeDetected
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] barcode in
                    print("Barcode detected: \(barcode)")
                    let vc = ConfirmBookViewController(isbn: barcode)
                    self?.navigationController?.pushViewController(vc, animated: true)
//                    self?.barcodeView.showDetectedAnimation()
                })
                .disposed(by: disposeBag)
        }
    }
}
