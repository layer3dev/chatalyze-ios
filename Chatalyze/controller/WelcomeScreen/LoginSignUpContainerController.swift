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
    static var roleId = 0
    
    override func viewDidLayout() {
        super.viewDidLayout()
     
        initializeVariable()
        paintInterface()
        initializeForForGotPasswordNavigation()
        //verifyRoleId()
    }
    func initializeForForGotPasswordNavigation(){
     
        pageController?.signinController?.signUpHandler =  {
        
            self.pageController?.setSignUpTab()
            self.signInTab?.reset()
            self.signUpTab?.select()
            self.showWelcomeScreen(response: {
            })
        }
    }
    
    
    func verifyRoleId(){
        
        if LoginSignUpContainerController.roleId == 0 {
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: false)
            }
        }
        else if LoginSignUpContainerController.roleId == 2{
            
            Log.echo(key: "yud", text: "It is the Analyst \(LoginSignUpContainerController.roleId)")
        }
        else if LoginSignUpContainerController.roleId == 3{
            
            Log.echo(key: "yud", text: "It is the user \(LoginSignUpContainerController.roleId)")
        }
        else{
            
            Log.echo(key: "yud", text: "Unauthorised access")
        }
    }
    
    
    func paintInterface(){
       
        //paintNavigationTitle(text: "ACCOUNT")
        //paintBackButton()
        //paintHideBackButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    func showWelcomeScreen(response:@escaping (()->())){
        
        guard let controller = WelcomeController.instance() else {
            return
        }
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.dismiss = {
            response()
        }
        self.present(controller, animated: true, completion: {
        })
    }
    
    
    
    func initializeVariable(){
        
        
        signInTab?.tabAction(action: { (tab) in
           
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.pageController?.setSignInTab()
                    self.signUpTab?.reset()
                    tab.select()
                })
                self.view.layoutIfNeeded()
            //self.showWelcomeScreen()            
        })
        
        signUpTab?.tabAction(action: { (tab) in
          
            //self.showWelcomeScreen()
            self.showWelcomeScreen(response:{
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.pageController?.setSignUpTab()
                    self.signInTab?.reset()
                    tab.select()
                })
                self.view.layoutIfNeeded()
            })
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




