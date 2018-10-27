//
//  OpenCallAlertController.swift
//  Chatalyze
//
//  Created by Mansa on 14/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class OpenCallAlertController: InterfaceExtendedController {
   
    var dismissHandler:(()->())?
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    
    @IBAction func dissmissAction(sender:UIButton){
        
        self.dismiss(animated: true) {
            if let dismissSelf = self.dismissHandler{
                dismissSelf()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OpenCallAlertController{
    
    class func instance()->OpenCallAlertController?{
        
        let storyboard = UIStoryboard(name: "call_view", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "OpenCallAlertController") as? OpenCallAlertController
        return controller
    }
}

