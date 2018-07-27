//
//  HostVideoActionContainer.swift
//  Chatalyze
//
//  Created by Sumant Handa on 26/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostVideoActionContainer: VideoActionContainer {
    
    @IBOutlet var hangupView : HangupActionView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    private func initialization(){
    }

}
