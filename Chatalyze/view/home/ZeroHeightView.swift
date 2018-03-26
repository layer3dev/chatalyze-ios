
//
//  ZeroHeightView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ZeroHeightView: ExtendedView {
    
    @IBOutlet private var zeroHeight : NSLayoutConstraint?
    @IBOutlet private var bottomConstraint : NSLayoutConstraint?
    
    let highPriority = Float(991)
    let lowPriority = Float(1)
    
    let bottomHightPriority = Float(999)
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func hideView(){
        zeroHeight?.priority = UILayoutPriority(rawValue: highPriority)
        bottomConstraint?.priority = UILayoutPriority(rawValue : lowPriority)
    }
    
    func showView(){
        zeroHeight?.priority = UILayoutPriority(rawValue: lowPriority)
        bottomConstraint?.priority = UILayoutPriority(rawValue : bottomHightPriority)
    }

}
