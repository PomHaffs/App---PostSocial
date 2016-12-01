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


//added in UITVDelegate and UITVDSource, then add in protocols
//added in UIIPickerDel & UINavConDel to get camera access
class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    //Takes class created in PostModel and passes them into array
    var posts = [Post]()
    //Imagepicker
    var imagePicker: UIImagePickerController!
    //This ensures you cannot send the button(image) as an image
    var imageSelected = false
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //creates an instance
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        //LISTENER for POSTS - loops
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postId: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            //NOTE!!! this is needed for 
            self.tableView.reloadData()
        })
    }
 
    //NEEDED for tableview x 3
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post, img: nil)
                return cell
            }
            
        } else {
            return PostCell()
        }
    }
    
    
                                //IMAGE ADDING

    @IBOutlet weak var imageAdd: RoundedImageView!
    //Once EDITED img is selected imgPicker disappears
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //allows for edited img
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            //to make sure we don't post button image
            imageSelected = true
        } else {
            print("A valid image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
 
                                //POSTING LOGIC
    
    @IBOutlet weak var captionField: FieldShadow!
    
    @IBAction func postButtonPressed(_ sender: Any) {
        //guard let mean func run if statment is NOT true
        guard let caption = captionField.text, caption != "" else {
           print("TOM: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("TOM: Image must be selected")
            return
        }
        //this converts to JPEG and compresses img
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            //creates uid for image and sets the metadata to JPEG
            let imageUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            //Uploading image to firebase
            DataService.ds.REF_POST_IMAGES.child(imageUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("TOM: Unable to uplaod image to firebase storage")
                } else {
                    print("TOM: Successsfully loaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imageUrl: url)
                    }
                }
            }
        }
    }
    
                            //POSTING TO FIREBASE
    func postToFirebase(imageUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "Caption": captionField.text! as AnyObject,
            "ImageURL": imageUrl as AnyObject,
            "Likes": 0 as AnyObject
        ]
        //auto creates a UID so we can post
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        //resets image to button image
        imageAdd.image = UIImage(named: "add-image")
        
        //to reload stuff to app
        tableView.reloadData()
    }
    
    
    //take us back to signin screen = sign out button
    @IBAction func signOutPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("TOM: successful sign out - \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToHome", sender: nil)
        
        
    }
    
    
    
    
    
}
