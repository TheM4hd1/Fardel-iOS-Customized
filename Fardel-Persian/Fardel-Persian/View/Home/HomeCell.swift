//
//  HomeCell.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/15/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import Kingfisher

protocol HomeCellDelegate {
    func didReadMorePressed(postId: Int)
}
class HomeCell: UICollectionViewCell {
    
    var delegate: HomeCellDelegate?
    private var content: NSMutableAttributedString?
    var post: Post? {
        didSet {
            if let post = post {
                let postContent = NSMutableAttributedString(string: "\(post.category)\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.lightGray])
                postContent.append(NSAttributedString(string: "\(post.title)\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.darkText]))
                postContent.append(NSAttributedString(string: "\(post.summarized)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.darkGray]))
                
                self.content = postContent
                self.contentTextView.attributedText = postContent
            }
        }
    }
    
    private lazy var contentTextView: UITextView = {
        let text = UITextView()
        text.isScrollEnabled = false
        text.isEditable = false
        text.textAlignment = .right
        return text
    }()
    
    private lazy var imagePost: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "photo_not_found").withRenderingMode(.alwaysOriginal))
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .lightGray
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    private lazy var imagePostContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.dropShadow()
        return view
    }()
    
    private lazy var sepratorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.fromRgb(red: 230, green: 230, blue: 230)
        return line
    }()
    
    private lazy var btnReadMore: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("ادامه", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.backgroundColor = UIColor.fromRgb(red: 51, green: 153, blue: 255)
        // to create an oval button, we should set cornerRadius to 1/2 height
        // becuase we have a fixed height(30) we just set it to 15.
        btn.layer.cornerRadius = 15
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(btnReadMorePressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var labelTime:  UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 8
        addSubview(contentTextView)
        
        // FIXME: init first constraint
        if #available(iOS 11.0, *) {
            contentTextView.anchorManual(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        } else {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        alpha = 0
        
        // FIXME: Clean and redrawing subviews
        contentTextView.removeFromSuperview()
        
        // FIXME: Adding Data
        
        guard let post = post else { return }
        contentTextView.attributedText = content
        contentTextView.textAlignment = .right
        setImage(url: post.image)
        let date = Date(timeIntervalSince1970: TimeInterval(post.createdTime)).timeAgoSinceNow()
        labelTime.text = date
        
        //==========================================================//
        // TODO: Add Subviews
        
        addSubview(imagePostContainerView)
        imagePostContainerView.addSubview(imagePost)
        addSubview(contentTextView)
        addSubview(sepratorLine)
        addSubview(btnReadMore)
        addSubview(labelTime)
        
        //==========================================================//
        // TODO: Setup Constraints
        
        if #available(iOS 11.0, *) {
            
            imagePostContainerView.anchorManual(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
            imagePostContainerView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
            imagePost.anchorManual(top: imagePostContainerView.topAnchor, left: imagePostContainerView.leftAnchor, bottom: imagePostContainerView.bottomAnchor, right: imagePostContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            contentTextView.anchorManual(top: imagePostContainerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
            sepratorLine.anchorManual(top: contentTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
            btnReadMore.anchorManual(top: sepratorLine.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 30)
            labelTime.anchorManual(top: sepratorLine.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 90, height: 30)
            
        } else {
            
        }
        
        //==========================================================//
        // TODO: Active Animation
        
        UIView.animate(withDuration: 1) {
            self.alpha = 1
        }
    }
    
    fileprivate func setImage(url: String) {
        
        // TODO: Download Image
        if !url.isEmpty {
            let imageUrl = URL(string: "\(BASE_URL)\(url)")
            imagePost.kf.setImage(with: imageUrl)
        } else {
            imagePost.contentMode = .scaleAspectFit
        }
    }
    
    @objc fileprivate func btnReadMorePressed() {
        if let post = post {
            delegate?.didReadMorePressed(postId: post.id)
        }
    }
}
