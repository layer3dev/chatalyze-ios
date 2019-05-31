//
//  MemoryShareShadowView.swift
//  Chatalyze
//
//  Created by mansa infotech on 16/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class MemoryShareShadowView:UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        
        self.dropShadow(color: UIColor.darkGray, offSet: CGSize.zero, radius: UIDevice.current.userInterfaceIdiom == .pad ? 18:15, scale: true,layerCornerRadius:UIDevice.current.userInterfaceIdiom == .pad ? 5:3)
    }
}
