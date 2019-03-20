//
//  ContactUsWithoutUserIdController.swift
//  Chatalyze
//
//  Created by mansa infotech on 05/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class ContactUsWithoutUserIdController:ContactUsController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func painteInterface(){
        
        hideNavigationBar()
        initializeVariable()
        paintBorder()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    override func submit(){
        
        guard let email = emailField?.text else {
            return
        }
        
        guard let name = nameField?.text else {
            return
        }
        
        if name == ""{
            
            self.alert(withTitle: AppInfoConfig.appName, message: "Name field can't be left empty.", successTitle: "Ok", rejectTitle: "", showCancel: false) { (success) in
            }
        }
        
        if email == ""{
            
            self.alert(withTitle: AppInfoConfig.appName, message: "Email field can't be left empty.", successTitle: "Ok", rejectTitle: "", showCancel: false) { (success) in
            }
        }
        
        let emailValidator = FieldValidator().validateEmailFormat(email)
        
        if !emailValidator{
            
            self.alert(withTitle: AppInfoConfig.appName, message: "Email looks incorrect.", successTitle: "Ok", rejectTitle: "", showCancel: false) { (success) in
            }
            return
        }
        
        let text  = contactTextView?.text.replacingOccurrences(of: " ", with: "")
        
        if text == ""{
            
            self.alert(withTitle: AppInfoConfig.appName, message: "Message field cannot be blank", showCancel: false, completion: { (success) in
            })
            return
        }
        
        guard let getmessage = contactTextView?.text else{
            return
        }
        
        self.showLoader()
        submitContactUsRequest().contactUs(email: email, message: getmessage, name: name) { (success) in
            self.stopLoader()
            if(!success){
                
                //                self.alert(withTitle: AppInfoConfig.appName, message: "Error", showCancel: false, completion: { (success) in
                //                })
                
                self.alert(withTitle: AppInfoConfig.appName, message: "Thank you for your message. We'll get back to you shortly!", showCancel: false, completion: { (success) in
                    
                    self.contactTextView?.text = ""
                    self.contactPlaceholderLbl?.text = "Enter Message"
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
                return
            }
            self.alert(withTitle: AppInfoConfig.appName, message: "Thank you for your message. We'll get back to you shortly!", showCancel: false, completion: { (success) in
                self.contactTextView?.text = ""
                self.contactPlaceholderLbl?.text = "Enter Message";
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
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
    
    override class func instance()->ContactUsWithoutUserIdController?{
        
        let storyboard = UIStoryboard(name: "ContactUs", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ContactUsWithoutUserId") as? ContactUsWithoutUserIdController
        return controller
    }
}
