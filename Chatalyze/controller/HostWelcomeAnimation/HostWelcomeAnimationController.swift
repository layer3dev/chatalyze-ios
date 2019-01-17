//
//  HostWelcomeAnimationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 17/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class HostWelcomeAnimationController: InterfaceExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func setUpMyProfile(sender:UIButton){
        
        self.dismiss(animated: true) {
        }
        
//        guard let controller = SetHostProfileController.instance() else {
//            return
//        }
//        self.present(controller, animated: true) {
//        }
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

     class func instance()->HostWelcomeAnimationController?{
        
        let storyboard = UIStoryboard(name: "HostDashBoard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HostWelcomeAnimation") as? HostWelcomeAnimationController
        return controller
    }
    
}
