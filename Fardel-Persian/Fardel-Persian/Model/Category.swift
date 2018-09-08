//
//  Category.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/21/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import Foundation

struct Category {
    
    private(set) public var id: Int
    private(set) public var subCategories: [Category]
    private(set) public var name: String
    
    init() {
        self.id = 0
        self.subCategories = []
        self.name = ""
    }
    
    init(id: Int, subCategories: [Category], name: String) {
        self.id = id
        self.subCategories = subCategories
        self.name = name
    }
}
