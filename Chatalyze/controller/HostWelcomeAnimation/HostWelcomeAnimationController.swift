//
//  HostWelcomeAnimationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 17/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import Analytics

class HostWelcomeAnimationController: InterfaceExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SEGAnalytics.shared().track("Welcome Host Page")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setUpMyProfile(sender:UIButton){
        
//        DispatchQueue.main.async {
//
//            UserDefaults.standard.removeObject(forKey: "isHostWelcomeScreenNeedToShow")
//            self.dismiss(animated: true, completion: {
//            })
//        }
        
        guard let controller = SetHostProfileController.instance() else {
            return
        }
        
        self.present(controller, animated: true) {
        }
        
        // We are not releasing this feature with this version of release on AppStore
        
//        guard let controller = HostCategoryController.instance() else {
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
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HostWelcomeAnimation") as? HostWelcomeAnimationController
        return controller
    }
}
