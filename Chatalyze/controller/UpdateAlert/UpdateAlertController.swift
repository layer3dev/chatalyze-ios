//
//  UpdateAlertController.swift
//  Chatalyze
//
//  Created by Mansa on 07/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class UpdateAlertController: InterfaceExtendedController {

    override func viewDidLayout() {
        super.viewDidLayout()
    
    }
    
    @IBAction func exit(sender:UIButton){
        
        self.dismiss(animated: true) {
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->UpdateAlertController?{
        
        let storyboard = UIStoryboard(name: "UpdateAlert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UpdateAlert") as? UpdateAlertController
        return controller
    }
}
