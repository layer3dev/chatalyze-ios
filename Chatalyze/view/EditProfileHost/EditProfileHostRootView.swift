//
//  EditProfileHostRootView.swift
//  Chatalyze
//
//  Created by Mansa on 27/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import Foundation

class EditProfileHostRootView : EditProfileRootview {
    
    override func saveMainInfo(){
        
        var param = [String:Any]()
        
        param["firstName"] = nameField?.textField?.text
        param["email"] = emailField?.textField?.text
        param["description"] = shortBioTextView?.text
        
        Log.echo(key: "yud", text: "params are \(param)")
        
        self.controller?.showLoader()
        EditProfileProcessor().edit(params: param) { (success, message, response) in
            
            self.controller?.stopLoader()
            Log.echo(key: "yud", text: "the velue of the success is \(success)")
            
            if !success{
                
                self.controller?.stopLoader()
                self.mainInfoError?.text = message
                return
            }
            
            self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Profile updated".localized() ?? "", successTitle: "Ok".localized() ?? "", rejectTitle: "Cancel".localized() ?? "", showCancel: false, completion: { (success) in
                
                self.fetchProfile()
            })
        }
        Log.echo(key: "yud", text: "Please save the mainInfo data acces granted!!")
    }
    
    override func validateMainInfo()->Bool{
        
        resetMainInfoError()
        let nameValidate = validateName()
        let emailValidated  = validateEmail()
        let bioValidate = validateBio()
        return nameValidate && emailValidated && bioValidate
    }
    
}
