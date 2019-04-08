//
//  EmptySlotsCells.swift
//  Chatalyze
//
//  Created by mansa infotech on 08/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class EmptySlotsCells:ExtendedCollectionCell {

    @IBOutlet var cellView:UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cellView?.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#929292").cgColor
        self.cellView?.layer.masksToBounds = true
    }
    
    
    
}
