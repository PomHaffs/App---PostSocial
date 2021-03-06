//
//  DataService.swift
//  PostSocial
//
//  Created by Tomas-William Haffenden on 1/12/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import Foundation
import Firebase
//just putting 'Firebase' allows for ALL firebase dependancies
import FirebaseDatabase
import SwiftKeychainWrapper

//This will contain url of our DB for global ref - this comes from google .plist file
let DB_BASE = FIRDatabase.database().reference()

//This sets up local storage cache
let STORAGE_BASE = FIRStorage.storage().reference()


class DataService {
    
//This is singleton statement
    static let ds = DataService()
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("Posts")
    private var _REF_USERS = DB_BASE.child("Users")
    
    //Storage Rerference
    private var _REF_POST_IMAGES = STORAGE_BASE.child("PostPics")
    
    //CurrentUser Reference
 
    //GOOD coding for all private var's
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    //this is getting a uid for user and returning it
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }

                        //NEW USER-ID SETUP
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //If new data = create, if data already there = update
        //setValue = wipes ALL data and replaces
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}




















