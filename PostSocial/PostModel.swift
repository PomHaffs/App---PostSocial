//
//  PostModel.swift
//  PostSocial
//
//  Created by Tomas-William Haffenden on 1/12/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import Foundation

class Post {
    
    private var _caption: String!
    private var _likes: Int!
    private var _imageUrl: String!
    private var _postId: String!
    //private var _userId: String!
    
    var caption: String {
        return _caption
    }
    
    var likes: Int {
        return _likes
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var postId: String {
        return _postId
    }
    
//    var userId: String {
//        return _userId
//    }
    
    init(caption: String, likes: Int, imageUrl: String) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postId: String, postData: Dictionary<String, AnyObject>) {
        self._postId = postId
        
        if let caption = postData["Caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["ImageURL"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["Likes"] as? Int {
            self._likes = likes
        }
        
        
        
    }
    
    
}
