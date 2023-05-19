//
//  CreateOneLineViewController.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/02/09.
//

import UIKit
import SnapKit

// MARK: - 오늘 한 줄 생성 view controller
class CreateOneLineViewController: UIViewController {
    let createOneLineview = CreateOneLineView()
    let imgPicker = UIImagePickerController()
    
    var userImageData: UIImage? = UIImage(named: "backImg")
    var userTextData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setNavCustom()
        setImgPicker()
        createOneLineview.tv_oneline.delegate = self
        
        createOneLineview.initViews(self.view)
        createOneLineview.btn_setImg.addTarget(self, action: #selector(didTapSetImgButton), for: .touchUpInside)
    }
    
    private func setNavCustom() {
        self.setNavigationCustom(title: "한줄 작성")
        self.setNavigationLabelButton(title: "게시", action: #selector(didTapPostButton))
    }
    
    @objc func didTapPostButton(_ sender: UIBarButtonItem) {
//        self.createOneLineview.img_backgound.removeFromSuperview()
//        self.userTextData = self.createOneLineview.txt_mainV.text
//        if let rootVC = navigationController?.viewControllers.first as? OneLineTabViewController {
//            rootVC.txtUserData = self.userTextData
//            rootVC.imgUserData = self.userImageData
//        }
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func didTapSetImgButton(_ sender: UIButton) {
        self.present(imgPicker, animated: true)
    }
}

// MARK: - Image Picker extension
extension CreateOneLineViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func setImgPicker() {
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        imgPicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        self.createOneLineview.img_backgound.image = newImage
        self.userImageData = newImage
        imgPicker.dismiss(animated: true)
    }
}


// MARK: - TextView delegate extension
extension CreateOneLineViewController: UITextViewDelegate {
    // MARK: 내용 text view 입력 이벤트
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.createOneLineview.label_placeholder.removeFromSuperview()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        UIView.animate(withDuration: 0, delay: 0, animations: {
            let size = CGSize(width: textView.frame.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            
//            guard estimatedSize.height >= 80 else {return}
            
            self.createOneLineview.layout_content.snp.updateConstraints { make in
                make.height.equalTo(estimatedSize.height + 30)
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
      }
}

// MARK: - 키보드 높이에 따른 view 이동 extension
extension CreateOneLineViewController {
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.createOneLineview.img_backgound.removeFromSuperview()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardUp(_ sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
        
            self.view.addSubview(self.createOneLineview.layout_settings)
            self.createOneLineview.layout_settings.snp.makeConstraints() { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().inset(keyboardRectangle.height)
                make.height.equalTo(48)
            }
            self.createOneLineview.didStartEditing(self.view)
            
            UIView.animate(
                withDuration: 0
                , animations: {
                    self.createOneLineview.layout_content.snp.updateConstraints { make in
                        make.bottom.equalTo(self.createOneLineview.layout_main.snp.centerY).inset(keyboardRectangle.height + 210)
                    }
                }
            )
         }
    }
    
    @objc func keyboardDown(_ sender: NSNotification) {
        self.createOneLineview.btn_color.removeFromSuperview()
        self.createOneLineview.layout_vertical.removeFromSuperview()
        self.createOneLineview.btn_font.removeFromSuperview()
        self.createOneLineview.layout_settings.removeFromSuperview()
        
        let height = self.createOneLineview.layout_content.frame.height / 2
        self.createOneLineview.layout_content.snp.updateConstraints {make in
            make.bottom.equalTo(self.createOneLineview.layout_main.snp.centerY).offset(height)
        }
    }
}
