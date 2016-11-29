//
//  ShadowView.swift
//  PostSocial
//
//  Created by Tomas-William Haffenden on 29/11/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 8.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }

}

//Added a constant (SHADOW - color) which can be used globally 
