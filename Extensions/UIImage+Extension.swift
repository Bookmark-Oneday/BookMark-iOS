//
//  UIImage+Extension.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/03/23.
//

import UIKit
import RxSwift

extension UIImage {
    static func loadFromUrl(_ url: String) -> Observable<UIImage?> {
        return Observable<UIImage?>
            .create { emitter in
                guard let url = URL(string: url) else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return Disposables.create()
                }
                
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        emitter.onNext(nil)
                        emitter.onCompleted()
                        return
                    }
                    
                    let image = UIImage(data: data)
                    emitter.onNext(image)
                    emitter.onCompleted()
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
    }
}
