//
//  BarcodeRecognizeViewModel.swift
//  BookMark
//
//  Created by BoMin on 2023/04/06.
//

import RxSwift
import AVFoundation

class BarcodeRecognizeViewModel {
    private let barcodeScanner: BarcodeScanner
    
    let barcodeDetected: Observable<String>

    init(barcodeScanner: BarcodeScanner) {
        self.barcodeScanner = barcodeScanner
        self.barcodeDetected = barcodeScanner.barcodeDetected.asObservable()
    }
    
}
