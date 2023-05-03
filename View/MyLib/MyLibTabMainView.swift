//
//  MyLibTabMainView.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/01/08.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

// MARK: - 나의 서재 탭
class MyLibTabMainView: UIViewController {
    let layout_main = MyLibTabView()
    let layout_fail = NetworkFailMainView()
    var viewModel = MyLibTabMainViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(didTapPanGesture))
        layout_main.layout_submain.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    
        setUpCollectionBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        disposeBag = DisposeBag()
    }
    
    private func setupBindings() {
        //         layout_fail.initViews(superView: self.view)
        layout_main.initViews(superView: self.view)
        
        viewModel.userBackgroundImg
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.img_background.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.userName
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.label_name.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userImg
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.img_profile.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.follower
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.label_follwerCount.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.following
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.label_followingCount.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.streak
            .observe(on: MainScheduler.instance)
            .map { Int($0) ?? 0 }
            .filter { $0 > 0 }
            .map { "연속 \($0)일째 읽고 있어요!" }
            .subscribe(onNext: { res in
                self.layout_main.label_streaks.isHidden = false
                self.layout_main.label_streaks.text = res
            })
            .disposed(by: disposeBag)
        
        viewModel.readCount
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.label_bookCount.rx.text, self.layout_main.label_bookcount.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setUpCollectionBinding() {
        viewModel.books
            .observe(on: MainScheduler.instance)
            .bind(to: self.layout_main.layout_books.rx.items(cellIdentifier: BookCollectionCell.identifier, cellType: BookCollectionCell.self)) { idx, item, cell in
                
                if (item.book_id == "") {
                    cell.layout_img.image = UIImage(named: "addBook")
                }
                else {
                    cell.layout_img.setImageUrl(url: item.titleImage)
                }

                cell.label_title.text = item.title
                cell.label_author.text = item.authors[0]
                cell.bookID = item.book_id
                cell.tag = idx
            }
            .disposed(by: disposeBag)
        
        self.layout_main.layout_books.rx
            .itemSelected
            .bind(onNext: { [weak self] indexpath in
                let cell = self?.layout_main.layout_books.cellForItem(at: indexpath) as? BookCollectionCell
                
                switch cell?.bookID {
                case "":
                    self?.navigationController?.pushViewControllerTabHidden(ConfirmBookViewController(), animated: true)
                default:
                    guard let id = cell?.bookID else {return}
                    let vc = BookDetailViewController(bookId: id)
                    self?.navigationController?.pushViewControllerTabHidden(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func didTapPanGesture(_ sender: UIPanGestureRecognizer) {
        guard let senderView = sender.view else {
            return
        }
        
        let transition = sender.translation(in: self.view)
        let changedY = senderView.center.y + transition.y
        
        if (changedY <= self.view.center.y) {
            self.layout_main.layout_title.isHidden = false
            self.layout_main.label_title.textColor = .black
        }
        else {
            self.layout_main.layout_title.isHidden = true
            self.layout_main.label_title.textColor = .white
        }
        
        if (changedY >= 280 && changedY <= 143 + self.layout_main.layout_submain.frame.height / 2) {
            senderView.center = CGPoint(x: senderView.center.x, y: senderView.center.y + transition.y)
            sender.setTranslation(.zero, in: self.view)
        }
    }
}

// MARK: - layout class
class MyLibTabView {
    var layout_main = UIView()
    
    let layout_title = UIView()
    let label_title = UILabel()
    let line = UIView()
    let img_background = UIImageView()
    
    let layout_submain = UIView()
    var layout_profile = UIView()
    var img_profile = UIImageView()
    var label_name = UILabel()
    
    let label_streaks = UILabel()
    var label_books = UILabel()
    var label_bookCount = UILabel()
    var label_follwer = UILabel()
    var label_follwerCount = UILabel()
    var label_follwing = UILabel()
    var label_followingCount = UILabel()
    
    var label_mylib = UILabel()
    var label_bookcount = UILabel()
    var layout_books: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 104, height: 184)
        
        let layout_books = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout_books.backgroundColor = .white
        layout_books.register(BookCollectionCell.self, forCellWithReuseIdentifier: "BookCollectionCell")
        layout_books.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 67, right: 8)
        layout_books.translatesAutoresizingMaskIntoConstraints = false
        
        return layout_books
    }()
    
    func initViews(superView: UIView) {
        superView.addSubview(layout_main)
    
        layout_main.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        layout_main.addSubviews(layout_title, label_title, img_background, layout_submain)
        
        label_title.snp.makeConstraints() { make in
            make.top.equalTo(superView.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(23)
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
        label_title.setTxtAttribute("책갈피 : 나의 서재", size: 18, weight: .w500, txtColor: .white)
        label_title.layer.zPosition = 999
        
        layout_title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(label_title)
        }
        layout_title.backgroundColor = .white
        layout_title.layer.zPosition = 999
        layout_title.isHidden = true
        
        layout_title.addSubviews(line)
        line.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        line.backgroundColor = UIColor(Hex: 0xD5D5D5)
        
        img_background.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(175)
        }
        img_background.backgroundColor = .lightOrange
        
        layout_submain.snp.makeConstraints { make in
            make.top.equalTo(label_title.snp.bottom).offset(52)
            make.leading.trailing.bottom.equalToSuperview()
        }
        layout_submain.layer.shadowColor = UIColor.black.cgColor
        layout_submain.layer.shadowRadius = 3
        layout_submain.layer.shadowOffset = CGSize(width: 2, height: 5)
        layout_submain.backgroundColor = .white
        layout_submain.clipsToBounds = false
        layout_submain.layer.cornerRadius = 20
        layout_submain.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        layout_submain.addSubviews(layout_profile, label_name, label_streaks, label_books, label_bookCount, label_follwer, label_follwerCount, label_follwing, label_followingCount, label_mylib, label_bookcount, layout_books)
        
        layout_profile.snp.makeConstraints() { make in
            make.centerY.equalTo(layout_submain.snp.top)
            make.centerX.equalToSuperview()
            make.size.equalTo(75)
        }
        layout_profile.layer.cornerRadius = 75 / 2.0
        layout_profile.translatesAutoresizingMaskIntoConstraints = false
        
        layout_profile.addSubview(img_profile)
        img_profile.snp.makeConstraints() { make in
            make.size.equalTo(75)
            make.center.equalToSuperview()
        }
        img_profile.layer.cornerRadius = 75 / 2.0
        img_profile.image = UIImage(named: "noProfileImg")
        img_profile.clipsToBounds = true
        img_profile.translatesAutoresizingMaskIntoConstraints = false
        
        label_name.snp.makeConstraints() { make in
            make.top.equalTo(layout_profile.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        label_name.setTxtAttribute("김독서", size: 15, weight: .w500, txtColor: .black)
        
        label_streaks.snp.makeConstraints { make in
            make.top.equalTo(label_name.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        label_streaks.setTxtAttribute("연속 0일째 읽고 있어요!", size: 10, weight: .w500, txtColor: .textOrange)
        label_streaks.isHidden = true
        
        label_follwerCount.snp.makeConstraints() { make in
            make.top.equalTo(label_name.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
        label_follwerCount.setTxtAttribute("0", size: 18, weight: .w600, txtColor: .black)
        
        label_follwer.snp.makeConstraints() { make in
            make.top.equalTo(label_follwerCount.snp.bottom).offset(5)
            make.centerX.equalTo(label_follwerCount)
        }
        label_follwer.setTxtAttribute("팔로워", size: 13, weight: .w500, txtColor: UIColor(Hex: 0x555555))
        
        label_bookCount.snp.makeConstraints() { make in
            make.trailing.equalTo(label_follwerCount.snp.leading).offset(-72)
            make.top.equalTo(label_follwerCount)
        }
        label_bookCount.setTxtAttribute("0", size: 18, weight: .w600, txtColor: .black)
        
        label_books.snp.makeConstraints() { make in
            make.top.equalTo(label_follwer)
            make.centerX.equalTo(label_bookCount)
        }
        label_books.setTxtAttribute("읽은 책", size: 13, weight: .w500, txtColor: UIColor(Hex: 0x555555))
        
        label_followingCount.snp.makeConstraints() { make in
            make.leading.equalTo(label_follwerCount.snp.trailing).offset(72)
            make.top.equalTo(label_follwerCount)
        }
        label_followingCount.setTxtAttribute("0", size: 18, weight: .w600, txtColor: .black)
        
        label_follwing.snp.makeConstraints() { make in
            make.top.equalTo(label_follwer)
            make.centerX.equalTo(label_followingCount)
        }
        label_follwing.setTxtAttribute("팔로잉", size: 13, weight: .w500, txtColor: UIColor(Hex: 0x555555))
        
        label_mylib.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(23)
            make.top.equalTo(label_follwing.snp.bottom).offset(42)
        }
        label_mylib.setTxtAttribute("나의 서재", size: 17, weight: .w600, txtColor: .black)
        
        label_bookcount.snp.makeConstraints() { make in
            make.leading.equalTo(label_mylib.snp.trailing).offset(5)
            make.centerY.equalTo(label_mylib)
        }
        label_bookcount.setTxtAttribute("0", size: 14, weight: .w500, txtColor: .textLightGray)
        
        layout_books.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(label_mylib.snp.bottom).offset(18)
            make.height.equalTo(superView.frame.height - 104)
        }
    }
}

// MARK: - scroll view cell class
class BookCollectionCell: UICollectionViewCell {
    static let identifier = "BookCollectionCell"
    var bookID: String = ""
    let layout_img = UIImageView()
    let label_title = UILabel()
    let label_author = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(layout_img, label_title, label_author)
        layout_img.snp.makeConstraints() { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(104)
            make.height.equalTo(139)
        }
        layout_img.backgroundColor = .lightLightGray
        layout_img.layer.cornerRadius = 3
        layout_img.clipsToBounds = true
        
        label_title.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(4)
            make.top.equalTo(layout_img.snp.bottom).offset(7)
            make.width.equalTo(103)
            make.height.equalTo(19)
        }
        label_title.setTxtAttribute("제목", size: 15, weight: .w600, txtColor: .black)
        label_title.lineBreakMode = .byTruncatingTail
        
        label_author.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(4)
            make.top.equalTo(label_title.snp.bottom).offset(1)
            make.width.equalTo(103)
            make.height.equalTo(15)
        }
        label_author.setTxtAttribute("작가", size: 12, weight: .w500, txtColor: .textGray)
        label_author.lineBreakMode = .byTruncatingTail
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
