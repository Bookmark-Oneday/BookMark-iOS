//
//  BookDetailViewController.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/01/10.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

// MARK: - 책 세부 내용 화면 뷰 컨트롤러
class BookDetailViewController: UIViewController {
    var layout_bookdetail = BookDetailView()
    let btn_more = UIBarButtonItem(image: UIImage(named: "threeLayerBtn"))
    let btn_heart = UIBarButtonItem(image: UIImage(named: "heart_black_unfill"))
    let btn_stopWatch = UIBarButtonItem(image: UIImage(named: "stopwatch"))
    var disposeBag = DisposeBag()
    var bookDetailViewModel: BookDetailViewModel
    
    init(bookId: String) {
        self.bookDetailViewModel = BookDetailViewModel(bookId: bookId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setNavigationCustom(title: "")
        self.navigationItem.rightBarButtonItems = [btn_more, btn_stopWatch, btn_heart]
        
        self.layout_bookdetail.initViews(view: self.view)
        self.setupBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func setupBindings() {
        bookDetailViewModel.bookTitle
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_bookdetail.label_title.rx.text)
            .disposed(by: disposeBag)
        
        bookDetailViewModel.bookAuthorAndTranslator
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_bookdetail.label_author.rx.text)
            .disposed(by: disposeBag)
        
        bookDetailViewModel.bookImage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                self?.layout_bookdetail.img_book.setImageUrl(url: url)
            })
            .disposed(by: disposeBag)
        
        bookDetailViewModel.firstReadDate
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_bookdetail.label_firstread_data.rx.text)
            .disposed(by: disposeBag)
        
        bookDetailViewModel.totalReadingTime
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_bookdetail.label_totaltime_data.rx.text)
            .disposed(by: disposeBag)
        
        bookDetailViewModel.totalPage
            .observe(on: MainScheduler.instance)
            .map { "/ \($0)" }
            .bind(to: self.layout_bookdetail.label_totalpage_data.rx.text)
            .disposed(by: disposeBag)
        
        bookDetailViewModel.currentPage
            .observe(on: MainScheduler.instance)
            .map { String($0) }
            .bind(to: self.layout_bookdetail.label_nowpage_data.rx.text)
            .disposed(by: disposeBag)
        
        bookDetailViewModel.readingPercent
            .observe(on: MainScheduler.instance)
            .map { $0 / 100.0 }
            .bind(to:  self.layout_bookdetail.layout_progress.rx.progress)
            .disposed(by: disposeBag)
        
        bookDetailViewModel.readingPercent
            .observe(on: MainScheduler.instance)
            .map { "\(Int($0))%" }
            .bind(to: self.layout_bookdetail.label_untilFin_data.rx.text)
            .disposed(by: disposeBag)
        
        bookDetailViewModel.readingHistory
            .observe(on: MainScheduler.instance)
            .filter { $0 != nil }
            .subscribe(onNext: { data in
                self.layout_bookdetail.setChartAttribute(data!)
            })
            .disposed(by: disposeBag)
        
        bookDetailViewModel.bookIsFavorite
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { favorite in
                self.btn_heart.image = (favorite ? UIImage(named: "heart_black_fill") : UIImage(named: "heart_black_unfill"))
            })
            .disposed(by: disposeBag)
        
        btn_stopWatch.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.pushViewController(StopwatchViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        btn_heart.rx.tap
            .subscribe(onNext: {
                self.bookDetailViewModel.bookIsFavorite.accept(!self.bookDetailViewModel.bookIsFavorite.value)
            })
            .disposed(by: disposeBag)
        
        btn_more.rx.tap
            .subscribe(onNext: { [weak self] in
                let bottomSheet = BottomSheetViewController()
                bottomSheet.deleteCompletion = {
                    self?.didTapDeleteBookButton()
                }
                bottomSheet.modalPresentationStyle = .overFullScreen
                self?.present(bottomSheet, animated: true)
            })
            .disposed(by: disposeBag)
        
        layout_bookdetail.btn_pageinput.rx.tap
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)
    }
    
    private func didTapDeleteBookButton() {
        let deletion = CustomAlertViewController()
        deletion.modalPresentationStyle = .overFullScreen
        deletion.confirmCompletion = { [weak self] in
            self?.bookDetailViewModel.deleteBook()
            self?.navigationController?.popToRootViewController(animated: true)
        }
        deletion.setAlertLabel(title: "책 삭제", subtitle: "서재 목록에서 책을 삭제하겠습니까?", okButtonTitle: "삭제")
        self.present(deletion, animated: true)
    }
}

