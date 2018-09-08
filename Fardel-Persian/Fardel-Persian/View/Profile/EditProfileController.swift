//
//  EditProfileController.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/9/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import MaterialComponents

class EditProfileController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.alpha = 1
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 5)
        return scrollView
    }()
    
    private lazy var imageTop: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "blackboard").withRenderingMode(.alwaysOriginal))
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "baseline_keyboard_backspace_white_24pt_"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var circleLogo: UIImageView = {
        let logo = UIImageView(image: #imageLiteral(resourceName: "RegisterLogo").withRenderingMode(.alwaysOriginal))
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFill
        logo.layer.masksToBounds = true
        logo.alpha = 0
        return logo
    }()
    
    private lazy var formInfo: UIView = {
        let form = UIView()
        form.dropShadow()
        form.backgroundColor = .white
        form.layer.cornerRadius = 8
        form.alpha = 0
        return form
    }()
    
    private lazy var emailIcon: UIImageView = {
        let icon = UIImageView(image: #imageLiteral(resourceName: "baseline_email_black_24pt_").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .darkGray
        icon.contentMode = .scaleAspectFill
        icon.layer.masksToBounds = true
        return icon
    }()
    
    private lazy var textEmail: UITextField = {
        let text = UITextField()
        text.delegate = self
        text.tag = 1
        text.placeholder = "آدرس ایمیل"
        text.textAlignment = .center
        text.autocorrectionType = .no
        text.autocapitalizationType = .none
        text.font = UIFont.systemFont(ofSize: 14)
        text.layer.cornerRadius = 8
        text.textColor = .darkText
        return text
    }()
    
    private lazy var lineEmail: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    private lazy var firstNameIcon: UIImageView = {
        let icon = UIImageView(image: #imageLiteral(resourceName: "baseline_person_black_36pt_").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .darkGray
        icon.contentMode = .scaleAspectFill
        icon.layer.masksToBounds = true
        return icon
    }()
    
    private lazy var textFirstName: UITextField = {
        let text = UITextField()
        text.delegate = self
        text.tag = 2
        text.placeholder = "نام"
        text.textAlignment = .center
        text.autocorrectionType = .no
        text.autocapitalizationType = .none
        text.font = UIFont.systemFont(ofSize: 14)
        text.layer.cornerRadius = 8
        text.textColor = .darkText
        return text
    }()
    
    private lazy var lineFirstName: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    private lazy var lastNameIcon: UIImageView = {
        let icon = UIImageView(image: #imageLiteral(resourceName: "baseline_person_black_36pt_").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .darkGray
        icon.contentMode = .scaleAspectFill
        icon.layer.masksToBounds = true
        return icon
    }()
    
    private lazy var textLastName: UITextField = {
        let text = UITextField()
        text.delegate = self
        text.tag = 3
        text.placeholder = "نام خانوادگی"
        text.textAlignment = .center
        text.autocorrectionType = .no
        text.autocapitalizationType = .none
        text.font = UIFont.systemFont(ofSize: 14)
        text.layer.cornerRadius = 8
        text.textColor = .darkText
        return text
    }()
    
    private lazy var lineLastName: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    private lazy var passIcon: UIImageView = {
        let icon = UIImageView(image: #imageLiteral(resourceName: "baseline_lock_black_24pt_").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .darkGray
        icon.contentMode = .scaleAspectFill
        icon.layer.masksToBounds = true
        return icon
    }()
    
    private lazy var textPass: UITextField = {
        let text = UITextField()
        text.delegate = self
        text.tag = 4
        text.placeholder = "رمز عبور (اختیاری)"
        text.textAlignment = .center
        text.autocorrectionType = .no
        text.autocapitalizationType = .none
        text.font = UIFont.systemFont(ofSize: 14)
        text.isSecureTextEntry = true
        text.layer.cornerRadius = 8
        text.textColor = .darkText
        return text
    }()
    
    private lazy var linePass: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    private lazy var labelAlert: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        label.text = "خطایی رخ داده است."
        label.isHidden = true
        label.alpha = 0
        return label
    }()
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator()
        indicator.cycleColors = [UIColor.fromRgb(red: 68, green: 110, blue: 212), .orange]
        return indicator
    }()
    
    private lazy var btnSave: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "baseline_save_black_24pt_"), for: .normal)
        btn.addTarget(self, action: #selector(btnSavePressed), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        // TODO: Add Gesture Recognizer
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
        
        // TODO: Add Subviews
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageTop)
        imageTop.addSubview(backButton)
        imageTop.addSubview(circleLogo)
        view.addSubview(formInfo)
        formInfo.addSubview(emailIcon)
        formInfo.addSubview(textEmail)
        formInfo.addSubview(lineEmail)
        formInfo.addSubview(firstNameIcon)
        formInfo.addSubview(textFirstName)
        formInfo.addSubview(lineFirstName)
        formInfo.addSubview(lastNameIcon)
        formInfo.addSubview(textLastName)
        formInfo.addSubview(lineLastName)
        formInfo.addSubview(passIcon)
        formInfo.addSubview(textPass)
        formInfo.addSubview(linePass)
        formInfo.addSubview(labelAlert)
        formInfo.addSubview(activityIndicator)
        formInfo.addSubview(btnSave)
        
        //==========================================================//
        // TODO: Setup Constraints
        
        if #available(iOS 11.0, *) {
            
            // FIXME: scrollView
            scrollView.anchorManual(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            // FIXME: imageTop
            imageTop.anchorManual(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            NSLayoutConstraint.activate([imageTop.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                                         imageTop.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1)])
            
            // FIXME: btnBack
            backButton.anchorManual(top: imageTop.topAnchor, left: imageTop.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
            
            // FIXME: circleLogo
            NSLayoutConstraint.activate([circleLogo.centerXAnchor.constraint(equalTo: imageTop.centerXAnchor),
                                         circleLogo.centerYAnchor.constraint(equalTo: imageTop.centerYAnchor),
                                         circleLogo.heightAnchor.constraint(equalToConstant: 100),
                                         circleLogo.widthAnchor.constraint(equalToConstant: 100)])
            
            // FIXME: formInfo
            formInfo.anchorManual(top: circleLogo.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: -16, paddingRight: 16, width: 0, height: 0)
            formInfo.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
            
            // FIXME: emailIcon: textEmail | lineEmail
            emailIcon.anchorManual(top: formInfo.topAnchor, left: formInfo.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
            textEmail.anchorManual(top: formInfo.topAnchor, left: emailIcon.rightAnchor, bottom: nil, right: formInfo.rightAnchor, paddingTop: 16, paddingLeft: 5, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            lineEmail.anchorManual(top: textEmail.bottomAnchor, left: formInfo.leftAnchor, bottom: nil, right: formInfo.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
            
            // FIXME: firstNameIcon: textFirstName | lineFirstName
            firstNameIcon.anchorManual(top: lineEmail.bottomAnchor, left: formInfo.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
            textFirstName.anchorManual(top: lineEmail.bottomAnchor, left: firstNameIcon.rightAnchor, bottom: nil, right: formInfo.rightAnchor, paddingTop: 16, paddingLeft: 5, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            lineFirstName.anchorManual(top: textFirstName.bottomAnchor, left: formInfo.leftAnchor, bottom: nil, right: formInfo.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
            
            // FIXME: lastNameIcon: textLastName | lineLastName
            lastNameIcon.anchorManual(top: lineFirstName.bottomAnchor, left: formInfo.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
            textLastName.anchorManual(top: lineFirstName.bottomAnchor, left: lastNameIcon.rightAnchor, bottom: nil, right: formInfo.rightAnchor, paddingTop: 16, paddingLeft: 5, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            lineLastName.anchorManual(top: textLastName.bottomAnchor, left: formInfo.leftAnchor, bottom: nil, right: formInfo.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
            
            // FIXME: passIcon: textPass | linePass
            passIcon.anchorManual(top: lineLastName.bottomAnchor, left: formInfo.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
            textPass.anchorManual(top: lineLastName.bottomAnchor, left: passIcon.rightAnchor, bottom: nil, right: formInfo.rightAnchor, paddingTop: 16, paddingLeft: 5, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            linePass.anchorManual(top: textPass.bottomAnchor, left: formInfo.leftAnchor, bottom: nil, right: formInfo.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
            
            // FIXME: lblAlert
            labelAlert.anchorManual(top: linePass.bottomAnchor, left: formInfo.leftAnchor, bottom: nil, right: formInfo.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            
            // FIXME: activityIndicator
            activityIndicator.anchorManual(top: linePass.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            activityIndicator.centerXAnchor.constraint(equalTo: formInfo.centerXAnchor).isActive = true
            
            // FIXME: btnSave
            btnSave.anchorManual(top: nil, left: nil, bottom: formInfo.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -16, paddingRight: 0, width: 30, height: 30)
            btnSave.centerXAnchor.constraint(equalTo: formInfo.centerXAnchor).isActive = true
            
        }
        
        //==========================================================//
        // TODO: Active Animation
        
        UIView.animate(withDuration: 1, animations: {
            self.circleLogo.alpha = 1
            self.circleLogo.layer.cornerRadius = 50
            self.formInfo.alpha = 1
        })
        
        //==========================================================//
        // TODO: Fill Info
        
        textEmail.text = Settings.user.email
        var arrName = Settings.user.name.components(separatedBy: " ")
        textFirstName.text = arrName.removeFirst()
        textLastName.text = arrName.joined(separator: " ")
    }
    
    @objc fileprivate func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func btnSavePressed() {
        UIView.animate(withDuration: 0.5, animations: {
            self.btnSave.alpha = 0
            self.labelAlert.alpha = 0
            self.labelAlert.isHidden = false
            
        }) { (didFinish) in
            self.btnSave.isHidden = true
            self.btnSave.isEnabled = false
            self.activityIndicator.startAnimating()
            guard let email = self.textEmail.text else { return }
            guard let fname = self.textFirstName.text else { return }
            guard let lname = self.textLastName.text else { return }
            guard let pass = self.textPass.text else { return }
            
            APIService.request.updateProfile(userEmail: email, userFirstName: fname, userLastName: lname, newPassword: pass, completion: { (success, message) in
                if success {
                    self.activityIndicator.stopAnimating()
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.activityIndicator.stopAnimating()
                    self.labelAlert.text = message
                    self.btnSave.isEnabled = true
                    self.btnSave.isHidden = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.labelAlert.alpha = 1
                        self.btnSave.alpha = 1
                    })
                }
            })
        }
    }
    
    @objc fileprivate func endEditing() {
        view.endEditing(true)
    }
}

extension EditProfileController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            UIView.animate(withDuration: 0.5) {
                self.lineEmail.frame.size.height = 2
                self.lineEmail.backgroundColor = .darkGray
            }
        } else if textField.tag == 2 {
            UIView.animate(withDuration: 0.5) {
                self.lineFirstName.frame.size.height = 2
                self.lineFirstName.backgroundColor = .darkGray
            }
        } else if textField.tag == 3 {
            self.lineLastName.frame.size.height = 2
            self.lineLastName.backgroundColor = .darkGray
        } else {
            self.linePass.frame.size.height = 2
            self.linePass.backgroundColor = .darkGray
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            UIView.animate(withDuration: 0.5) {
                self.lineEmail.frame.size.height = 1
                self.lineEmail.backgroundColor = .gray
            }
        } else if textField.tag == 2 {
            UIView.animate(withDuration: 0.5) {
                self.lineFirstName.frame.size.height = 1
                self.lineFirstName.backgroundColor = .gray
            }
        } else if textField.tag == 3 {
            self.lineLastName.frame.size.height = 1
            self.lineLastName.backgroundColor = .gray
        } else {
            self.linePass.frame.size.height = 1
            self.linePass.backgroundColor = .gray
        }
    }
}
