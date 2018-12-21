//
//  PageViewDotsUIPaint.swift
//  Chatalyze
//
//  Created by Mansa on 21/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class PageViewDotsUIPaint: ExtendedView {
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }
    
}
