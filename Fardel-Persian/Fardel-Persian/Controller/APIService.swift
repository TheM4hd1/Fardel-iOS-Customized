//
//  APIService.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/5/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/*
 * Handling RESTful API Services
 * 'receive' prefix: function receive a group of Model
 * 'get' prefix: function just receive a single Model
 */

final class APIService {
    
    static let request = APIService() // Singleton Design Pattern
    typealias completionHandler = (Bool,String) -> ()
    private let HEADER = [
        "content-type": "application/json"
    ]
    
    private init() {
        
    }
    
    
    
    // Mark: - Profile API
    
    func register(userEmail: String, userPassword: String, completion: @escaping completionHandler) {
        
        // FIXME: Check Email
        
        if userEmail.isEmpty {
            completion(false, "ایمیل خود را وارد نمایید.")
        }
        
        // FIXME: Check Password
       
        if userPassword.isEmpty {
            completion(false, "رمز عبور نمی تواند خالی باشد.")
        }
        
        // TODO: Registeration
        
        let requestBody: [String:String] = ["email": userEmail.lowercased(),
                                     "password": userPassword]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: requestBody, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                if let statusCode = response.response?.statusCode {
                    
                    guard let data = response.data else { return }
                    do {
                        let json = try JSON(data: data)
                        
                        let accessToken = json["access_token"].stringValue
                        let refreshToken = json["refresh_token"].stringValue
                        
                        if statusCode == 200 {
                            self.editUserSettings(email: userEmail, name: "", accessToken: accessToken, refreshToken: refreshToken, isLoggedIn: true)
                            completion(true, "ثبت نام با موفقیت انجام شد.")
                        } else if statusCode == 409 {
                            completion(false, "آدرس ایمیل قبلا ثبت شده است.")
                        } else {
                            completion(false, "کد خطا: \(statusCode)")
                        }
                        
                    } catch {
                        completion(false, error.localizedDescription)
                    }
                }
                
            } else {
                debugPrint("[register] \(String(describing: response.result.error?.localizedDescription))")
                completion(false, "عدم ارتباط با سرور")
            }
        }
    }
    
    func login(userEmail: String, userPassword: String, completion: @escaping completionHandler) {
        
        // FIXME: Check Email
        
        if userEmail.isEmpty {
            completion(false, "ایمیل خود را وارد نمایید.")
        }
        
        // FIXME: Check Password
        
        if userPassword.isEmpty {
            completion(false, "رمز عبور نمی تواند خالی باشد.")
        }
        
        // TODO: Login
        
        let requestBody: [String:String] = ["email": userEmail.lowercased(),
                                            "password": userPassword]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: requestBody, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                if let statusCode = response.response?.statusCode {
                    
                    guard let data = response.data else { return }
                    do {
                        let json = try JSON(data: data)
                        
                        let accessToken = json["access_token"].stringValue
                        let refreshToken = json["refresh_token"].stringValue
                        
                        if statusCode == 200 {
                            self.editUserSettings(email: userEmail, name: "", accessToken: accessToken, refreshToken: refreshToken, isLoggedIn: true)
                            completion(true, "خوش آمدید.")
                        } else if statusCode == 401 {
                            completion(false, "رمز عبور یا آدرس ایمیل اشتباه است.")
                        } else {
                            completion(false, "کد خطا: \(statusCode)")
                        }
                        
                    } catch {
                        completion(false, error.localizedDescription)
                    }
                }
            } else {
                debugPrint("[login] \(String(describing: response.result.error?.localizedDescription))")
                completion(false, "عدم ارتباط با سرور")
            }
        }
    }
    
    func updateProfile(userEmail: String, userFirstName: String, userLastName: String, newPassword: String, completion: @escaping completionHandler) {
        
        let BEARER_HEADER_TOKEN = [
            "Authorization": "Bearer \(Settings.user.accessToken)",
            "content-type": "application/json"
        ]
        
        let requestBody: [String:String] = ["first_name": userFirstName,
                                            "last_name": userLastName,
                                            "email": userEmail,
                                            "password": newPassword]
        
        // TODO: Update Profile
        
        Alamofire.request(URL_PROFILE, method: .put, parameters: requestBody, encoding: JSONEncoding.default, headers: BEARER_HEADER_TOKEN).responseJSON { (response) in
            if response.result.isSuccess {
                if let statusCode = response.response?.statusCode {
                    
                    if statusCode == 200 {
                        completion(true, "مشخصات ذخیره شد.")
                    } else {
                        completion(false, "کد خطا: \(statusCode)")
                    }
                }
            } else {
                debugPrint("[login] \(String(describing: response.result.error?.localizedDescription))")
                completion(false, "عدم ارتباط با سرور")
            }
        }
    }
    
    func getProfile(completion: @escaping completionHandler) {
        
        let accessToken = Settings.user.accessToken
        let refreshToken = Settings.user.refreshToken
        let BEARER_HEADER_TOKEN = [
            "Authorization": "Bearer \(accessToken)",
            "content-type": "application/json"
        ]
        
        Alamofire.request(URL_PROFILE, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER_TOKEN).responseJSON { (response) in
            if response.result.isSuccess {
                if let statusCode = response.response?.statusCode {
                    
                    if statusCode == 200 {
                        guard let data = response.data else { return }
                        do {
                            let json = try JSON(data: data)
                            let userObject = json["user"]
                            
                            let email = userObject["email"].stringValue
                            let firstName = userObject["first_name"].stringValue
                            let lastName = userObject["last_name"].stringValue
                            
                            self.editUserSettings(email: email, name: "\(firstName) \(lastName)", accessToken: accessToken, refreshToken: refreshToken, isLoggedIn: true)
                            completion(true, "اطلاعات دریافت شد.")
                        } catch {
                            completion(false, error.localizedDescription)
                        }
                    } else {
                        completion(false, "کد خطا: \(statusCode)")
                    }
                }
            } else {
                debugPrint("[getProfile] \(String(describing: response.result.error?.localizedDescription))")
                completion(false, "عدم ارتباط با سرور")
            }
        }
    }
    
    func logout(completion: @escaping completionHandler) {
        
        if Settings.user.isLoggedIn {
            let accessToken = Settings.user.accessToken
            let refreshToken = Settings.user.refreshToken
            
            // FIXME: refreshToken Bearer Token
            
            let BEARER_HEADER_REFRESH_TOKEN = [
                "Authorization": "Bearer \(refreshToken)",
                "content-type": "application/json"
            ]
            
            // FIXME: accessToken Bearer Token
            
            let BEARER_HEADER_ACCESS_TOKEN = [
                "Authorization": "Bearer \(accessToken)",
                "content-type": "application/json"
            ]
            
            // TODO: Logout Refresh Token
            
            Alamofire.request(URL_REFRESH_LOGOUT, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER_REFRESH_TOKEN).responseJSON { (response) in
                if response.result.isSuccess {
                    if let statusCode = response.response?.statusCode {
                        
                        if statusCode == 200 { // Successfully LoggedOut
                            
                            // FIXME: Reset Settings
                            
                            self.editUserSettings(email: "", name: "", accessToken: "", refreshToken: "", isLoggedIn: false)
                            
                            // TODO: Logout Access Token
                            
                            Alamofire.request(URL_LOGOUT, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER_ACCESS_TOKEN).responseJSON { (response) in
                                if response.result.isSuccess {
                                    if let statusCode = response.response?.statusCode {
                                        
                                        if statusCode == 200 {
                                            completion(true, "both token revoked")
                                        } else {
                                            completion(true, "only refreshToken revoked")
                                        }
                                    }
                                } else {
                                    completion(true, "refreshToken revoked")
                                }
                            }
                        } else {
                            completion(false, "خطایی رخ داده: \(statusCode)")
                        }
                    }
                } else {
                    debugPrint("[logout] \(String(describing: response.result.error?.localizedDescription))")
                    completion(false, "عدم ارتباط با سرور")
                }
            }
        }
    }
    
    fileprivate func editUserSettings(email: String, name: String, accessToken: String, refreshToken: String, isLoggedIn: Bool) {
        Settings.user.accessToken = accessToken
        Settings.user.refreshToken = refreshToken
        Settings.user.isLoggedIn = isLoggedIn
        Settings.user.email = email.lowercased()
        Settings.user.name = name
    }
    
    // Mark: - Blog API
    
    private var post_page_number = 1
    private var total_pages_for_posts = 1
    func receivePosts(completion: @escaping (Bool, String, [Post]) -> ()) {
        
        if !IS_POST_AVAILABLE {
            completion(false, "no more post", [])
            return
        }
        // FIXME: Create URL for Posts
        
        let requestUrl = "\(URL_POSTS)?page=\(post_page_number)/"

        // TODO: Request Posts
        
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                if let statusCode = response.response?.statusCode {
                    
                    if statusCode == 200 {
                        
                        guard let data = response.data else { return }
                        do {
                            let json = try JSON(data: data)
                            let posts = json["posts"]
                            
                            self.total_pages_for_posts = posts["pages"].intValue
                            if posts.count > 0 {
                                var receivedPosts: [Post] = []
                                for(_,object) in posts {
                                    
                                    receivedPosts.append(Post(id: object["id"].intValue, title: object["title"].stringValue, content: object["content"].stringValue, allowComment: object["allow_comment"].boolValue, category: object["category"]["name"].stringValue, image: object["image"].stringValue, commentsCount: object["comments_count"].intValue, createdTime: object["create_time"].intValue, updateTime: object["update_time"].intValue, summarized: object["summarized"].stringValue))
                                }
                                
                                if self.post_page_number < self.total_pages_for_posts {
                                    self.post_page_number += 1
                                } else {
                                    IS_POST_AVAILABLE = false
                                }
                                completion(true, "پست ها دریافت شد", receivedPosts)
                            } else {
                                completion(false, "پست جدیدی برای نمایش وجود ندارد.", []) // There is no more posts
                            }
                        } catch {
                            completion(false, error.localizedDescription, [])
                        }
                    } else {
                        completion(false, "خطایی رخ داده: \(statusCode)", [])
                    }
                }
            } else {
                debugPrint("[receivePosts] \(String(describing: response.result.error?.localizedDescription))")
                completion(false, "عدم ارتباط با سرور", [])
            }
        }
    }
    
    func refreshHome(completion: (Bool) -> ()){
        post_page_number = 1
        total_pages_for_posts = 1
        IS_POST_AVAILABLE = true
        completion(true)
    }
    
    func getPost(postId: Int, completion: @escaping (Bool, String, Post) -> ()) {
        
        let requestUrl = "\(URL_POSTS)\(postId)/"
        
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                if let statusCode = response.response?.statusCode {
                    
                    if statusCode == 200 {
                        
                        guard let data = response.data else { return }
                        do {
                            let json = try JSON(data: data)
                            let postObject = json["post"]
                            let post = Post(id: postObject["id"].intValue, title: postObject["title"].stringValue, content: postObject["content"].stringValue, allowComment: postObject["allow_comment"].boolValue, category: postObject["category"]["name"].stringValue, image: postObject["image"].stringValue, commentsCount: postObject["comments_count"].intValue, createdTime: postObject["create_time"].intValue, updateTime: postObject["update_time"].intValue, summarized: postObject["summarized"].stringValue)
                            
                            completion(true, "پست دریافت شد", post)
                            
                        } catch {
                            completion(false, error.localizedDescription, Post())
                        }
                    } else {
                        completion(false, "خطایی رخ داده: \(statusCode)", Post())
                    }
                }
            } else {
                debugPrint("[getPost] \(String(describing: response.result.error?.localizedDescription))")
                completion(false, "عدم ارتباط با سرور", Post())
            }
        }
    }
    
    func receiveCategories(completion: @escaping (Bool, String, [Category]) -> ()) {
        
        Alamofire.request(URL_CATEGORIES, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                if let statusCode = response.response?.statusCode {
                    
                    if statusCode == 200 {
                        
                        guard let data = response.data else { return }
                        do {
                            let json = try JSON(data: data)
                            let categories = json["categories"]
                            
                            var categoriesArray: [Category] = []
                            for(_,object) in categories {
                                categoriesArray.append(Category(id: object["id"].intValue, subCategories: [], name: object["name"].stringValue))
                            }
                            completion(true, "دسته بندی ها دریافت شد", categoriesArray)
                            
                        } catch {
                            completion(false, error.localizedDescription, [])
                        }
                    } else {
                        completion(false, "خطایی رخ داده: \(statusCode)", [])
                    }
                }
            } else {
                debugPrint("[receiveCategories] \(String(describing: response.result.error?.localizedDescription))")
                completion(false, "عدم ارتباط با سرور", [])
            }
        }
    }
    
    func receiveProducts(category: String, completion: @escaping (Bool, String, [SummerizedProduct]) -> ()) {
        
        var requestUrl: String = ""
        if category.isEmpty {
            requestUrl = URL_PRODUCTS
        } else {
            requestUrl = "\(URL_CATEGORIES)\(category.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)/products/"
        }

        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                if let statusCode = response.response?.statusCode {
                    
                    if statusCode == 200 {
                        
                        guard let data = response.data else { return }
                        do {
                            let json = try JSON(data: data)
                            let products = json["products"]
                            
                            var summerizedProducts: [SummerizedProduct] = []
                            for (_,object) in products {
                                summerizedProducts.append(SummerizedProduct(name: object["name"].stringValue, price: object["price"].intValue, image: object["image"].stringValue, status: object["status"].stringValue, id: object["id"].intValue))
                            }
                            completion(true, "محصولات دریافت شد", summerizedProducts)
                            
                        } catch {
                            completion(false, error.localizedDescription, [])
                        }
                    } else {
                        completion(false, "خطایی رخ داده: \(statusCode)", [])
                    }
                }
            } else {
                debugPrint("[receiveCategories] \(String(describing: response.result.error?.localizedDescription))")
                completion(false, "عدم ارتباط با سرور", [])
            }
        }
    }
    
    func getProduct(productId: Int, completion: @escaping (Bool, String, Product?) -> ()) {
        
        let requestUrl = "\(URL_PRODUCTS)\(productId)/"
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.isSuccess {
                if let statusCode = response.response?.statusCode {
                    
                    if statusCode == 200 {
                        
                        guard let data = response.data else { return }
                        do {
                            let json = try JSON(data: data)
                            let product = json["product"]
                            let productTypeJson = product["product_type"]
                            let variantsJson = product["variants"]
                            let imagesJson = product["images"]
                            let variantAttributesJson = product["variant_attributes"]
                            let attributesJson = product["attributes"]
                            
                            let price = product["price"].intValue
                            let productType = ProductType(hasVariant: productTypeJson["has_variants"].boolValue,
                                                          isFileRequired: productTypeJson["is_file_required"].boolValue,
                                                          isShippingRequired: productTypeJson["is_shipping_required"].boolValue,
                                                          name: productTypeJson["name"].stringValue)
                            var variants: [Variant] = []
                            for (_,object) in variantsJson {
                                let attributes = object["attributes"]
                                var attributesArray: [Attribute] = []
                                for (name,value) in attributes {
                                    attributesArray.append(Attribute(name: name, value: value.stringValue))
                                }
                                variants.append(Variant(sku: object["sku"].stringValue, price: object["price"].intValue,
                                                        name: object["name"].stringValue, id: object["id"].intValue, attributes: attributesArray))
                            }
                            
                            var images: [String] = []
                            for (_,object) in imagesJson {
                                images.append(object.stringValue)
                            }
                            
                            let status = product["status"].stringValue
                            let seoDescription = product["seo_description"].stringValue
                            
                            var variantAttributes: [VariantAttribute] = []
                            for (name,object) in variantAttributesJson {
                                var choices: [String] = []
                                for (_,choice) in object {
                                    choices.append(choice.stringValue)
                                }

                                variantAttributes.append(VariantAttribute(name: name, choices: choices))
                            }

                            let seoTitle = product["seo_title"].stringValue
                            let name = product["name"].stringValue
                            
                            var attributes: [Attribute] = []
                            for(_,object) in attributesJson {
                                attributes.append(Attribute(name: object["name"].stringValue, value: object["value"].stringValue))
                            }
                            
                            let id = product["id"].intValue
                            let description = product["description"].stringValue
                            
                            let productObject = Product(price: price, productType: productType, variants: variants, images: images, status: status, seoDescription: seoDescription, variantAttributes: variantAttributes, seoTitle: seoTitle, name: name, attributes: attributes, id: id, description: description)
                            
                            completion(true, "اطلاعات محصول دریافت شد", productObject)
                        } catch {
                            completion(false, error.localizedDescription, nil)
                        }
                        
                        
                    } else {
                        completion(false, "خطایی رخ داده: \(statusCode)", nil)
                    }
                }
            } else {
                debugPrint("[getProduct] \(String(describing: response.result.error?.localizedDescription))")
                completion(false, "عدم ارتباط با سرور", nil)
            }
        }
    }
    
}













