//
//  TicketsMainView.swift
//  Chatalyze
//
//  Created by mansa infotech on 24/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class TicketsMainView:UIView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.dropShadow(color: UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1), opacity: 0.5, offSet: CGSize.zero, radius: UIDevice.current.userInterfaceIdiom == .pad ? 6:6, scale: true, layerCornerRadius: 0.0)
    }
    
}
