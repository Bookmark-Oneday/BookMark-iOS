//
//  StopwatchViewController.swift
//  BookMark
//
//  Created by BoMin on 2023/03/19.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

//MARK: -StopwatchViewController
class StopwatchViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let stopwatchVM = StopwatchViewModel(stopwatch: Stopwatch())
    
    let layout = StopwatchViewA()
    
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
//        self.view.layoutIfNeeded()
        self.layout.initViews(view: self.view)
        self.layout.layout_table.layout_timerHistories.delegate = self
        self.layout.layout_table.layout_timerHistories.dataSource = self
    }
    
    private func bindViewModel() {
        stopwatchVM.elapsedTime
            .bind(to: layout.label_time.rx.text)
            .disposed(by: disposeBag)
        
//        stopwatchVM.startPauseTitle
//            .bind(to: layout.getStartStopButton().rx.title())
//            .disposed(by: disposeBag)
//
//        stopwatchVM.startPauseColor
//            .bind(to: layout.getStartStopButton().rx.backgroundColor)
//            .disposed(by: disposeBag)
        
        layout.button_startStop.rx.tap.bind { [weak self] in
            self?.stopwatchVM.startOrPause()
        }.disposed(by: disposeBag)
        
        layout.button_total.rx.controlEvent([.touchDown, .touchDragEnter]).bind { [weak self] in
//            self?.stopwatchVM.changeStrokeColor()
            self?.stopwatchVM.changeTimeLabelColor()
            self?.stopwatchVM.changeTotalButtonColor()
            self?.layout.label_total.isHidden = false
        }.disposed(by: disposeBag)

        layout.button_total.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit]).bind { [weak self] in
//            self?.stopwatchVM.revertStrokeColor()
            self?.stopwatchVM.reverTimeLabelColor()
            self?.stopwatchVM.revertTotalButtonColor()
            self?.layout.label_total.isHidden = true
        }.disposed(by: disposeBag)
        
//MARK: Todo: Edit Duration
        let durationFromAPI: TimeInterval = 120
        
        stopwatchVM.elapsedTimeValue
            .map { elapsed -> CGFloat in
                let progress = elapsed / durationFromAPI
                return CGFloat(min(progress, 1.0))
            }
            .bind { [weak self] progress in
                self?.layout.layout_stopwatch.setProgress(progress)
            }.disposed(by: disposeBag)
        
//        stopwatchVM.strokeColor
//            .bind(to: layout.layout_stopwatch.rx.strokeColor)
//            .disposed(by: disposeBag)
        
        stopwatchVM.timeColor
            .bind(to: layout.label_time.rx.textColor)
            .disposed(by: disposeBag)
        
        stopwatchVM.totalButtonColor
            .bind(to: layout.button_total.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}

extension StopwatchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//MARK: toDo: edit row num
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchHistoryTableViewCell.identifier, for: indexPath) as? StopwatchHistoryTableViewCell else {
            fatalError("Stopwatch History TableView Cell not found.")
        }
        
        
        return cell
    }
}

class StopwatchViewA {
    let layout_main = UIView()
//    var layout_stopwatch_container = UIView()
    let layout_stopwatch = StopwatchRunningView()
    
    let label_time = UILabel()
    let button_total = UIButton()
    let button_startStop = UIButton()
    let label_total = UILabel()
    
    let layout_deleteAll = UIView()
    let layout_deleteAllView = HistoryDeleteAllView()
    
    let layout_tableView = UIView()
    let layout_table = StopwatchHistoryView()
    
//MARK: toDo: add arguments
    func initViews(view: UIView) {
        view.addSubviews(layout_main, layout_deleteAll, layout_tableView)
        layout_main.snp.makeConstraints{ make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(436)
        }
        //
//        layout_main.backgroundColor = .systemGreen
        
        layout_main.addSubviews(label_time, button_total, button_startStop, label_total)
        
        label_time.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(120)
        }
        
        label_time.text = "--:--"
        label_time.textColor = UIColor(red: 0.262, green: 0.262, blue: 0.262, alpha: 1)
        label_time.font = UIFont(name: "SUIT-ExtraLight", size: 80)
        
        label_total.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label_time.snp.bottom).offset(5)
        }
        
        label_total.text = "Total"
        label_total.textColor = .textOrange
        label_total.font = UIFont(name: "SUIT-Medium", size: 16)
        label_total.isHidden = true
        
        button_total.snp.makeConstraints{ make in
            make.height.width.equalTo(66)
            make.top.equalTo(label_total.snp.bottom).offset(35)
            make.trailing.equalTo(layout_main.snp.centerX).offset(-30)
        }
        
        button_total.backgroundColor = .lightOrange
        button_total.layer.masksToBounds = true
        button_total.layer.cornerRadius = 33
        button_total.layer.borderColor = UIColor.lightOrange.cgColor
        button_total.layer.borderWidth = 3
        
        button_startStop.snp.makeConstraints{ make in
            make.height.width.equalTo(66)
            make.top.equalTo(button_total)
            make.leading.equalTo(layout_main.snp.centerX).offset(30)
        }
        
        button_startStop.backgroundColor = .lightOrange
        button_startStop.layer.masksToBounds = true
        button_startStop.layer.cornerRadius = 33
        
        layout_deleteAll.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(layout_main.snp.bottom)
            make.height.equalTo(60)
        }
        
        layout_tableView.snp.makeConstraints{ make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(layout_deleteAll.snp.bottom)
        }
        
        layout_main.addSubview(layout_stopwatch)
        
        layout_stopwatch.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(layout_main.bounds.width * 0.8)
        }
        layout_stopwatch.initViews(view: layout_main)

        layout_deleteAllView.initViews(view: layout_deleteAll)
        layout_table.initView(view: layout_tableView)
    }
}

