//
//  Post.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/16/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import Foundation

struct Post {
    
    private(set) public var id: Int
    private(set) public var title: String
    private(set) public var content: String
    private(set) public var allowComment: Bool
    private(set) public var category: String
    private(set) public var image: String
    private(set) public var commentsCount: Int
    private(set) public var createdTime: Int
    private(set) public var updateTime: Int
    private(set) public var summarized: String
    
    init() {
        
        self.id = 0
        self.title = ""
        self.content = ""
        self.allowComment = false
        self.category = ""
        self.image = ""
        self.commentsCount = 0
        self.createdTime = 0
        self.updateTime = 0
        self.summarized = ""
    }
    
    init(id: Int, title: String, content: String, allowComment: Bool, category: String, image: String, commentsCount: Int, createdTime: Int, updateTime: Int, summarized: String) {
        
        self.id = id
        self.title = title
        self.content = content
        self.allowComment = allowComment
        self.category = category
        self.image = image
        self.commentsCount = commentsCount
        self.createdTime = createdTime
        self.updateTime = updateTime
        self.summarized = summarized
    }
}
