//
//  AchievmentsController.swift
//  Chatalyze
//
//  Created by mansa infotech on 18/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AchievmentsController: InterfaceExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paintInterface()
    }
    
    @IBAction func backAction(sender:UIButton?){        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func paintInterface(){
        
        self.hideNavigationBar()
        self.paintHideBackButton()
    }
    
    /*
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->AchievmentsController?{
        
        let storyboard = UIStoryboard(name: "Achievements", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Achievments") as? AchievmentsController
        return controller
    }
    
}
