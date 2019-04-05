//
//  ThreeSidedRoundedView.swift
//  Chatalyze
//
//  Created by mansa infotech on 05/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
class ThreeSidedRoundedView:UIView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners(corners: [.topLeft,.topRight,.bottomRight], radius: (UIDevice.current.userInterfaceIdiom == .pad ? 35:25))
    }
    
}
