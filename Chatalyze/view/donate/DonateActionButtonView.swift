//
//  DonateActionButtonView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class DonateActionButtonView: ExtendedView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        initialization()
    }
    
    private func initialization(){
        self.layer.cornerRadius = self.bounds.size.height/2
        self.clipsToBounds = true
    }

}
