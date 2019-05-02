//
//  RoundCornerViews.swift
//  Chatalyze
//
//  Created by mansa infotech on 02/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit


class RoundCornerViews: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.masksToBounds = true
        
    }
    
}
