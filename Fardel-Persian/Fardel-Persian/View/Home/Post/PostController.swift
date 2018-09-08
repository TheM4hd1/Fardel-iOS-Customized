//
//  PostController.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/19/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import MaterialComponents
import WebKit
import Kingfisher

class PostController: UIViewController {
    
    private var post: Post?
    var postId: Int?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        return scrollView
    }()
    
    private lazy var imagePost: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "photo_not_found"))
        image.alpha = 0
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var defaultPadding: CGFloat = {
        let padding = view.frame.width - 16
        return padding
    }()
    
    private lazy var labelCategory: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var labelTime: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator()
        indicator.cycleColors = [.red, UIColor.fromRgb(red: 68, green: 110, blue: 212)]
        return indicator
    }()
    
    private lazy var alertView: UIView = {
        let alert = UIView()
        alert.alpha = 0
        alert.backgroundColor = #colorLiteral(red: 1, green: 0.2064451283, blue: 0.2974684767, alpha: 1)
        alert.isHidden = true
        return alert
    }()
    
    private lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.text = "عدم ارتباط با سرور"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        btn.isEnabled = false
        btn.alpha = 0
        btn.setImage(#imageLiteral(resourceName: "baseline_refresh_black_24pt_"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var webKit: WKWebView = {
        let webkit = WKWebView()
        webkit.isHidden = true
        return webkit
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func updateData() {
        activityIndicator.startAnimating()
        APIService.request.getPost(postId: postId!) { (success, message, post) in
            if success {
                
                self.post = post
                self.setImage(url: post.image)
                self.labelCategory.text = post.category
                self.labelTime.text = Date().getTime(timestamp: post.updateTime)
                self.labelTitle.text = post.title
                self.webKit.loadHTMLString(post.content, baseURL: nil)
                self.activityIndicator.stopAnimating()
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.imagePost.alpha = 1
                    self.labelCategory.alpha = 1
                    self.labelTime.alpha = 1
                    self.labelTitle.alpha = 1
                })
            } else {
                
                self.activityIndicator.stopAnimating()
                self.scrollView.isHidden = true
                self.alertView.isHidden = false
                self.refreshButton.isHidden = false
                self.refreshButton.isEnabled = true
                self.alertLabel.text = message
                
                UIView.animate(withDuration: 1, animations: {
                    self.alertView.alpha = 1
                    self.refreshButton.alpha = 1
                })
            }
        }
    }
    
    fileprivate func setupViews() {
        
        // TODO: Customize View
        
        view.backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        
        //==========================================================//
        // TODO: Add Subviews
        
        view.addSubview(scrollView)
        view.addSubview(alertView)
        view.addSubview(refreshButton)
        alertView.addSubview(alertLabel)
        scrollView.addSubview(imagePost)
        scrollView.addSubview(labelCategory)
        scrollView.addSubview(labelTime)
        scrollView.addSubview(labelTitle)
        scrollView.addSubview(activityIndicator)
        scrollView.addSubview(webKit)
        
        
        //==========================================================//
        // TODO: Setup Constraints
        
        if #available(iOS 11.0, *) {
            
            scrollView.anchorManual(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            alertView.anchorManual(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
            alertLabel.anchorManual(top: alertView.topAnchor, left: alertView.leftAnchor, bottom: alertView.bottomAnchor, right: alertView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            NSLayoutConstraint.activate([refreshButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                         refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         refreshButton.widthAnchor.constraint(equalToConstant: 30),
                                         refreshButton.heightAnchor.constraint(equalToConstant: 30)])
            
            imagePost.anchorManual(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            imagePost.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
            labelCategory.anchorManual(top: imagePost.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: defaultPadding, height: 0)
            labelTime.anchorManual(top: labelCategory.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: defaultPadding, height: 0)
            labelTitle.anchorManual(top: labelTime.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: defaultPadding, height: 0)
            activityIndicator.anchorManual(top: labelTitle.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            webKit.anchorManual(top: labelTitle.bottomAnchor, left: scrollView.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: defaultPadding, height: 0)
        } else {
            
        }
        
        // FIXME: webKit delegate
        
        webKit.navigationDelegate = self
        updateData()
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
    
    // MARK: - Event and Handlers
    
    @objc fileprivate func refreshButtonPressed() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alertView.alpha = 0
            self.refreshButton.alpha = 0
        }) { (didFinish) in
            if didFinish {
                self.refreshButton.isHidden = true
                self.refreshButton.isEnabled = false
                self.scrollView.isHidden = false
                self.updateData()
            }
        }
    }
}

extension PostController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // FIXME: Enable ViewPort, Change Font
        
        var scriptContent = "var meta = document.createElement('meta');"
        scriptContent += "meta.name='viewport';"
        scriptContent += "meta.content='width=device-width' - 100;"
        scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
        scriptContent += "var style = document.createElement('style');style.innerHTML = 'body { -webkit-text-size-adjust: 300%; }';document.getElementsByTagName('head')[0].appendChild(style);"
        webView.evaluateJavaScript(scriptContent, completionHandler: nil)
        
        //==========================================================//
        // FIXME: Document Background
        
        let css = "body { background-color : #f7f7f7 }"
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
        
        //==========================================================//
        // FIXME: Enable RTL (right-to-left)
        
        let rtl = "document.getElementsByTagName('Body')[0].style.direction = \"rtl\""
        webView.evaluateJavaScript(rtl, completionHandler: nil)
        
        // FIXME: Show webView
        
        webView.isHidden = false
    }
}
