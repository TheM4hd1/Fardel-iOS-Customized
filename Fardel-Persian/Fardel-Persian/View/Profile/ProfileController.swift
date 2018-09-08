//
//  ProfileController.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/5/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import MaterialComponents

class ProfileController: UIViewController {
    
    private var didViewLoad = false
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.alpha = 0.5
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 5)
        return scrollView
    }()
    
    private lazy var imageTop: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "blackboard").withRenderingMode(.alwaysOriginal))
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 24)
        label.textColor = .lightText
        label.text = "User Name"
        return label
    }()
    
    private lazy var labelEmail: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = customString(title: "Email", subTitle: "userEmail@domain.name")
        return label
    }()
    
    private lazy var labelMobile: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = customString(title: "Mobile", subTitle: "+98-111-222-3333")
        return label
    }()
    
    private lazy var labelAddress: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = customString(title: "Address", subTitle: "921 Church St, San Francisco, CA 94114, USA")
        return label
    }()
    
    private lazy var editButton: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "edit").withRenderingMode(.alwaysOriginal))
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(editButtonPressed))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var btnLogout: UIButton = {
        let btn = UIButton(type: .system)
        btn.alpha = 0
        btn.setTitle("Log Out", for: .normal)
        btn.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
        btn.addTarget(self, action: #selector(btnLogoutPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator()
        indicator.cycleColors = [.red, UIColor.fromRgb(red: 68, green: 110, blue: 212)]
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        NotificationCenter.default.addObserver(self, selector: #selector(userDataChanged), name: NOTIF_USER_DATA_CHANGED, object: nil)

        if Settings.user.isLoggedIn {
            setupViews()
            userDataChanged()
        } else {
            navigationController?.pushViewController(LoginController(), animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didViewLoad {
            setupViews()
        }
    }
    
    fileprivate func setupViews() {
        
        didViewLoad = true
        
        //==========================================================//
        // TODO: Customize View and Navigation
        
        navigationController?.navigationBar.isHidden = true
        
        //==========================================================//
        // TODO: Add Subviews
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageTop)
        imageTop.addSubview(labelName)
        scrollView.addSubview(labelEmail)
        scrollView.addSubview(labelMobile)
        scrollView.addSubview(labelAddress)
        scrollView.addSubview(editButton)
        view.addSubview(btnLogout)
        scrollView.addSubview(activityIndicator)
        
        //==========================================================//
        // TODO: Setup Constraints
        
        if #available(iOS 11.0, *) {
            
            // FIXME: scrollView
            scrollView.anchorManual(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            // FIXME: imageTop
            imageTop.anchorManual(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            NSLayoutConstraint.activate([imageTop.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                                         imageTop.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)])
            
            // FIXME: labelName
            labelName.anchorManual(top: nil, left: imageTop.leftAnchor, bottom: imageTop.bottomAnchor, right: imageTop.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: -16, paddingRight: 16, width: 0, height: 30)
            
            // FIXME: labelEmail
            labelEmail.anchorManual(top: imageTop.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
            
            // FIXME: labelMobile
            labelMobile.anchorManual(top: labelEmail.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
            
            // FIXME: labelAddress
            labelAddress.anchorManual(top: labelMobile.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
            
            // FIXME: editButton
            editButton.anchorManual(top: imageTop.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: -25, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 50, height: 50)
            
            // FIXME: btnLogout
            btnLogout.anchorManual(top: nil, left: view.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
            
            // FIXME: activityIndicator
            activityIndicator.anchorManual(top: labelAddress.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        }
        
        //==========================================================//
        // TODO: Active Animation
        
        UIView.animate(withDuration: 1) {
            self.scrollView.alpha = 1
            self.btnLogout.alpha = 1
        }
    }
    
    fileprivate func customString(title: String, subTitle: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title)\n", attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 14)!, NSAttributedStringKey.foregroundColor: UIColor.fromRgb(red: 55, green: 55, blue: 55)]))
        attributedText.append(NSAttributedString(string: subTitle, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 14)!, NSAttributedStringKey.foregroundColor: UIColor.fromRgb(red: 149, green: 149, blue: 149)]))
        return attributedText
    }
    
    @objc fileprivate func userDataChanged() {
        if Settings.user.isLoggedIn {
            
            // TODO: Update Profile Info
            
            activityIndicator.startAnimating()
            APIService.request.getProfile { (success, message) in
                if success {
                    self.activityIndicator.stopAnimating()
                    self.labelName.text = Settings.user.name
                    self.labelEmail.attributedText = self.customString(title: "Email", subTitle: Settings.user.email)
                } else {
                    self.activityIndicator.stopAnimating()
                    debugPrint("[userDataChanged profile] \(message)")
                }
            }
        } else {
            
            // Fire on LogOut
            navigationController?.pushViewController(LoginController(), animated: false)
        }
    }
    
    @objc fileprivate func editButtonPressed() {
        UIView.animate(withDuration: 0.15, animations: {
            self.editButton.alpha = 0
        }) { (didFinish) in
            if didFinish {
                UIView.animate(withDuration: 0.15, animations: {
                    self.editButton.alpha = 1
                }, completion: { (didFinish) in
                    self.navigationController?.pushViewController(EditProfileController(), animated: false)
                })
            }
        }
    }
    
    @objc fileprivate func btnLogoutPressed() {
        let alertControll = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertControll.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: handlerLogOutUser))
        alertControll.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertControll.popoverPresentationController?.sourceView = self.view
            alertControll.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alertControll.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        present(alertControll,animated: true,completion: nil)
    }
    
    fileprivate func handlerLogOutUser(_ UIAlertAction: UIAlertAction) {
        activityIndicator.startAnimating()
        
        APIService.request.logout { (success, message) in
            if success {
                self.activityIndicator.stopAnimating()
                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
            } else {
                self.activityIndicator.stopAnimating()
                debugPrint("[logout profile] \(message)")
            }
        }
    }
    
    deinit {
        debugPrint("[deinit] ProfileController")
        NotificationCenter.default.removeObserver(self, name: NOTIF_USER_DATA_CHANGED, object: nil)
    }
}
