//
//  SignInVC.swift
//  PostSocial
//
//  Created by Tomas-William Haffenden on 29/11/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

//You CANNOT perform segue in view did load...its too early...
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: SEGUE_FEED, sender: nil)
        }
    }

    
//Authenticate with FB - REMEMBER to decrypt the fucking secret!
    @IBAction func facebookButtonPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("TOM: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("TOM: User cancelled Facebook authentication")
            } else {
                print("TOM: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
        }
    }
    
//NOTE: outlet means to take out some information...thats it!
    @IBOutlet weak var emailField: FieldShadow!    
    @IBOutlet weak var passwordField: FieldShadow!
    
//Authenticate with email/password - always do AlreadyUser stuff first THEN NewUser and errors
    @IBAction func signinButtonPressed(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("TOM: User email login authenticated")
                    if let user = user {
                     self.completeSignin(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("TOM: Unable to authenticate with email")
                        } else {
                            print("TOM - Successfully authenticated with email")
                            self.completeSignin(id: user!.uid)
                        }
                    })
                }
            })
        }
        
    }
    
//Generic sign in for multiple use
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("TOM: Unable to authenticate with Firebase - \(error)")
                print("\(error)")
            } else {
                print("TOM: Successfully authenticated with Firebase")
                if let user = user {
                     self.completeSignin(id: user.uid)
                }
            }
        })
    }

//Good code because this would appear in more than one place - Contants.swift
//NOTE passing in an 'id' is required
    func completeSignin(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("TOM: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: SEGUE_FEED, sender: nil)
    }
    
    
}

