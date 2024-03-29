//
//  PostDetailViewController.swift
//  BookMark
//
//  Created by Jin younkyum on 2023/01/31.
//

import UIKit

//// MARK: - 게시글 확인 view controller
//class PostDetailViewController: UIViewController {
//    let network = Network()
//    let layout_postDetail = PostDetailView()
//    let layout_textField = TextFieldView()
//    var postID: Int = 1
//    var textViewYValue = CGFloat(15)
//
//    private var imgStatus: String = "1"
//    private var profileImg: String?
//    private var postImg: String?
//    private var postTitle: String?
//    private var postContent: String?
//    private var userName: String?
//    private var likeNum: Int?
//    private var commentNum: Int?
//    private var comment = [[String]]()    // [이름, 댓글 내용]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        getPostDetailData()
//
//        layout_postDetail.initView(view: self.view)
//        layout_textField.initView(view: self.view)
//        layout_textField.btn_send.addTarget(self, action: #selector(didTapSendCommentButton), for: .touchUpInside)
//        layout_postDetail.layout_postDetail.delegate = self
//        layout_postDetail.layout_postDetail.dataSource = self
//
//        setNavCustom()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//
//    func setNavCustom() {
//        self.setNavigationCustom(title: "")
//        self.setNavigationImageButton(imageName: ["seeMore"], action: [#selector(removePostButton)])
//    }
//}
//
//// MARK: - button delegate 용 extension
//extension PostDetailViewController {
//    @objc func removePostButton(_ sender: UIBarButtonItem) {
//        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//        let report = UIAlertAction(title: "신고하기", style: .default)
//        let remove = UIAlertAction(title: "삭제하기", style: .default, handler: { _ in
//            // MARK: - todo 삭제 로직 구현
//            self.view.makeToast("삭제되었습니다.", duration: 2, position: .bottom)
//
//        })
//        let announce = UIAlertAction(title: "공지로 등록하기", style: .default, handler: { _ in
//            self.view.makeToast("공지로 등록되었습니다.", duration: 2, position: .bottom)
//        })
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//        alert.addAction(report)
//        alert.addAction(remove)
//        alert.addAction(announce)
//        alert.addAction(cancel)
//        self.present(alert, animated: true)
//    }
//
//    @objc func didTapSendCommentButton(_ sender: UIButton) {
//        if (self.layout_textField.layout_textField.hasText), let txt = self.layout_textField.layout_textField.text {
//            self.postComment(text: txt)
//        }
//        self.view.endEditing(true)
//        self.layout_textField.layout_textField.text = ""
//    }
//
//    @objc func keyboardUp(_ sender: NSNotification) {
//        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//
//             UIView.animate(
//                 withDuration: 0
//                 , animations: {
//                     self.layout_textField.layout_coner.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height - 20 + self.view.safeAreaInsets.bottom)
//                 }
//             )
//         }
//    }
//
//    @objc func keyboardDown(_ sender: NSNotification) {
//        self.layout_textField.layout_coner.transform = .identity
//    }
//}
//
//// MARK: - TableviewDelegate 용 extension
//extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//
//            if (self.postImg == "") {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: MainPostCell.identifier, for: indexPath) as? MainPostCell else { return MainPostCell() }
//
//                guard let img_url = self.profileImg, let postTitle = self.postTitle, let postContent = self.postContent, let userName = self.userName, let likeCount = self.likeNum, let commentCount = self.commentNum else {
//                    return cell}
//
//                cell.layout_userImg.setImageUrl(url: img_url)
//                cell.label_author.text = userName
//                cell.label_title.text = postTitle
//                cell.label_context.text = postContent
//                cell.label_heart.text = "\(likeCount)"
//                cell.label_comment.text = "\(commentCount)"
//                cell.likeCallbackMehtod = { [weak self] result in
//                    self?.postLikeStatus(likes: result)
//                }
//
//                return cell
//            }
//            else {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: MainPictureCell.identifier, for: indexPath) as? MainPictureCell else { return MainPictureCell() }
//
//                guard let img_url = self.profileImg, let postTitle = self.postTitle, let postImg = self.postImg, let postContent = self.postContent, let userName = self.userName, let likeCount = self.likeNum, let commentCount = self.commentNum  else
//                {
//                    return cell}
//
//                cell.layout_userImg.setImageUrl(url: img_url)
//                cell.label_author.text = userName
//                cell.label_title.text = postTitle
//                cell.layout_postImg.setImageUrl(url: postImg)
//                cell.label_context.text = postContent
//                cell.label_heart.text = "\(likeCount)"
//                cell.label_comment.text = "\(commentCount)"
//                cell.likeCallbackMehtod = { [weak self] result in
//                    self?.postLikeStatus(likes: result)
//                }
//                return cell
//            }
//
//
//        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identfier, for: indexPath) as? CommentCell else { return CommentCell() }
//
//            cell.label_author.text = self.comment[indexPath.row - 1][0]
//            cell.label_context.text = self.comment[indexPath.row - 1][1]
//            cell.layout_userImg.setImageUrl(url: self.comment[indexPath.row - 1][2])
//
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.comment.count + 1
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.view.endEditing(true)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            if (!(self.postImg == "")) {
//                return 430
//            } else {
//                return 200
//            }
//
//        } else {
//            return 85
//        }
//    }
//
//}
//
//// MARK: - 네트워크 용 extension
//extension PostDetailViewController {
//    func getPostDetailData() {
////        network.getCommunityPost(postID: self.postID, completion: { response in
////            switch response {
////            case .success(let data):
////                guard let post = (data as? CommunityPost), let comment = (data as? CommunityPost)?.CommentData else {return}
////
////                self.imgStatus = post.img_status
////                self.profileImg = (post.img_url ?? "")
////                self.postImg = (post.post_img_url ?? "")
////                self.postTitle = post.club_post_title
////                self.postContent = post.post_content_text
////                self.userName = post.user_name
////                self.likeNum = post.like_num
////                self.commentNum = post.comment_num
////
////                comment.forEach { item in
////                    self.comment.append([item.user_name, item.comment_content_text, item.img_url ?? ""])
////                }
////
////                self.layout_postDetail.layout_postDetail.reloadData()
////            default:
////                print("failed get post detail data")
////            }
////        })
//    }
//
//    func postLikeStatus(likes: Int) {
////        network.postCommunityPostLikeStatus(clubPostID: self.postID, userID: UserInfo.shared.userID, likeStatus: likes, completion: { res in
////            switch res {
////            case .success:
////                return
////            default:
////                print("failed update like status")
////            }
////        })
//    }
//
//    func postComment(text: String) {
////        network.postCommunityPostComment(clubPostID: self.postID, userID: UserInfo.shared.userID, comment: text, completion: { response in
////            switch response {
////            case .success(let data):
////                guard let comment = (data as? CommunityPost)?.CommentData else {return}
////                self.comment.removeAll()
////                comment.forEach { item in
////                    self.comment.append([item.user_name, item.comment_content_text, item.img_url ?? ""])
////                }
////                self.layout_postDetail.layout_postDetail.reloadData()
////            default:
////                print("failed get post detail data")
////            }
////        })
//    }
//}
//
//class PostDetailView {
//    var layout_postDetail : UITableView = {
//        let layout_postDetail = UITableView()
//        layout_postDetail.translatesAutoresizingMaskIntoConstraints = false
//        layout_postDetail.register(MainPostCell.self, forCellReuseIdentifier: MainPostCell.identifier)
//        layout_postDetail.register(MainPictureCell.self, forCellReuseIdentifier: MainPictureCell.identifier)
//        layout_postDetail.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identfier)
//
//        layout_postDetail.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        return layout_postDetail
//    }()
//
//    func initView(view : UIView) {
//        view.addSubview(layout_postDetail)
//
//        layout_postDetail.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//}
//
//class TextFieldView {
//    let layout_textField = UITextField()
//    let btn_send = UIButton()
//    let layout_coner = UIView()
//
//    func initView(view : UIView) {
//        view.addSubviews(layout_coner)
//        layout_coner.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(15)
//            make.right.equalToSuperview().offset(-15)
//            make.height.equalTo(50)
//            make.bottom.equalToSuperview().offset(-34)
//        }
//        layout_coner.backgroundColor = .white
//        layout_coner.layer.cornerRadius = 25
//        layout_coner.layer.borderWidth = 1
//        layout_coner.layer.borderColor = UIColor.textGray.cgColor
//
//        layout_coner.addSubviews(btn_send, layout_textField)
//
//        btn_send.snp.makeConstraints { make in
//            make.height.width.equalTo(38)
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-6)
//        }
//        btn_send.layer.cornerRadius = 19
//        btn_send.setImage(UIImage(named: "comment_send"), for: .normal)
//
//        layout_textField.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(19)
//            make.right.equalTo(btn_send.snp.left).offset(2)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(19)
//        }
//        layout_textField.placeholder = "댓글을 입력하세요."
//        layout_textField.font = .systemFont(ofSize: 15)
//        layout_textField.textAlignment = .natural
//    }
//}
//
//class MainPictureCell: UITableViewCell {
//    static let identifier = "mainPictueCell"
//    let layout_userImg = UIImageView()
//    let layout_postImg = UIImageView()
//    let label_author = UILabel()
//    let label_time = UILabel()
//    let label_title = UILabel()
//    let label_context = UILabel()
//    let btn_heart = UIButton()
//    let label_heart = UILabel()
//    let layout_comment = UIImageView()
//    let label_comment = UILabel()
//    var likeCallbackMehtod: ((Int) -> Void)?
//    var likeStatus: Int = 0
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = .none
//        self.contentView.addSubviews(layout_userImg, label_author, label_time, label_title, label_context, btn_heart, label_heart, layout_comment, label_comment, layout_postImg)
//
//        layout_userImg.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(18)
//            make.left.equalToSuperview().offset(23)
//            make.width.equalTo(35)
//            make.height.equalTo(35)
//        }
//        layout_userImg.image = UIImage(named: "haerin.jpg")
//        layout_userImg.clipsToBounds = true
//        layout_userImg.layer.cornerRadius = 17.5
//        layout_userImg.backgroundColor = .gray
//
//        label_author.snp.makeConstraints { make in
//            make.top.equalTo(layout_userImg)
//            make.left.equalTo(layout_userImg.snp.right).offset(9)
//            make.height.equalTo(16)
//            make.right.equalToSuperview().offset(23)
//        }
//        label_author.text = "이름없음"
//        label_author.textColor = .black
//        label_author.font = .systemFont(ofSize: 13)
//        label_author.textAlignment = .natural
//
//        label_time.snp.makeConstraints { make in
//            make.bottom.equalTo(layout_userImg)
//            make.height.equalTo(11)
//            make.left.equalTo(label_author)
//        }
//        label_time.text = "1/31 03:25"
//        label_time.textColor = .textGray
//        label_time.font = .systemFont(ofSize: 11)
//
//        label_title.snp.makeConstraints { make in
//            make.top.equalTo(label_time.snp.bottom).offset(13)
//            make.left.equalTo(layout_userImg)
//            make.right.equalToSuperview().offset(23)
//        }
//        label_title.text = "제목이 없습니다."
//        label_title.font = .boldSystemFont(ofSize: 17)
//        label_title.textColor = .black
//        label_title.lineBreakStrategy = .standard
//        label_title.numberOfLines = 0
//        label_title.textAlignment = .natural
//
//        layout_postImg.snp.makeConstraints { make in
//            make.top.equalTo(label_title.snp.bottom).offset(7)
//            make.left.equalToSuperview().offset(30)
//            make.right.equalToSuperview().offset(-30)
//            make.height.equalTo(200)
//        }
//        layout_postImg.contentMode = .scaleAspectFit
//
//        label_context.snp.makeConstraints { make in
//            make.top.equalTo(layout_postImg.snp.bottom).offset(9)
//            make.left.equalTo(layout_userImg)
//            make.right.equalToSuperview().offset(23)
//        }
//        label_context.numberOfLines = 0
//        label_context.font = .systemFont(ofSize: 12)
//        label_context.textColor = .black
//        label_context.text = "내용이 없습니다."
//        label_title.lineBreakStrategy = .standard
//        label_title.textAlignment = .natural
//
//        btn_heart.snp.makeConstraints { make in
//            make.left.equalTo(layout_userImg)
//            make.top.equalTo(label_context.snp.bottom).offset(31)
//            make.width.equalTo(21)
//            make.height.equalTo(21)
//        }
//        btn_heart.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
//        btn_heart.setImage(UIImage(named: "heart_unfill"), for: .normal)
//
//        label_heart.snp.makeConstraints { make in
//            make.centerY.equalTo(btn_heart)
//            make.left.equalTo(btn_heart.snp.right).offset(2)
//        }
//        label_heart.text = "0"
//        label_heart.textColor = .red
//        label_heart.font = .systemFont(ofSize: 11)
//        label_heart.textAlignment = .natural
//
//        layout_comment.snp.makeConstraints { make in
//            make.centerY.equalTo(btn_heart)
//            make.left.equalTo(label_heart.snp.right).offset(5)
//            make.width.height.equalTo(21)
//        }
//        layout_comment.image = UIImage(named: "balloon")
//
//        label_comment.snp.makeConstraints { make in
//            make.centerY.equalTo(btn_heart)
//            make.left.equalTo(layout_comment.snp.right).offset(3)
//        }
//        label_comment.text = "0"
//        label_comment.textColor = .black
//        label_comment.font = .systemFont(ofSize: 11)
//        label_comment.textAlignment = .natural
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc func didTapLikeButton(_ sender: UIButton) {
//        let value = Int(self.label_heart.text ?? "0") ?? 0
//        if (self.likeStatus == 0) {
//            self.likeStatus = 1
//            self.label_heart.text = "\(value + 1)"
//            sender.setImage(UIImage(named: "heart_fill"), for: .normal)
//        }
//        else {
//            self.likeStatus = 0
//            sender.setImage(UIImage(named: "heart_unfill"), for: .normal)
//            if (value - 1 >= 0) {
//                self.label_heart.text = "\(value - 1)"
//            }
//        }
//        self.likeCallbackMehtod?(self.likeStatus)
//    }
//
//}
//
//
//
//
//class MainPostCell: UITableViewCell {
//
//    static let identifier = "mainCell"
//    let layout_userImg = UIImageView()
//    let label_author = UILabel()
//    let label_time = UILabel()
//    let label_title = UILabel()
//    let label_context = UILabel()
//    let btn_heart = UIButton()
//    let label_heart = UILabel()
//    let layout_comment = UIImageView()
//    let label_comment = UILabel()
//    var likeCallbackMehtod: ((Int) -> Void)?
//    var likeStatus: Int = 0
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = .none
//        self.contentView.addSubviews(layout_userImg, label_author, label_time, label_title, label_context, btn_heart, label_heart, layout_comment, label_comment)
//
//        layout_userImg.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(18)
//            make.left.equalToSuperview().offset(23)
//            make.width.equalTo(35)
//            make.height.equalTo(35)
//        }
//        layout_userImg.image = UIImage(named: "noProfileImg")
//        layout_userImg.clipsToBounds = true
//        layout_userImg.layer.cornerRadius = 17.5
//        layout_userImg.backgroundColor = .gray
//
//        label_author.snp.makeConstraints { make in
//            make.top.equalTo(layout_userImg)
//            make.left.equalTo(layout_userImg.snp.right).offset(9)
//            make.height.equalTo(16)
//            make.right.equalToSuperview().offset(23)
//        }
//        label_author.text = "이름없음"
//        label_author.textColor = .black
//        label_author.font = .systemFont(ofSize: 13)
//        label_author.textAlignment = .natural
//
//        label_time.snp.makeConstraints { make in
//            make.bottom.equalTo(layout_userImg)
//            make.height.equalTo(11)
//            make.left.equalTo(label_author)
//        }
//        label_time.text = "1/31 03:25"
//        label_time.textColor = .textGray
//        label_time.font = .systemFont(ofSize: 11)
//
//        label_title.snp.makeConstraints { make in
//            make.top.equalTo(label_time.snp.bottom).offset(13)
//            make.left.equalTo(layout_userImg)
//            make.right.equalToSuperview().offset(23)
//        }
//        label_title.text = "제목이 없습니다."
//        label_title.font = .boldSystemFont(ofSize: 17)
//        label_title.textColor = .black
//        label_title.lineBreakStrategy = .standard
//        label_title.numberOfLines = 0
//        label_title.textAlignment = .natural
//
//        label_context.snp.makeConstraints { make in
//            make.top.equalTo(label_title.snp.bottom).offset(9)
//            make.left.equalTo(layout_userImg)
//            make.right.equalToSuperview().offset(23)
//        }
//        label_context.numberOfLines = 0
//        label_context.font = .systemFont(ofSize: 12)
//        label_context.textColor = .black
//        label_context.text = "내용이 없습니다."
//        label_title.lineBreakStrategy = .standard
//        label_title.textAlignment = .natural
//
//        btn_heart.snp.makeConstraints { make in
//            make.left.equalTo(layout_userImg)
//            make.top.equalTo(label_context.snp.bottom).offset(31)
//            make.width.equalTo(21)
//            make.height.equalTo(21)
//        }
//        btn_heart.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
//        btn_heart.setImage(UIImage(named: "heart_unfill"), for: .normal)
//
//        label_heart.snp.makeConstraints { make in
//            make.centerY.equalTo(btn_heart)
//            make.left.equalTo(btn_heart.snp.right).offset(2)
//        }
//        label_heart.text = "0"
//        label_heart.textColor = .red
//        label_heart.font = .systemFont(ofSize: 11)
//        label_heart.textAlignment = .natural
//
//        layout_comment.snp.makeConstraints { make in
//            make.centerY.equalTo(btn_heart)
//            make.left.equalTo(label_heart.snp.right).offset(5)
//            make.width.height.equalTo(21)
//        }
//        layout_comment.image = UIImage(named: "balloon")
//
//        label_comment.snp.makeConstraints { make in
//            make.centerY.equalTo(btn_heart)
//            make.left.equalTo(layout_comment.snp.right).offset(3)
//        }
//        label_comment.text = "0"
//        label_comment.textColor = .black
//        label_comment.font = .systemFont(ofSize: 11)
//        label_comment.textAlignment = .natural
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc func didTapLikeButton(_ sender: UIButton) {
//        let value = Int(self.label_heart.text ?? "0") ?? 0
//        if (self.likeStatus == 0) {
//            self.likeStatus = 1
//            self.label_heart.text = "\(value + 1)"
//            sender.setImage(UIImage(named: "heart_fill"), for: .normal)
//        }
//        else {
//            self.likeStatus = 0
//            sender.setImage(UIImage(named: "heart_unfill"), for: .normal)
//            if (value - 1 >= 0) {
//                self.label_heart.text = "\(value - 1)"
//            }
//        }
//        self.likeCallbackMehtod?(self.likeStatus)
//    }
//}
//
//class CommentCell: UITableViewCell {
//    static let identfier = "commentCell"
//    let layout_userImg = UIImageView()
//    let label_author = UILabel()
//    let label_context = UILabel()
//    let label_time = UILabel()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = .none
//        addSubviews(layout_userImg, label_author, label_context, label_time)
//
//        layout_userImg.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(14)
//            make.left.equalToSuperview().offset(23)
//            make.width.height.equalTo(29)
//        }
//        layout_userImg.image = UIImage(named: "pepe.jpg")
//        layout_userImg.clipsToBounds = true
//        layout_userImg.backgroundColor = .gray
//        layout_userImg.layer.cornerRadius = 14.5
//
//        label_author.snp.makeConstraints { make in
//            make.centerY.equalTo(layout_userImg)
//            make.left.equalTo(layout_userImg.snp.right).offset(8)
//            make.right.equalToSuperview().inset(23)
//        }
//        label_author.text = "댓글 작성자"
//        label_author.font = .systemFont(ofSize: 13)
//        label_author.textColor = .black
//        label_author.textAlignment = .left
//
//        label_context.snp.makeConstraints { make in
//            make.left.right.equalTo(label_author)
//            make.top.equalTo(label_author.snp.bottom).offset(8)
//        }
//        label_context.text = "댓글 예시입니다. 댓글 예시입니다."
//        label_context.textColor = .black
//        label_context.font = .systemFont(ofSize: 12)
//        label_context.textAlignment = .natural
//        label_context.lineBreakMode = .byTruncatingTail
//        label_context.numberOfLines = 0
//
//        label_time.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-23)
//            make.top.equalTo(label_context.snp.bottom).offset(8)
//        }
//        label_time.text = "01/20 04:05"
//        label_time.textColor = .textGray
//        label_time.font = .systemFont(ofSize: 11)
//        label_time.textAlignment = .right
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
