//
//  SigninButtonContainer.swift
//  Chatalyze
//
//  Created by Sumant Handa on 24/02/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SigninButtonContainer: ExtendedView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    fileprivate func initialization(){
        
        layer.cornerRadius = 3.0
        clipsToBounds = true
    }

}
