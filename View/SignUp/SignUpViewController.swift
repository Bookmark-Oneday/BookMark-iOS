//
//  SignUpViewController.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/02/15.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

// MARK: - 회원 가입 베이스 뷰 컨트롤러
class BaseSignUpViewController: UIViewController {
    let signUpUserInfo = SignUpUserInfo()
    let layout_main = UIView()
    let label_title = UILabel()
    let progress = UIProgressView()
    let button = UIButton()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setNavigationCustom(title: "")
        setBaseView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
      }
    
    private func setBaseView() {
        self.view.addSubview(layout_main)
        layout_main.snp.makeConstraints() { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        layout_main.addSubviews(progress, label_title, button)
        progress.snp.makeConstraints() { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(4)
        }
        progress.progressTintColor = .lightOrange
        progress.trackTintColor = .lightGray
        
        label_title.snp.makeConstraints() { make in
            make.top.equalTo(progress.snp.bottom).offset(53)
            make.leading.equalTo(30)
        }
        
        button.snp.makeConstraints() { make in
            make.horizontalEdges.equalToSuperview().inset(29)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-24)
        }
        button.backgroundColor = UIColor(Hex: 0xBDBDBD)
        button.layer.cornerRadius = 26
        button.setTitle("다음", size: 17, weight: .w600, color: .white)
        button.layer.zPosition = 999
        button.isEnabled = false
    }
    
    func setTextAttribute(_ text: String, boldStr: String) {
        label_title.numberOfLines = 0
        let str = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 6
        str.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.count))
        str.addAttribute(.foregroundColor, value: UIColor.textOrange, range: (text as NSString).range(of: boldStr))
        
        label_title.font = .suit(size: 24, weight: .w600)
        label_title.attributedText = str
    }
}

// MARK: - 회원 가입 이름 설정 뷰 컨트롤러
class SetNameViewController: BaseSignUpViewController {
    let tf_name = UITextField()
    let line = UIView()
    let name_count = UILabel()
    let nameCountData = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        setTextAttribute("사용할 닉네임을\n설정해 주세요", boldStr: "닉네임")
        
