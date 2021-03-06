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
            
            hostButtonContainer?.layer.cornerRadius = 5
            hostButtonContainer?.layer.masksToBounds = true
            
            attendButtonContainer?.layer.cornerRadius = 5
            attendButtonContainer?.layer.masksToBounds = true
            return
        }
        
        hostButtonContainer?.layer.cornerRadius = 3
        hostButtonContainer?.layer.masksToBounds = true
        
        attendButtonContainer?.layer.cornerRadius = 3
        attendButtonContainer?.layer.masksToBounds = true
    }

    func paintInterface(){
        
        //paintNavigationTitle(text: "CHATALYZE")
        
        roundCornerToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
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
    }
    
    @IBAction func userAction(sender:UIButton){
       
        LoginSignUpContainerController.roleId = 3
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                if let dismiss = self.dismiss{
                    dismiss()
                }
            }
        }
    }
    
    
    @IBAction func backAction(sender:UIButton?){
        
        self.dismiss(animated: true) {
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

