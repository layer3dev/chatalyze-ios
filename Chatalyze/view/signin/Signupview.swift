//
//  Signupview.swift
//  Chatalyze
//
//  Created by Mansa on 02/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class Signupview: ExtendedView {
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    fileprivate func initialization(){
        
        layoutUI()
    }
    
    func layoutUI(){
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
        self.layer.borderColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1).cgColor
        self.layer.masksToBounds = true
    }
}