        self.layout_main.addSubviews(tf_name, line, name_count, nameCountData)
        tf_name.snp.makeConstraints() { make in
            make.top.equalTo(label_title.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        tf_name.placeholder = "닉네임 입력"
        tf_name.font = .suit(size: 18, weight: .w600)
        
        line.snp.makeConstraints() { make in
            make.top.equalTo(tf_name.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }
        line.backgroundColor = .semiLightGray
        
        nameCountData.snp.makeConstraints() { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
        }
        nameCountData.text = "0"
        nameCountData.textColor = UIColor(Hex: 0xBDBDBD)
        nameCountData.font = .suit(size: 15, weight: .w500)
        
        name_count.snp.makeConstraints() { make in
            make.centerY.equalTo(nameCountData)
            make.leading.equalTo(nameCountData.snp.trailing).offset(1)
        }
        name_count.text = "/10"
        name_count.textColor = UIColor(Hex: 0xBDBDBD)
        name_count.font = .suit(size: 15, weight: .w500)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progress.setProgress(0.25, animated: animated)
        
        tf_name.rx.controlEvent(.editingChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.nameCountData.text = String(describing: self?.tf_name.text?.count ?? 0)
            })
            .disposed(by: disposeBag)
        
        tf_name.rx.text
            .map { $0?.count ?? 0 }
            .subscribe(onNext: { [weak self] cnt in
                if (cnt > 0) {
                    UIView.animate(withDuration: 0.3, delay: 0, animations: {
                        self?.button.backgroundColor = .lightOrange
                    })
                    self?.button.isEnabled = true
                }
                else {
                    UIView.animate(withDuration: 0.3, delay: 0, animations: {
                        self?.button.backgroundColor = UIColor(Hex: 0xBDBDBD)
                    })
                    self?.button.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        button.rx.controlEvent(.touchUpInside)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.signUpUserInfo.userNickName = self?.tf_name.text
                self?.navigationController?.pushViewController(SetProfileViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}

// MARK: - 회원 가입 프로필 설정 뷰 컨트롤러
class SetProfileViewController: BaseSignUpViewController {
    let layout_circle = UIView()
    let img_profile = UIImageView()
    let label_name = UILabel()
    let tf_message = UITextField()
    let btn_later = UIButton()
    let line = UIView()
    let message_count = UILabel()
    let messageCountData = UILabel()
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImgPicker()
        setTextAttribute("자신의 프로필을\n설정해주세요", boldStr: "프로필")
        
        self.layout_main.addSubviews(tf_message, line, message_count, messageCountData, layout_circle, img_profile, label_name, btn_later)
    
        self.progress.progress = 0.25
        layout_circle.snp.makeConstraints() { make in
            make.top.equalTo(label_title.snp.bottom).offset(76)
            make.centerX.equalToSuperview()
            make.size.equalTo(116)
        }
        layout_circle.layer.cornerRadius = 58
        layout_circle.translatesAutoresizingMaskIntoConstraints = false
        layout_circle.layer.borderWidth = 1
        layout_circle.layer.borderColor = UIColor.lightGray.cgColor
        layout_circle.backgroundColor = .lightGray
        layout_circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        layout_circle.addSubview(img_profile)
        img_profile.snp.makeConstraints() { make in
            make.size.equalTo(106)
            make.center.equalToSuperview()
        }
        img_profile.layer.cornerRadius = 53
        img_profile.image = UIImage(named: "noProfileImg")
        img_profile.clipsToBounds = true
        img_profile.translatesAutoresizingMaskIntoConstraints = false

        label_name.snp.makeConstraints() { make in
            make.top.equalTo(layout_circle.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        label_name.text = self.signUpUserInfo.userNickName
        label_name.font = .suit(size: 20, weight: .w600)
        
        tf_message.snp.makeConstraints() { make in
            make.top.equalTo(label_name.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        tf_message.placeholder = "소개말 입력"
        tf_message.font = .suit(size: 18, weight: .w600)
        
        line.snp.makeConstraints() { make in
            make.top.equalTo(tf_message.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }
        line.backgroundColor = .semiLightGray
        
        messageCountData.snp.makeConstraints() { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
        }
        messageCountData.text = "0"
        messageCountData.textColor = UIColor(Hex: 0xBDBDBD)
        messageCountData.font = .suit(size: 15, weight: .w500)
        
        message_count.snp.makeConstraints() { make in
            make.centerY.equalTo(messageCountData)
            make.leading.equalTo(messageCountData.snp.trailing).offset(1)
        }
        message_count.text = "/60"
        message_count.textColor = UIColor(Hex: 0xBDBDBD)
        message_count.font = .suit(size: 15, weight: .w500)
    
        button.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(29)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-48)
        }
        
        btn_later.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        
        btn_later.setTitle("나중에 설정하기", size: 15, weight: .w500, color: .textLightGray)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progress.setProgress(0.5, animated: animated)
        
        tf_message.rx.controlEvent(.editingChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.messageCountData.text = String(describing: self?.tf_message.text?.count ?? 0)
            })
            .disposed(by: disposeBag)
        
        tf_message.rx.text
            .map { $0?.count ?? 0 }
            .subscribe(onNext: { [weak self] cnt in
                if (cnt > 0) {
                    UIView.animate(withDuration: 0.3, delay: 0, animations: {
                        self?.button.backgroundColor = .lightOrange
                    })
                    self?.button.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        button.rx.controlEvent(.touchUpInside)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.signUpUserInfo.userMessage = self?.tf_message.text
                self?.navigationController?.pushViewController(SetGoalViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        btn_later.rx.controlEvent(.touchUpInside)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.pushViewController(SetGoalViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: 이미지 피커 컨트롤러 extension
extension SetProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func setImgPicker() {
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        imgPicker.delegate = self
    }
    
    @objc func imagePicker(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.button.backgroundColor = .lightOrange
        })
        
        self.button.isEnabled = true
        present(self.imgPicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        self.img_profile.image = newImage
        self.signUpUserInfo.userImg = newImage
        
        picker.dismiss(animated: true, completion: {
          print("dismissed")
        })
    }
}

// MARK: - 회원 가입 목표 독서 시간 설정 뷰 컨트롤러
class SetGoalViewController: BaseSignUpViewController {
    let img_hourglass = UIImageView()
    let label_top = UILabel()
    let label_bottom = UILabel()
    let label_time = UILabel()
    let slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextAttribute("목표 독서 시간을\n설정하고 실천해보세요", boldStr: "목표 독서 시간")
        button.isEnabled = true
        button.backgroundColor = .lightOrange
        
        progress.progress = 0.5
        self.layout_main.addSubviews(img_hourglass, label_top, label_bottom, label_time, slider)
        img_hourglass.snp.makeConstraints() { make in
            make.top.equalTo(label_title.snp.bottom).offset(83)
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(187)
        }
        img_hourglass.image = UIImage(named: "setTimeGoal")
        
        slider.snp.makeConstraints() { make in
            make.top.equalTo(img_hourglass.snp.bottom).offset(65)
            make.horizontalEdges.equalToSuperview().inset(29)
            make.height.equalTo(5)
        }
        slider.backgroundColor = .lightGray
        slider.thumbTintColor = .lightOrange
        slider.tintColor = .lightOrange
        slider.minimumValue = 10
        slider.maximumValue = 240
        slider.value = 120
        slider.addTarget(self, action: #selector(didSliderValueChanged), for: .valueChanged)
        
        label_time.snp.makeConstraints() { make in
            make.top.equalTo(slider.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        label_time.font = .suit(size: 26, weight: .w500)
        label_time.text = "2시간"
        
        label_top.snp.makeConstraints() { make in
            make.top.equalTo(label_time.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        label_top.text = "2022년 성인 기준"
        label_top.font = .suit(size: 17, weight: .w600)
        
        label_bottom.snp.makeConstraints() { make in
            make.top.equalTo(label_top.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        setBoldAttribute("평균보다 90분 많아요")
        
        button.setTitle("가입 완료", size: 17, weight: .w600, color: .white)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didSliderValueChanged(_ sender: UISlider) {
        let time = Int(sender.value)
        let hour = time / 60
        let min = Int(time % 60)
        label_time.text = "\(hour)시간 \(min)분"
        let timeDiff = time - 30
        if (timeDiff < 0) {
            setBoldAttribute("평균보다 \(30 - timeDiff)분 적어요")
        }
        else if (timeDiff > 0) {
            setBoldAttribute("평균보다 \(timeDiff)분 많아요")
        }
        else {
            setBoldAttribute(" 평균이에요")
        }
    }
    
    func setBoldAttribute(_ text: String) {
        let first = text.firstIndex(of: " ") ?? text.startIndex
        let last = text.lastIndex(of: " ") ?? text.startIndex
        
        let boldStr = text[first...last]
        let str = NSMutableAttributedString(string: text)
        str.addAttributes([.font: UIFont.suit(size: 17, weight: .w600)], range: NSRange(location: 0, length: text.count))
        str.addAttribute(.foregroundColor, value: UIColor.textOrange, range: (text as NSString).range(of: String(boldStr)))
        self.label_bottom.attributedText = str
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        self.signUpUserInfo.userGoal = Int(self.slider.value)
        self.navigationController?.pushViewController(FinishSignUpViewController(), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progress.setProgress(0.75, animated: animated)
    }
}

// MARK: - 설정 끝 뷰 컨트롤러
class FinishSignUpViewController: BaseSignUpViewController {
    let logo = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress.progress = 0.75
        
        self.layout_main.addSubview(logo)
        logo.snp.makeConstraints() { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.layout_main.snp.centerY).offset(-20)
            make.width.equalTo(80)
            make.height.equalTo(98)
        }
        logo.image = UIImage(named: "splashIcon")
        
        label_title.snp.remakeConstraints() { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(30)
        }
        label_title.numberOfLines = 0
        label_title.text = "축하합니다!\n책갈피 회원이 되었어요🎉"
        label_title.textAlignment = .center
        label_title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progress.setProgress(1, animated: animated)
    }
}
