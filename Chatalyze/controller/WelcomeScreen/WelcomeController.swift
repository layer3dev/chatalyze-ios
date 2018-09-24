//
//  WelcomeController.swift
//  Chatalyze
//
//  Created by Mansa on 19/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class WelcomeController: InterfaceExtendedController {

    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
    }

    func paintInterface(){
        
        paintNavigationTitle(text: "CHATALYZE")
    }
    
    @IBAction func hostAction(sender:UIButton){
        
        LoginSignUpContainerController.roleId = 2
        
        guard let controller = LoginSignUpContainerController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func userAction(sender:UIButton){
       
        LoginSignUpContainerController.roleId = 3
        
        guard let controller = LoginSignUpContainerController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
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

extension WelcomeController{
    
    class func instance()->WelcomeController?{
        
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Welcome") as? WelcomeController
        return controller
    }
}

