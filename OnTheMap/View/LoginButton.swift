//
//  LoginButton.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 24.04.21.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.primaryLight
    }
    
}
