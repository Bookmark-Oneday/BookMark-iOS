//
//  StopwatchViewController.swift
//  BookMark
//
//  Created by BoMin on 2023/03/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

class StopwatchViewController: UIViewController {

    let disposeBag = DisposeBag()
    var stopwatchVM: StopwatchViewModel
    
    let layout = StopwatchView()
    
    init(bookId: String) {
        print("init")
        self.stopwatchVM = StopwatchViewModel(stopwatch: Stopwatch(), bookId: bookId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        configure()
        bindViewModel()
    }

}

extension StopwatchViewController {
    private func setNavigation() {
        self.setNavigationCustom(title: "스톱워치")
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        self.layout.initViews(view: self.view)
//        self.layout.layout_table.layout_timerHistories.delegate = self
//        self.layout.layout_table.layout_timerHistories.dataSource = self
    }
    
    private func bindViewModel() {
        stopwatchVM.elapsedTime
            .bind(to: layout.label_time.rx.text)
            .disposed(by: disposeBag)
        
        stopwatchVM.startPauseButtonImage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] imageName in
                self?.layout.button_startStop.setImage(UIImage(named: imageName), for: .normal)
            })
            .disposed(by: disposeBag)
        
        
        //MARK: totalButton Img
//        stopwatchVM.totalButtonImage
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] imageName in
//                self?.layout.button_total.setImage(UIImage(named: imageName), for: .normal)
//            })
//            .disposed(by: disposeBag)
        
        stopwatchVM.historyListObservable
            .bind(to: layout.layout_table.layout_timerHistories.rx.items(cellIdentifier: StopwatchHistoryTableViewCell.identifier, cellType: StopwatchHistoryTableViewCell.self)) { [weak self] row, history, cell in
                guard let self = self else { return }

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = dateFormatter.date(from: history.date) {
                    dateFormatter.dateFormat = "yyyy. MM. dd."
                    let dateString = dateFormatter.string(from: date)
                    
                    let timeString = self.stopwatchVM.historyStringFormat(time: TimeInterval(history.time))

                    cell.configure(date: dateString, time: timeString)
                }
            }
            .disposed(by: disposeBag)


        layout.layout_table.layout_timerHistories.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        
        layout.button_startStop.rx.tap.bind { [weak self] in
            self?.stopwatchVM.startOrPause()
            
        }.disposed(by: disposeBag)
        
        layout.layout_deleteAllView.button_deleteAll.rx.tap
            .subscribe(onNext: { [weak self] in
                let bottomSheet = BottomSheetHistoryViewController()
                bottomSheet.deleteCompletion = {
                    self?.didTapDeleteHistoryButton()
                }
                bottomSheet.modalPresentationStyle = .overFullScreen
                self?.present(bottomSheet, animated: true)
            })
            .disposed(by: disposeBag)
        
//        btn_more.rx.tap
//            .subscribe(onNext: { [weak self] in
//                let bottomSheet = BottomSheetViewController()
//                bottomSheet.deleteCompletion = {
//                    self?.didTapDeleteBookButton()
//                }
//                bottomSheet.modalPresentationStyle = .overFullScreen
//                self?.present(bottomSheet, animated: true)
//            })
//            .disposed(by: disposeBag)
        
        
        
        layout.button_total.rx.controlEvent([.touchDown, .touchDragEnter]).bind { [weak self] in
            self?.stopwatchVM.changeTimeLabelColor()
            self?.stopwatchVM.changeTotalButtonColor()
            self?.layout.label_total.isHidden = false
        }.disposed(by: disposeBag)

        layout.button_total.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit]).bind { [weak self] in
            self?.stopwatchVM.reverTimeLabelColor()
            self?.stopwatchVM.revertTotalButtonColor()
            self?.layout.label_total.isHidden = true
        }.disposed(by: disposeBag)
        
        stopwatchVM.durationFromAPI
            .flatMapLatest { duration -> Observable<CGFloat> in
                return self.stopwatchVM.elapsedTimeValue
                    .map { elapsed -> CGFloat in
                        let progress = elapsed / duration
                        return CGFloat(min(progress, 1.0))
                    }
            }
            .bind { [weak self] progress in
                self?.layout.layout_stopwatch.setProgress(progress)
            }
            .disposed(by: disposeBag)
        
        stopwatchVM.timeColor
            .bind(to: layout.label_time.rx.textColor)
            .disposed(by: disposeBag)
        
        stopwatchVM.totalButtonColor
            .bind(to: layout.button_total.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    private func didTapDeleteHistoryButton() {
        let deletion = CustomAlertViewController()
        deletion.modalPresentationStyle = .overFullScreen
        deletion.confirmCompletion = { [weak self] in
            self?.stopwatchVM.deleteTime()
            self?.navigationController?.popViewController(animated: true)
        }
        deletion.setAlertLabel(title: "기록 삭제", subtitle: "기록을 정말 삭제하겠습니까?", okButtonTitle: "삭제")
        self.present(deletion, animated: true)
    }
}

extension StopwatchViewController: UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////MARK: toDo: edit row num
//        return 10
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchHistoryTableViewCell.identifier, for: indexPath) as? StopwatchHistoryTableViewCell else {
//            fatalError("Stopwatch History TableView Cell not found.")
//        }
//
//
//        return cell
//    }
}

