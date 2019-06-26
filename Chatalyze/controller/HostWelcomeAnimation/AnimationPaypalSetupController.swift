//
//  AnimationPaypalSetupController.swift
//  Chatalyze
//
//  Created by mansa infotech on 26/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AnimationPaypalSetupController: PaymentSetupPaypalController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func skipAction(sender:UIButton?){        
        
        UserDefaults.standard.removeObject(forKey: "isHostWelcomeScreenNeedToShow")        
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
        })
        
    }
    
    override class func instance()->AnimationPaypalSetupController? {
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AnimationPaypalSetup") as? AnimationPaypalSetupController
        return controller
    }
    
    /*
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
