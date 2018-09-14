//
//  AccountContainerView.swift
//  Chatalyze
//
//  Created by Mansa on 13/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AccountContainerView: UIView {
    
    override var bounds: CGRect{
        didSet{
            Log.echo(key: "yud", text: "Self height is \(self.bounds.height)")
            AppThemeConfig.ticketHeight = CGFloat(self.bounds.height)
        }
    }
}
