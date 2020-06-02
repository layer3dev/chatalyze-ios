//
//  DonationSuccessRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class DonationSuccessRootView: ExtendedView {
    
    @IBOutlet private var successMessageLabel : UILabel?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLayout(){
        super.viewDidLayout()
    }
    
    private func initialization(){
    }
    
    func fillInfo(price : Double, scheduleInfo : EventScheduleInfo?){
        
        guard let scheduleInfo = scheduleInfo
            else{
                return
        }
        let influencer = scheduleInfo.user
        let _ = influencer?.fullName ?? ""
        successMessageLabel?.text = "You just gave a $\(price) donation. You're awesome!"
    }
}
