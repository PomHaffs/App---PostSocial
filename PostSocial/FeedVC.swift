//
//  FeedVC.swift
//  PostSocial
//
//  Created by Tomas-William Haffenden on 29/11/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
//take us back to signin screen, sign out
    @IBAction func signOutPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("TOM: successful sign out - \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToHome", sender: nil)
        
        
    }
    
    
    
    
    
}
