//
//  FieldShadow.swift
//  PostSocial
//
//  Created by Tomas-William Haffenden on 29/11/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import UIKit

class FieldShadow: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.4).cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 2.0
    }

    
//This effects the display
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
//This does the same for editing
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
