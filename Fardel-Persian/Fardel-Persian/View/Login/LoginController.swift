//
//  LoginController.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/5/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import MaterialComponents

class LoginController: UIViewController {
    
    private var didLoadCompleted = false
    
    private lazy var imageTop: UIImageView = {
       let imageTop = UIImageView(image: #imageLiteral(resourceName: "LoginTopImage").withRenderingMode(.alwaysOriginal))
        imageTop.contentMode = .scaleAspectFill
        imageTop.layer.masksToBounds = true
        imageTop.alpha = 0
        return imageTop
    }()

    private lazy var circleLogo: UIImageView = {
        let logo = UIImageView(image: #imageLiteral(resourceName: "HomeLogo").withRenderingMode(.alwaysOriginal))
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.layer.cornerRadius = 50
        logo.contentMode = .scaleAspectFill
        logo.layer.masksToBounds = true
        logo.alpha = 0
        return logo
    }()
    
    private lazy var formLogin: UIView = {
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
    
    private lazy var labelAlert: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        label.text = "رمز عبور یا نام کاربری اشتباه است."
        label.isHidden = true
        label.alpha = 0
        return label
    }()
    
    private lazy var btnLogin: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(btnLoginPressed), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "icons8-login-filled-50").withRenderingMode(.alwaysTemplate), for: .normal)
        return btn
    }()
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator()
        indicator.cycleColors = [UIColor.fromRgb(red: 68, green: 110, blue: 212), .orange]
        return indicator
    }()
    
    private lazy var btnSignup: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(btnSignupPressed), for: .touchUpInside)
        let attributedTitle = NSMutableAttributedString(string: "حساب کاربری ندارید؟ ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "همین حالا ایجاد کنید", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.fromRgb(red: 68, green: 110, blue: 212)]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.alpha = 0
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !didLoadCompleted {
            setupViews()
        }
    }
    fileprivate func setupViews() {
        
        //==========================================================//
        // TODO: Customize View and Navigation

        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        //==========================================================//
        // TODO: Add Gesture Recognizer

        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
        
        //==========================================================//
        // TODO: Add Subviews
        
        view.addSubview(imageTop)
        imageTop.addSubview(circleLogo)
        view.addSubview(formLogin)
        formLogin.addSubview(emailIcon)
        formLogin.addSubview(textEmail)
        formLogin.addSubview(lineEmail)
        formLogin.addSubview(passIcon)
        formLogin.addSubview(textPass)
        formLogin.addSubview(linePass)
        formLogin.addSubview(labelAlert)
        formLogin.addSubview(btnLogin)
        formLogin.addSubview(activityIndicator)
        view.addSubview(btnSignup)
        
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
            
            // FIXME: formLogin
            formLogin.anchorManual(top: circleLogo.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
            formLogin.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
            
            // FIXME: emailIcon: textEmail | lineEmail
            emailIcon.anchorManual(top: formLogin.topAnchor, left: formLogin.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
            textEmail.anchorManual(top: formLogin.topAnchor, left: emailIcon.rightAnchor, bottom: nil, right: formLogin.rightAnchor, paddingTop: 16, paddingLeft: 5, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            lineEmail.anchorManual(top: textEmail.bottomAnchor, left: formLogin.leftAnchor, bottom: nil, right: formLogin.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
            
            // FIXME: passIcon: textPass | linePass
            passIcon.anchorManual(top: lineEmail.bottomAnchor, left: formLogin.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
            textPass.anchorManual(top: lineEmail.bottomAnchor, left: passIcon.rightAnchor, bottom: nil, right: formLogin.rightAnchor, paddingTop: 16, paddingLeft: 5, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            linePass.anchorManual(top: textPass.bottomAnchor, left: formLogin.leftAnchor, bottom: nil, right: formLogin.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 1)
            
            // FIXME: lblAlert
            labelAlert.anchorManual(top: linePass.bottomAnchor, left: formLogin.leftAnchor, bottom: nil, right: formLogin.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            
            // FIXME: btnLogin
            btnLogin.anchorManual(top: nil, left: nil, bottom: formLogin.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -16, paddingRight: 0, width: 30, height: 30)
            btnLogin.centerXAnchor.constraint(equalTo: formLogin.centerXAnchor).isActive = true
            
            // FIXME: activityIndicator
            activityIndicator.anchorManual(top: linePass.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            activityIndicator.centerXAnchor.constraint(equalTo: formLogin.centerXAnchor).isActive = true
            
            // FIXME: btnSignup
            btnSignup.anchorManual(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: -16, paddingRight: 16, width: 0, height: 30)
        }
        
        //==========================================================//
        // TODO: Active Animation
        
        UIView.animate(withDuration: 1, animations: {
            self.imageTop.alpha = 1
        }) { (didFinish) in
            if didFinish {
                UIView.animate(withDuration: 1, animations: {
                    self.circleLogo.alpha = 1
                }, completion: { (didFinish) in
                    if didFinish {
                        UIView.animate(withDuration: 1, animations: {
                            self.formLogin.alpha = 1
                            self.btnSignup.alpha = 1
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
    
    @objc fileprivate func btnLoginPressed() {
        
        guard let email = textEmail.text else { return }
        guard let password = textPass.text else { return }
        
        // TODO: Login User
        
        UIView.animate(withDuration: 0.5, animations: {
            self.btnLogin.alpha = 0
            self.labelAlert.alpha = 0
            self.labelAlert.isHidden = false
        }) { (didFinish) in
            if didFinish {
                self.btnLogin.isHidden = true
                self.btnLogin.isEnabled = false
                self.activityIndicator.startAnimating()
                
                APIService.request.login(userEmail: email, userPassword: password, completion: { (success, message) in
                    if success {
                        self.activityIndicator.stopAnimating()
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.btnLogin.isHidden = false
                        self.btnLogin.isEnabled = true
                        self.activityIndicator.stopAnimating()
                        self.labelAlert.text = message
                        UIView.animate(withDuration: 0.5, animations: {
                            self.labelAlert.alpha = 1
                            self.btnLogin.alpha = 1
                        })
                    }
                })
            }
        }
    }
    
    @objc fileprivate func btnSignupPressed() {
        // TODO: Signup New User
        navigationController?.pushViewController(RegisterController(), animated: true)
    }
    
    deinit {
        debugPrint("[deinit] LoginController")
    }
}

extension LoginController: UITextFieldDelegate {
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



