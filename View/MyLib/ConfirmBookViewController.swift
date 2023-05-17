//
//  ConfirmBookViewController.swift
//  BookMark
//
//  Created by Jin younkyum on 2023/01/07.
// Merge Again

import SnapKit
import UIKit
import Kingfisher
import RxCocoa
import RxSwift

// MARK: - 책 확인 view controller
class ConfirmBookViewController: UIViewController {
    let registerButton = UIBarButtonItem(title: "등록")
    let layout_main = ConfirmBookView()
    var confirmBookViewModel: ConfirmBookViewModel
    var disposeBag = DisposeBag()
    
    init(isbn: String) {
        self.confirmBookViewModel = ConfirmBookViewModel(isbn: isbn)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationCustom(title: "")
        self.registerButton.tintColor = .textOrange
        self.navigationItem.rightBarButtonItem = registerButton
        
        self.layout_main.initViews(superView: self.view)
        self.setupBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disposeBag = DisposeBag()
    }
    
    private func setupBindings() {
        self.registerButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                let pageInput = TotalPageInputViewController()
                pageInput.modalPresentationStyle = .overFullScreen
                pageInput.confirmCompletion = { [weak self] total in
                    self?.confirmBookViewModel.registerBook(totalPage: total)
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                self?.present(pageInput, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.confirmBookViewModel.bookTitle
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.confirmBookViewModel.bookAuthor
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.authorLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.confirmBookViewModel.bookImage
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] url in
                self?.layout_main.imageView.setImageUrl(url: url)
            })
            .disposed(by: disposeBag)
        
        self.confirmBookViewModel.bookPublisher
            .observe(on: MainScheduler.instance)
            .map { "출판사  " + $0 }
            .bind(to: self.layout_main.publisherLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.confirmBookViewModel.bookDate
            .observe(on: MainScheduler.instance)
            .map { "발행일  " + $0}
            .bind(to: self.layout_main.pubdateLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        self.confirmBookViewModel.bookSummary
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.descriptionTextView.rx.text)
            .disposed(by: disposeBag)
    }

}

// MARK: - 레이아웃 용 extension
class ConfirmBookView {
    let layout_book = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let publisherLabel = UILabel()
    let pubdateLabel = UILabel()
    let label_summary = UILabel()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    let descriptionTextView = UILabel()
    let showallButton = UIButton()
    let showShortButton = UIButton()
    let contentView = UIView()
    let divideView = UIView()
    let upperDivideView = UIView()
    
    func initViews(superView: UIView) {
        superView.addSubview(scrollView)
        superView.backgroundColor = .white
        
        scrollView.addSubview(contentView)
        contentView.addSubviews(layout_book, titleLabel, authorLabel, publisherLabel, pubdateLabel, descriptionTextView, showallButton, showShortButton, divideView, upperDivideView, label_summary)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.snp.makeConstraints() { make in
            make.edges.equalTo(superView.safeAreaLayoutGuide)
        }
        scrollView.contentLayoutGuide.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        
        upperDivideView.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(5)
            make.top.equalTo(contentView.snp.top).offset(32)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        upperDivideView.layer.cornerRadius = 2
        upperDivideView.backgroundColor = .semiLightGray
        
        layout_book.snp.makeConstraints() { make in
            make.top.equalTo(upperDivideView.snp.bottom).offset(11)
            make.width.equalTo(222)
            make.height.equalTo(307)
            make.centerX.equalToSuperview()
        }
        layout_book.layer.borderWidth = 1
        layout_book.layer.borderColor = UIColor.clear.cgColor
        layout_book.backgroundColor = .lightGray
        layout_book.layer.cornerRadius = 6
        layout_book.layer.shadowColor = UIColor.darkGray.cgColor
        layout_book.layer.shadowRadius = 3
        layout_book.layer.shadowOffset = CGSize(width: 1, height: 3)
        layout_book.layer.masksToBounds = false
        layout_book.layer.shadowOpacity = 0.5
        layout_book.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .textLightGray
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(60)
            make.top.equalTo(imageView.snp.bottom).offset(24)
        }
        titleLabel.setTxtAttribute("제목 정보가 없습니다.", size: 18, weight: .w600, txtColor: .black)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        authorLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(60)
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
        }
        authorLabel.setTxtAttribute("작가 정보가 없습니다.", size: 15, weight: .w600, txtColor: .textGray)
        authorLabel.numberOfLines = 0
        authorLabel.textAlignment = .center
        
        publisherLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(superView.snp.centerX).inset(5)
            make.top.equalTo(authorLabel.snp.bottom).offset(8)
        }
        publisherLabel.setTxtAttribute("출판사 정보가 없습니다.", size: 14, weight: .w500, txtColor: .textGray)
        publisherLabel.textAlignment = .right
        
        pubdateLabel.snp.makeConstraints { make in
            make.leading.equalTo(superView.snp.centerX).offset(5)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(authorLabel.snp.bottom).offset(8)
        }
        pubdateLabel.setTxtAttribute("날짜 정보가 없습니다.", size: 14, weight: .w500, txtColor: .textGray)
        pubdateLabel.textAlignment = .left
        
        divideView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(13)
            make.top.equalTo(publisherLabel.snp.bottom).offset(47)
        }
        divideView.backgroundColor = .semiLightGray
        
        label_summary.snp.makeConstraints() { make in
            make.top.equalTo(divideView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(23)
        }
        label_summary.setTxtAttribute("줄거리", size: 15, weight: .w600, txtColor: .black)
        
        descriptionTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(23)
            make.top.equalTo(label_summary.snp.bottom).offset(15)
            make.height.equalTo(100)
        }
        descriptionTextView.setTxtAttribute("설명이 없습니다", size: 14, weight: .w500, txtColor: .textBoldGray)
        descriptionTextView.textAlignment = .justified
        descriptionTextView.numberOfLines = 0
        
        showallButton.snp.makeConstraints { make in
            make.trailing.equalTo(descriptionTextView.snp.trailing)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(7)
        }
        showallButton.setTitle("전체보기", size: 11, weight: .w500, color: .textGray)
        showallButton.addTarget(self, action: #selector(didTapShowAll), for: .touchUpInside)
        
        showShortButton.snp.makeConstraints() { make in
            make.trailing.equalTo(descriptionTextView.snp.trailing)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(7)
        }
        showShortButton.setTitle("닫기", size: 11, weight: .w500, color: .textGray)
        showShortButton.addTarget(self, action: #selector(didTapShowShort), for: .touchUpInside)
        showShortButton.isHidden = true
    }
    
    @objc func didTapShowAll(_ sender: UIButton) {
        self.showShortButton.isHidden = false
        sender.isHidden = true
        self.descriptionTextView.snp.remakeConstraints() { make in
            make.leading.trailing.equalToSuperview().inset(23)
            make.top.equalTo(label_summary.snp.bottom).offset(15)
            make.height.equalTo(self.descriptionTextView.intrinsicContentSize.height)
        }
        scrollView.contentLayoutGuide.snp.remakeConstraints() { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.scrollView.frame.height + self.descriptionTextView.frame.height + 50)
        }
    }
    
    @objc func didTapShowShort(_ sender: UIButton) {
        self.showallButton.isHidden = false
        sender.isHidden = true
        self.descriptionTextView.snp.remakeConstraints() { make in
            make.leading.trailing.equalToSuperview().inset(23)
            make.top.equalTo(label_summary.snp.bottom).offset(15)
            make.height.equalTo(100)
        }
        scrollView.contentLayoutGuide.snp.remakeConstraints() { make in
            make.edges.equalTo(scrollView.frameLayoutGuide)
        }
    }
}
