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

//This will contain url of our DB for global ref - this comes from google .plist file
let DB_BASE = FIRDatabase.database().reference()


class DataService {
    
//This is singleton statement
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("Posts")
    private var _REF_USERS = DB_BASE.child("Users")
 
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

                        //NEW USER-ID SETUP
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
//If new data = create, if data already there = update
//setValue = wipes ALL data and replaces
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}




















