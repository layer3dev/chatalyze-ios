//
//  SetHostProfileController.swift
//  Chatalyze
//
//  Created by mansa infotech on 17/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SetHostProfileController: UIViewController {

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
    
    @IBAction func revealMyProfile(sender:UIButton){
        
        UserDefaults.standard.removeObject(forKey: "isHostWelcomeScreenNeedToShow")
        self.dismiss(animated: true) {
            
        }
    }
    
    class func instance()->SetHostProfileController?{
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SetHostProfile") as? SetHostProfileController
        return controller
    }


}
