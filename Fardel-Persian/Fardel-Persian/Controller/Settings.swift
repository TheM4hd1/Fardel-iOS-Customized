//
//  Settings.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/7/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import Foundation
import KeychainSwift

class Settings {
    
    static let user = Settings()
    private let userDefaults = UserDefaults.standard
    private let keychain = KeychainSwift() // Keychain is a secure storage
    
    private init() {
        
    }
    
    // Mark: - Keys
    
    private let KEY_LOGGED_IN = "isLoggedIn"
    private let KEY_USER_EMAIL = "userEmail"
    private let KEY_USER_NAME = "userName"
    private let KEY_USER_ACCESS_TOKEN = "userToken"
    private let KEY_USER_REFRESH_TOKEN = "userRefreshToken"
    
    // Mark: - Properties
    
    var isLoggedIn: Bool {
        get {
            return userDefaults.bool(forKey: KEY_LOGGED_IN)
        }
        
        set {
            userDefaults.set(newValue, forKey: KEY_LOGGED_IN)
        }
    }
    
    var email: String {
        get {
            return userDefaults.value(forKey: KEY_USER_EMAIL) as! String
        }
        
        set {
            userDefaults.set(newValue, forKey: KEY_USER_EMAIL)
        }
    }
    
    var name: String {
        get {
            return userDefaults.value(forKey: KEY_USER_NAME) as? String ?? ""
        }
        
        set {
            userDefaults.set(newValue, forKey: KEY_USER_NAME)
        }
    }
    
    var accessToken: String {
        get {
            return keychain.get(KEY_USER_ACCESS_TOKEN)!
        }
        
        set {
            keychain.set(newValue, forKey: KEY_USER_ACCESS_TOKEN)
        }
    }
    
    var refreshToken: String {
        get {
            return keychain.get(KEY_USER_REFRESH_TOKEN)!
        }
        
        set {
            keychain.set(newValue, forKey: KEY_USER_REFRESH_TOKEN)
        }
    }

}