extension StopwatchViewA {
    func getTimeLabel() -> UILabel {
        return label_time
    }
    
    func getStartStopButton() -> UIButton {
        return button_startStop
    }
    
    func getTotalButton() -> UIButton {
        return button_total
    }
}

//MARK: -StopwatchRunningView
class StopwatchRunningView: UIView {
    
    private let disposeBag = DisposeBag()
    
    let shape = CAShapeLayer()
    let trackShape = CAShapeLayer()
    
    var circlePath = UIBezierPath()
    
    func initViews(view: UIView) {
        circlePath = UIBezierPath(arcCenter: self.center,
                                      radius: 150,
                                      startAngle: .pi * (5/6),
                                      endAngle: .pi * (1/6),
                                      clockwise: true)
        trackShape.path = circlePath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 10
        trackShape.strokeColor = UIColor.lightGray.cgColor
        trackShape.lineCap = CAShapeLayerLineCap.round

        self.layer.addSublayer(trackShape)

        shape.path = circlePath.cgPath
        shape.lineWidth = 10
        shape.strokeColor = UIColor.systemOrange.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        shape.lineCap = CAShapeLayerLineCap.round

        self.layer.addSublayer(shape)
    }
    
    func setProgress(_ progress: CGFloat) {
        shape.strokeEnd = progress
    }
    
    func circleAnimate(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        shape.add(animation, forKey: "animation")
    }
    
    func pauseAnimation() {
        let pausedTime = shape.convertTime(CACurrentMediaTime(), from: nil)
        shape.speed = 0.0
        shape.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = shape.timeOffset
        shape.speed = 1.0
        shape.timeOffset = 0.0
        shape.beginTime = 0.0
        let timeSincePause = shape.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shape.beginTime = timeSincePause
    }
    
    func stopAnimation() {
        shape.removeAllAnimations()
    }
    
    func bindStrokeColor(_ observable: Observable<UIColor>) {
        observable.subscribe(onNext: { [weak self] color in
            self?.shape.strokeColor = color.cgColor
        }).disposed(by: disposeBag)
    }
}

extension Reactive where Base: StopwatchRunningView {
    var strokeColor: Binder<UIColor> {
        return Binder(self.base) { view, color in
            view.shape.strokeColor = color.cgColor
        }
    }
}

enum StopwatchState {
    case initial
    case running
    case paused
}

//MARK: -HistotyDeleteAllView
class HistoryDeleteAllView {
    let layout_header = UIView()
    let button_deleteAll = UIButton()
    
    func initViews(view: UIView) {
        view.backgroundColor = .white
        
        view.addSubview(layout_header)
        
        layout_header.snp.makeConstraints{ make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        layout_header.addSubview(button_deleteAll)
        
        button_deleteAll.snp.makeConstraints{ make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-25)
        }
        
        layout_header.layer.masksToBounds = true
        layout_header.layer.cornerRadius = 30
        layout_header.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layout_header.layer.borderWidth = 1
        layout_header.layer.borderColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1).cgColor
        
        button_deleteAll.setImage(UIImage(named: "seeMore"), for: .normal)
        button_deleteAll.contentMode = .scaleAspectFit
        
    }
}

//MARK: -StopwatchHistoryView
class StopwatchHistoryView {
    var layout_timerHistories: UITableView = {
        let layout_timerHistories = UITableView()
        
        layout_timerHistories.backgroundColor = .white
        layout_timerHistories.register(StopwatchHistoryTableViewCell.self, forCellReuseIdentifier: StopwatchHistoryTableViewCell.identifier)
        layout_timerHistories.translatesAutoresizingMaskIntoConstraints = false
        layout_timerHistories.separatorInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        
        return layout_timerHistories
    }()
    
    func initView(view: UIView) {
        view.backgroundColor = .white
        view.addSubview(layout_timerHistories)
        
        layout_timerHistories.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: -StopwatchHistoryTableViewCell
class StopwatchHistoryTableViewCell: UITableViewCell {
    static let identifier = "StopwatchHistoryTableViewCell"
    
    let label_date = UILabel()
    let label_time = UILabel()
    let button_delete = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addSubviews(label_date, label_time, button_delete)
        
        label_date.snp.makeConstraints{ make in
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(23)
        }
        
        button_delete.snp.makeConstraints{ make in
            make.width.height.equalTo(13)
            make.centerY.equalTo(label_date)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        label_time.snp.makeConstraints{ make in
            make.width.equalTo(90)
            make.height.equalTo(25)
            make.centerY.equalTo(label_date)
            make.trailing.equalTo(button_delete.snp.leading).offset(-10)
        }
        
        label_date.text = "2023. 03. 19"
        label_date.font = UIFont(name: "SUIT-Medium", size: 18)
        label_date.textColor = UIColor(red: 0.262, green: 0.262, blue: 0.262, alpha: 1)
        label_date.lineBreakMode = .byTruncatingTail
        label_date.textAlignment = .left
        
        button_delete.setImage(UIImage(named: "cancel"), for: .normal)
        
        label_time.text = "1h 11m"
        label_time.font = UIFont(name: "SUIT-SemiBold", size: 19)
        label_time.textColor = .black
        label_time.lineBreakMode = .byTruncatingTail
        label_time.textAlignment = .right
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





