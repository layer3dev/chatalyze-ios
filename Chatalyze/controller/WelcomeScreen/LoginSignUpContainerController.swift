//
//  LoginSignUpContainerController.swift
//  Chatalyze
//
//  Created by Mansa on 19/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class LoginSignUpContainerController: InterfaceExtendedController {

    var pageController:WelcomePageController?
    @IBOutlet var signInTab:LoginSignUpTabView?
    @IBOutlet var signUpTab:LoginSignUpTabView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
     
        initializeVariable()
    }
    
    func initializeVariable(){
        
        paintNavigationTitle(text: "ACCOUNT")
        paintBackButton()
        
        signInTab?.tabAction(action: { (tab) in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.pageController?.setSignInTab()
                self.signUpTab?.reset()
                tab.select()
            })
            self.view.layoutIfNeeded()
        })
        
        signUpTab?.tabAction(action: { (tab) in
            
            UIView.animate(withDuration: 0.2, animations: {
             
                self.pageController?.setSignUpTab()
                self.signInTab?.reset()
                tab.select()
            })
            self.view.layoutIfNeeded()
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        pageController = segue.destination as? WelcomePageController
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

extension LoginSignUpContainerController{
    
    class func instance()->LoginSignUpContainerController?{
        
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginSignUpContainer") as? LoginSignUpContainerController
        return controller
    }
}

