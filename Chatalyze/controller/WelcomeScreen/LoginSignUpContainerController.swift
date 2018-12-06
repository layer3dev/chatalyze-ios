//
//  LoginSignUpContainerController.swift
//  Chatalyze
//
//  Created by Mansa on 19/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import GoogleSignIn
import TwitterKit


class LoginSignUpContainerController: InterfaceExtendedController {

    var pageController:WelcomePageController?
    @IBOutlet var signInTab:LoginSignUpTabView?
    @IBOutlet var signUpTab:LoginSignUpTabView?
    var googleSignInAction:(()->())?
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
    
    func setGoogleSignInAction(){
     
        //initializing Action in order to get the Google Sign in Action
        googleSignIn()
    }
    
    func initializeVariable(){
        
        initializeGoogleSignIn()
        setGoogleSignInAction()
        
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
    
    
    func googleSignIn(){
        
        self.pageController?.signinController?.googleSignInAction = {
            
            self.showWelcomeScreen(response: {
                GIDSignIn.sharedInstance()?.signOut()
                GIDSignIn.sharedInstance().signIn()
            })
        }
        
        
        self.pageController?.signUpController?.googleSignInAction = {
            
            self.showWelcomeScreen(response: {
                GIDSignIn.sharedInstance()?.signOut()
                GIDSignIn.sharedInstance().signIn()
            })
        }
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

extension LoginSignUpContainerController: GIDSignInDelegate, GIDSignInUIDelegate{
    
    fileprivate func initializeGoogleSignIn(){
        
       
        GIDSignIn.sharedInstance().clientID = "1084817921581-q7mnvrhvbsh3gkudbq52d47v2khle66s.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.serverClientID = "1084817921581-qihsa275kmr3s4g4qn5rclm9294h86ns.apps.googleusercontent.com"
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        if (error == nil) {
            
            // Perform any operations on signed in user here.
        
            let userId = user.userID                  // For client-side use only!
            let idToken = user.serverAuthCode
            // Safe to send to the
            //server
            let idTokenAuth = user.authentication.accessToken
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            print(userId)
            print(idToken)
            print(idTokenAuth)
            print(fullName)
            print(givenName)
            print(familyName)
            print(email)
            
           // loginWithGoogle(data:user)
            guard let token = idTokenAuth else{
                return
            }
            googleSignProcessor(accessToken:token)
            GIDSignIn.sharedInstance().signOut()
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        self.present(viewController, animated: true) {
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true) {

            GIDSignIn.sharedInstance().signOut()
        }
    }    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
    
    func googleSignProcessor(accessToken:String){
        
        GoogleSignIn().signin(accessToken: accessToken) { (success, message, info) in
            
            Log.echo(key: "yud", text: "response")
        }
    }
}


