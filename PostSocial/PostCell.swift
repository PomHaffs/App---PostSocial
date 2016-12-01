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
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Downloading and saving them to cache - UIImage has default value of 'nil'
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
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
    }
    
}
