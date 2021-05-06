//
//  SpotInLineView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 04/05/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import UIKit

class SpotInLineView: ExtendedView {
    
    @IBOutlet weak var spotNumberlbl : UILabel?
    @IBOutlet weak var estimatedStartTimeLbl : UILabel?

    override func viewDidLayout() {
        super.viewDidLayout()

    }
    
    func showSlotInViewInfo(withSlotNo slotNumber : String, andTime estimatedStartTime : String){
        self.isHidden = false
        self.spotNumberlbl?.text = slotNumber
        self.estimatedStartTimeLbl?.text = estimatedStartTime
    }

}
