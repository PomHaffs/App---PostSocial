//
//  RoundedImageView.swift
//  PostSocial
//
//  Created by Tomas-William Haffenden on 30/11/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 8.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 5.0
        
    }
    
    
//    override func draw(_ rect: CGRect) {
//        super.draw(<#T##rect: CGRect##CGRect#>)
//        layer.cornerRadius = 8.0
//    }
}
