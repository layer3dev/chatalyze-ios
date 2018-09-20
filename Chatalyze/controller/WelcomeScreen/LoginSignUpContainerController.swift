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
    
    override func viewDidLayout() {
        super.viewDidLayout()
     
        initializeVariable()
        paintInterface()
    }
    
    func paintInterface(){
       
        paintNavigationTitle(text: "ACCOUNT")
        paintBackButton()
    }
    
    func initializeVariable(){
        
        initializeGoogleSignIn()
        googleSignIn()
        
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
    
    
    func googleSignIn(){
        
        // Swift
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            }else{                
                print("error: \(error?.localizedDescription)");
            }
        })
        
        

        
//        pageController?.signinController?.googleSignInAction = {
//            GIDSignIn.sharedInstance().signIn()
//        }
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
        
        GIDSignIn.sharedInstance().clientID = "176675554062-sb97so193rf01hvlvgghf9ia0ma4idib.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        if (error == nil) {
            
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            print(userId)
            print(idToken)
            print(fullName)
            print(givenName)
            print(familyName)
            print(email)
            
           // loginWithGoogle(data:user)
            guard let token = idToken else{
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
            
            Log.echo(key: "yud", text: "response ")
            
        }
    }
}


