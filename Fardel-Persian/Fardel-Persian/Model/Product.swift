//
//  Product.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/26/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import Foundation

struct Product {
    
    let price: Int
    let productType: ProductType
    let variants: [Variant]
    let images: [String]
    let status: String
    let seoDescription: String
    let variantAttributes: [VariantAttribute]
    let seoTitle: String
    let name: String
    let attributes: [Attribute]
    let id: Int
    let description: String
}
