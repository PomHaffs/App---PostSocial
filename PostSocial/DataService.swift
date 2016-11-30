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
    
    
}
