//
//  BookDetailView.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/02/06.
//

import UIKit
import Charts
import SnapKit

// MARK: - 책 세부 내용 화면 layout class
class BookDetailView {
    var layout_scroll = UIScrollView()
    
    var layout_main = UIView()
    var layout_horizontal = UIView()
    var layout_book = UIView()
    var img_book = UIImageView()
    
    var label_title = UILabel()
    var label_author = UILabel()
    
    var layout_vertical = UIView()
    var label_firstread = UILabel()
    var label_firstread_data = UILabel()
    
    var label_totaltime = UILabel()
    var label_totaltime_data = UILabel()
    
    var layout_line = UIView()
    var label_untilFin = UILabel()
    var label_untilFin_data = UILabel()
    
    var label_nowpage_data = UILabel()
    var label_totalpage_data = UILabel()
    
    var layout_progress = UIProgressView()
    
    var label_zero = UILabel()
    var label_hundred = UILabel()
    
    var btn_pageinput = UIButton()
    
    var label_myTime = UILabel()
    var label_myTimeDescription = UILabel()
    
    var layout_barchart = UIScrollView()
    var layout_add = UIView()
    var barchart = BarChartView()
    var chartEntry: [BarChartDataEntry] = []
    
    func initViews(view: UIView) {
        initViews_part1(view: view)
        initViews_part2(view: view)
        initViews_part3(view: view)
    }
    
    private func initViews_part1(view: UIView) {
        view.addSubview(layout_scroll)
        
        layout_scroll.translatesAutoresizingMaskIntoConstraints = false
        layout_scroll.snp.makeConstraints() { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        layout_scroll.contentLayoutGuide.snp.makeConstraints() { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1050)
        }
        
        layout_scroll.addSubview(layout_main)
        layout_main.snp.makeConstraints() { make in
            make.edges.equalTo(layout_scroll.contentLayoutGuide)
        }
        
        layout_main.addSubviews(layout_horizontal, layout_book, label_title, label_author, layout_vertical, label_firstread, label_firstread_data, label_totaltime, label_totaltime_data)
        layout_horizontal.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(23)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(5)
        }
        layout_horizontal.layer.cornerRadius = 3
        layout_horizontal.clipsToBounds = false
        layout_horizontal.layer.borderColor = UIColor.black.cgColor
        layout_horizontal.backgroundColor = UIColor(Hex: 0xDFDFDF)
        
        layout_book.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(37)
            make.width.equalTo(170)
            make.height.equalTo(247)
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
        
