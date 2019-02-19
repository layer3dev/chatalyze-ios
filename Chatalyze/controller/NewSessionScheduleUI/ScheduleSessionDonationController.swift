//
//  ScheduleSessionDonationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class ScheduleSessionDonationController: ScheduleSessionScreenShotAllowController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override class func instance()->ScheduleSessionDonationController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionDonation") as? ScheduleSessionDonationController
        return controller
    }
}
