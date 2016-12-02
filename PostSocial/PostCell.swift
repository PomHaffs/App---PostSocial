//
//  PostCell.swift
//  PostSocial
//
//  Created by Tomas-William Haffenden on 30/11/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesButton: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //setting like button functions
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        
    }
    
    //Downloading and saving them to cache - UIImage has default value of 'nil'
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        
        likesRef = DataService.ds.REF_USER_CURRENT.child("Likes").child(post.postId)
        self.caption.text = post.caption
        self.likesButton.text = "\(post.likes)"
        
        //2MB storage this is downloading img
        if img != nil {
            self.postImage.image = img
        } else {
                let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("TOM: Unable to download image from Firebase")
                    } else {
                        print("TOM: Image downloaded correctly")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.postImage.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                            }
                        }
                    }
            })
        }
        //this will ref like and observe a SINGLE event, NSNull refers to firebase empty value
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        })
        
    }
    
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.setValue(false)
            }
        })
    }
}