        layout_book.addSubview(img_book)
        img_book.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }
        img_book.layer.cornerRadius = 6
        img_book.clipsToBounds = true
        img_book.translatesAutoresizingMaskIntoConstraints = false
        img_book.contentMode = .scaleAspectFill
        img_book.image = UIImage(named: "noBookImg")
        
        label_title.snp.makeConstraints() { make in
            make.top.equalTo(layout_book.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(60)
            make.centerX.equalToSuperview()
        }
        label_title.setTxtAttribute("제목 정보가 없습니다.", size: 18, weight: .w600, txtColor: .black)
        label_title.textAlignment = .center
        
        label_author.snp.makeConstraints() { make in
            make.top.equalTo(label_title.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(60)
            make.centerX.equalToSuperview()
        }
        label_author.setTxtAttribute("작가 정보가 없습니다.", size: 15, weight: .w500, txtColor: .textGray)
        label_author.textAlignment = .center
        
        layout_vertical.snp.makeConstraints() { make in
            make.top.equalTo(label_author.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
            make.width.equalTo(2)
            make.height.equalTo(20)
        }
        layout_vertical.layer.cornerRadius = 3
        layout_vertical.clipsToBounds = false
        layout_vertical.layer.borderColor = UIColor.black.cgColor
        layout_vertical.backgroundColor = UIColor(Hex: 0xD9D9D9)
        
        label_firstread.snp.makeConstraints() { make in
            make.top.equalTo(label_author.snp.bottom).offset(50)
            make.trailing.equalTo(layout_vertical.snp.leading).offset(-61)
        }
        label_firstread.setTxtAttribute("처음 읽은 날", size: 15, weight: .w500, txtColor: .textGray)
        
        label_firstread_data.snp.makeConstraints() { make in
            make.centerX.equalTo(label_firstread)
            make.top.equalTo(label_firstread.snp.bottom).offset(10)
        }
        label_firstread_data.setTxtAttribute("2022.01.09", size: 17, weight: .w600, txtColor: .black)
        
        label_totaltime.snp.makeConstraints() { make in
            make.leading.equalTo(layout_vertical.snp.trailing).offset(61)
            make.top.equalTo(label_firstread)
        }
        label_totaltime.setTxtAttribute("총 독서 시간", size: 15, weight: .w500, txtColor: .textGray)
        
        label_totaltime_data.snp.makeConstraints() { make in
            make.centerX.equalTo(label_totaltime)
            make.top.equalTo(label_totaltime.snp.bottom).offset(10)
        }
        label_totaltime_data.setTxtAttribute("12:28.00", size: 17, weight: .w600, txtColor: .black)
    }
    
    private func initViews_part2(view: UIView) {
        layout_main.addSubviews(layout_line, label_untilFin, label_untilFin_data, label_nowpage_data, label_totalpage_data, label_zero, label_hundred, btn_pageinput)
        
        layout_line.snp.makeConstraints() { make in
            make.top.equalTo(label_firstread.snp.bottom).offset(56)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(23)
            make.height.equalTo(1)
        }
        layout_line.layer.cornerRadius = 3
        layout_line.clipsToBounds = true
        layout_line.backgroundColor = UIColor(Hex: 0xDFDFDF)
        
        label_untilFin.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(23)
            make.top.equalTo(layout_line.snp.bottom).offset(32)
        }
        label_untilFin.setTxtAttribute("완독까지", size: 14, weight: .w500, txtColor: .textLightGray)
        
        label_untilFin_data.snp.makeConstraints() { make in
            make.leading.equalTo(label_untilFin.snp.trailing).offset(4)
            make.top.equalTo(label_untilFin)
        }
        label_untilFin_data.setTxtAttribute("42%", size: 14, weight: .w600, txtColor: .textOrange)
        
        label_totalpage_data.snp.makeConstraints() { make in
            make.trailing.equalTo(layout_line.snp.trailing)
            make.top.equalTo(layout_line.snp.bottom).offset(28)
        }
        label_totalpage_data.setTxtAttribute("/ 354", size: 17, weight: .w600, txtColor: .textGray)
        
        label_nowpage_data.snp.makeConstraints() { make in
            make.trailing.equalTo(label_totalpage_data.snp.leading).offset(-4)
            make.top.equalTo(label_totalpage_data)
        }
        label_nowpage_data.setTxtAttribute("120", size: 17, weight: .w600, txtColor: .textOrange)
        
        layout_main.addSubviews(layout_progress, label_zero, label_hundred)
        
        layout_progress.snp.makeConstraints() { make in
            make.top.equalTo(label_untilFin.snp.bottom).offset(11)
            make.leading.equalTo(label_untilFin)
            make.trailing.equalTo(label_totalpage_data)
            make.height.equalTo(7)
        }
        layout_progress.progressTintColor = .lightOrange
        layout_progress.trackTintColor = .lightGray
        layout_progress.setProgress(0.42, animated: true)
        layout_progress.clipsToBounds = true
        layout_progress.layer.cornerRadius = 3
        
        label_zero.snp.makeConstraints() { make in
            make.leading.equalTo(label_untilFin)
            make.top.equalTo(layout_progress.snp.bottom).offset(5)
        }
        label_zero.setTxtAttribute("0", size: 11, weight: .w500, txtColor: .textGray)
        
        label_hundred.snp.makeConstraints() { make in
            make.trailing.equalTo(label_totalpage_data)
            make.top.equalTo(label_zero)
        }
        label_hundred.setTxtAttribute("100", size: 11, weight: .w500, txtColor: .textGray)
        
        btn_pageinput.snp.makeConstraints() { make in
            make.top.equalTo(label_zero.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        btn_pageinput.setTitle("페이지 입력", size: 16, weight: .w600, color: .white)
        btn_pageinput.backgroundColor = .lightOrange
        btn_pageinput.layer.cornerRadius = 20
        btn_pageinput.clipsToBounds = true
    }

    private func initViews_part3(view: UIView) {
        layout_main.addSubviews(label_myTime, label_myTimeDescription, layout_barchart)
        label_myTime.snp.makeConstraints() { make in
            make.top.equalTo(btn_pageinput.snp.bottom).offset(39)
            make.leading.equalToSuperview().offset(23)
        }
        label_myTime.setTxtAttribute("나의 독서기록", size: 16, weight: .w600, txtColor: .black)
        
        label_myTimeDescription.snp.makeConstraints() { make in
            make.top.equalTo(label_myTime.snp.bottom).offset(7)
            make.leading.equalTo(label_myTime)
        }
        label_myTimeDescription.setTxtAttribute("날짜별로 보는 하루 독서량", size: 12, weight: .w500, txtColor: .textLightGray)
        
        layout_barchart.translatesAutoresizingMaskIntoConstraints = false
        layout_barchart.snp.makeConstraints() { make in
            make.top.equalTo(label_myTimeDescription.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(300)
        }
        layout_barchart.contentLayoutGuide.snp.makeConstraints() { make in
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        layout_barchart.addSubview(layout_add)
        layout_add.addSubview(barchart)
        
        layout_add.isUserInteractionEnabled = false
        layout_add.snp.makeConstraints() { make in
            make.width.equalTo(layout_barchart.contentLayoutGuide)
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
        }
        barchart.isUserInteractionEnabled = false
        barchart.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        
        barchart.noDataText = "데이터가 없습니다"
        barchart.noDataTextAlignment = .center
        barchart.noDataFont = .suit(size: 14, weight: .w500)
        barchart.noDataTextColor = .textLightGray
        barchart.doubleTapToZoomEnabled = false
    }
    
    func setChartAttribute(_ data: [History]) {
        layout_barchart.contentLayoutGuide.snp.updateConstraints { make in
            make.width.equalTo(54 * data.count + 16)
        }
        
        var dateArr = [String]()
        for i in 0..<data.count {
            let entry = BarChartDataEntry(x: Double(i), y: Double(data[i].time))
            chartEntry.append(entry)
            
            let str = data[i].date
            dateArr.append(str.dateFormat(startOffset: 5, endOffset: 10, replacer: "/"))
        }
        barchart.leftAxis.enabled = false
        barchart.rightAxis.enabled = false
        barchart.leftAxis.axisMinimum = 0
        barchart.rightAxis.axisMaximum = 1000
        barchart.legend.enabled = false

        barchart.xAxis.labelPosition = .bottom
        barchart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArr)
        barchart.xAxis.setLabelCount(data.count, force: false)
        barchart.xAxis.drawGridLinesEnabled = false
        barchart.xAxis.drawAxisLineEnabled = false

        let dataSet = BarChartDataSet(entries: chartEntry, label: "")
        dataSet.colors = [.lightLightOrange]
        dataSet.highlightEnabled = false
        dataSet.drawValuesEnabled = true
        dataSet.valueFont = .suit(size: 11, weight: .w600)
        dataSet.valueColors = [.textOrange]
        
        let data = BarChartData(dataSet: dataSet)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.minimumFractionDigits = 0
        let formatter = DefaultValueFormatter(formatter: numberFormatter)
        barchart.data = data
        data.setValueFormatter(formatter)
    }
}
