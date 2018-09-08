//
//  RegisterController.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/5/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import MaterialComponents

class RegisterController: UIViewController {
    
    private var didLoadCompleted = false
    
    private lazy var imageTop: UIImageView = {
        let imageTop = UIImageView(image: #imageLiteral(resourceName: "LoginTopImage").withRenderingMode(.alwaysOriginal))
        imageTop.contentMode = .scaleAspectFill
        imageTop.layer.masksToBounds = true
        imageTop.alpha = 0
        return imageTop
    }()
    
    private lazy var circleLogo: UIImageView = {
        let logo = UIImageView(image: #imageLiteral(resourceName: "RegisterLogo").withRenderingMode(.alwaysOriginal))
        logo.translatesAutoresizingMaskIntoConstraints = false
        //logo.layer.cornerRadius = 25
        logo.contentMode = .scaleAspectFill
        logo.layer.masksToBounds = true
        logo.alpha = 0
        return logo
    }()
    
    private lazy var formSignup: UIView = {
        let form = UIView()
        form.backgroundColor = .white
        form.alpha = 0
        form.layer.cornerRadius = 8
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
        text.tag = 2
        text.placeholder = "رمز عبور"
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
    
    private lazy var lineEmail: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    private lazy var labelAlert: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        label.text = "ایمیل قبلا ثبت شده است."
        label.isHidden = true
        label.alpha = 0
        return label
    }()
    
    private lazy var btnSignup: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(btnSignupPressed), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "baseline_person_add_black_24pt_").withRenderingMode(.alwaysTemplate), for: .normal)
        return btn
    }()
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator()
        indicator.cycleColors = [UIColor.fromRgb(red: 68, green: 110, blue: 212), .orange]
        return indicator
    }()
    
    private lazy var btnBack: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        let attributedTitle = NSMutableAttributedString(string: "حساب کاربری دارید؟ ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "وارد شوید", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.fromRgb(red: 68, green: 110, blue: 212)]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.alpha = 0
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !didLoadCompleted {
            setupViews()
        }
    }
    
    fileprivate func setupViews() {
        
        //==========================================================//
        // TODO: Customize View
        
        view.backgroundColor = .white
        
        
        //==========================================================//
        // TODO: Add Gesture Recognizer
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
        
        
        //==========================================================//
        // TODO: Add Subviews
        
        view.addSubview(imageTop)
        imageTop.addSubview(circleLogo)
        view.addSubview(formSignup)
        formSignup.addSubview(emailIcon)
        formSignup.addSubview(textEmail)
        formSignup.addSubview(lineEmail)
        formSignup.addSubview(passIcon)
        formSignup.addSubview(textPass)
        formSignup.addSubview(linePass)
        formSignup.addSubview(labelAlert)
        formSignup.addSubview(btnSignup)
        formSignup.addSubview(activityIndicator)
        view.addSubview(btnBack)
        
        //==========================================================//
        // TODO: Setup Constraints
        
        if #available(iOS 11.0, *) {
            
            // FIXME: imageTop
            imageTop.anchorManual(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            imageTop.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
            
            // FIXME: circleLogo
            NSLayoutConstraint.activate([circleLogo.centerXAnchor.constraint(equalTo: imageTop.centerXAnchor),
                                         circleLogo.centerYAnchor.constraint(equalTo: imageTop.centerYAnchor),
                                         circleLogo.heightAnchor.constraint(equalToConstant: 100),
                                         circleLogo.widthAnchor.constraint(equalToConstant: 100)])
            
            // FIXME: formSignup
            formSignup.anchorManual(top: circleLogo.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: -16, paddingRight: 16, width: 0, height: 0)
            formSignup.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
            
            // FIXME: emailIcon: textEmail | lineEmail
            emailIcon.anchorManual(top: formSignup.topAnchor, left: formSignup.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
            textEmail.anchorManual(top: formSignup.topAnchor, left: emailIcon.rightAnchor, bottom: nil, right: formSignup.rightAnchor, paddingTop: 16, paddingLeft: 5, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            lineEmail.anchorManual(top: textEmail.bottomAnchor, left: formSignup.leftAnchor, bottom: nil, right: formSignup.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
            
            // FIXME: passIcon: textPass | linePass
            passIcon.anchorManual(top: lineEmail.bottomAnchor, left: formSignup.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
            textPass.anchorManual(top: lineEmail.bottomAnchor, left: passIcon.rightAnchor, bottom: nil, right: formSignup.rightAnchor, paddingTop: 16, paddingLeft: 5, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            linePass.anchorManual(top: textPass.bottomAnchor, left: formSignup.leftAnchor, bottom: nil, right: formSignup.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
            
            // FIXME: lblAlert
            labelAlert.anchorManual(top: linePass.bottomAnchor, left: formSignup.leftAnchor, bottom: nil, right: formSignup.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            
            // FIXME: btnSignup
            btnSignup.anchorManual(top: nil, left: nil, bottom: formSignup.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -16, paddingRight: 0, width: 30, height: 30)
            btnSignup.centerXAnchor.constraint(equalTo: formSignup.centerXAnchor).isActive = true
            
            // FIXME: activityIndicator
            activityIndicator.anchorManual(top: linePass.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            activityIndicator.centerXAnchor.constraint(equalTo: formSignup.centerXAnchor).isActive = true
            
            // FIXME: btnBack
            btnBack.anchorManual(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: -16, paddingRight: 16, width: 0, height: 30)
        }
        
        //==========================================================//
        // TODO: Active Animation
        
        UIView.animate(withDuration: 1, animations: {
            self.imageTop.alpha = 1
        }) { (didFinish) in
            if didFinish {
                UIView.animate(withDuration: 1, animations: {
                    self.circleLogo.alpha = 1
                    self.circleLogo.layer.cornerRadius = 50
                }, completion: { (didFinish) in
                    if didFinish {
                        UIView.animate(withDuration: 1, animations: {
                            self.formSignup.alpha = 1
                            self.btnBack.alpha = 1
                            self.formSignup.dropShadow()
                            self.didLoadCompleted = true
                        })
                    }
                })
            }
        }
        
    }
    
    @objc fileprivate func endEditing() {
        view.endEditing(true)
    }
    
    @objc fileprivate func btnBackPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func btnSignupPressed() {

        UIView.animate(withDuration: 0.5, animations: {
            self.btnSignup.alpha = 0
            self.labelAlert.alpha = 0
            self.labelAlert.isHidden = false
        }) { (didFinish) in
            if didFinish {
                self.btnSignup.isHidden = true
                self.btnSignup.isEnabled = false
                self.activityIndicator.startAnimating()
                
                // TODO: Register User
                
                guard let email = self.textEmail.text else { return }
                guard let pass = self.textPass.text else { return }
                APIService.request.register(userEmail: email, userPassword: pass, completion: { (success, message) in
                    if success {
                        self.activityIndicator.stopAnimating()
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.btnSignup.isHidden = false
                        self.btnSignup.isEnabled = true
                        self.activityIndicator.stopAnimating()
                        self.labelAlert.text = message
                        UIView.animate(withDuration: 0.5, animations: {
                            self.labelAlert.alpha = 1
                            self.btnSignup.alpha = 1
                        })
                    }
                })
            }
        }
    }
    
    deinit {
        debugPrint("[deinit] RegisterController")
    }
}

extension RegisterController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            UIView.animate(withDuration: 0.5) {
                self.lineEmail.frame.size.height = 2
                self.lineEmail.backgroundColor = .darkGray
            }
            
        } else {
            UIView.animate(withDuration: 0.5) {
                self.linePass.frame.size.height = 2
                self.linePass.backgroundColor = .darkGray
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            UIView.animate(withDuration: 0.5) {
                self.lineEmail.frame.size.height = 1
                self.lineEmail.backgroundColor = .gray
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.linePass.frame.size.height = 1
                self.linePass.backgroundColor = .gray
            }
        }
    }
}
