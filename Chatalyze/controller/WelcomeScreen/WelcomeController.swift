//
//  WelcomeController.swift
//  Chatalyze
//
//  Created by Mansa on 19/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class WelcomeController: InterfaceExtendedController {

    var dismiss:(()->())?
    @IBOutlet var hostButtonContainer:UIView?
    @IBOutlet var attendButtonContainer:UIView?

    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
    }
    
    func roundCornerToView(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            hostButtonContainer?.layer.cornerRadius = 7
            hostButtonContainer?.layer.masksToBounds = true
            
            attendButtonContainer?.layer.cornerRadius = 7
            attendButtonContainer?.layer.masksToBounds = true
            return
        }
        
        hostButtonContainer?.layer.cornerRadius = 4
        hostButtonContainer?.layer.masksToBounds = true
        
        attendButtonContainer?.layer.cornerRadius = 4
        attendButtonContainer?.layer.masksToBounds = true
    }

    func paintInterface(){
        
        //paintNavigationTitle(text: "CHATALYZE")
        hideNavigationBar()
        roundCornerToView()
    }
    
    @IBAction func hostAction(sender:UIButton){
        
        LoginSignUpContainerController.roleId = 2
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                if let dismiss = self.dismiss{
                    dismiss()
                }
            }
        }
        
//        guard let controller = LoginSignUpContainerController.instance() else{
//            return
//        }
//        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func userAction(sender:UIButton){
       
        LoginSignUpContainerController.roleId = 3
        
//        guard let controller = LoginSignUpContainerController.instance() else{
//            return
//        }
//        self.navigationController?.pushViewController(controller, animated: true)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                if let dismiss = self.dismiss{
                    dismiss()
                }
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

extension WelcomeController{
    
    class func instance()->WelcomeController?{
        
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Welcome") as? WelcomeController
        return controller
    }
}

