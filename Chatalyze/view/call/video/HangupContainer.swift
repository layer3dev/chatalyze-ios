
//
//  HangupContainer.swift
//  Rumpur
//
//  Created by Sumant Handa on 20/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class HangupContainer: ExtendedView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }

}
