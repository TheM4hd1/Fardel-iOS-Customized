//
//  APIUrls.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/5/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import Foundation

// Mark: - RESTful API URLs

let URL_REGISTER = "\(BASE_URL)/api/auth/register/"
let URL_LOGIN = "\(BASE_URL)/api/auth/login/"
let URL_REFRESH_TOKEN = "\(BASE_URL)/api/auth/refresh-token/"
let URL_PROFILE = "\(BASE_URL)/api/auth/profile/"
let URL_LOGOUT = "\(BASE_URL)/api/auth/logout/"
let URL_REFRESH_LOGOUT = "\(BASE_URL)/api/auth/logout-refresh/"
let URL_POSTS = "\(BASE_URL)/api/blog/posts/" // URL_POSTS/<postid>
let URL_SEARCH = "\(BASE_URL)/api/search/?q="
let URL_CATEGORIES = "\(BASE_URL)/api/ecommerce/categories/" // URL_CATEGORIES/<category_name>/products/
let URL_PRODUCTS = "\(BASE_URL)/api/ecommerce/products/"
