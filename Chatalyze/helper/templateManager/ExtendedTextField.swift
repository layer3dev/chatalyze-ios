//
//  ExtendedTextField.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 26/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit

class ExtendedTextField: UITextField {

    private var isLoaded = false;
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!isLoaded){
            isLoaded = true
            viewDidLayout()
        }
    }
    
    func viewDidLayout(){
        
    }

}
