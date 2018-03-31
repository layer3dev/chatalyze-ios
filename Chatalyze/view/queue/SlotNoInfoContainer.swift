//
//  SlotNoInfoContainer.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SlotNoInfoContainer: ExtendedView {

    @IBOutlet private var zeroHeightPriority: NSLayoutConstraint?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    
    private func initialization(){
        guard let role = SignedUserInfo.sharedInstance?.role
            else{
                return
        }
        
        if(role == .analyst){
            zeroHeightPriority?.priority = UILayoutPriority(999)
        }else{
            zeroHeightPriority?.priority = UILayoutPriority(1.0)
        }
    }

}
