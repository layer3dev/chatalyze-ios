//
//  EditProfileController.swift
//  Chatalyze
//
//  Created by Mansa on 16/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EditProfileController: InterfaceExtendedController {
    
    @IBOutlet var rootView:EditProfileRootview?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
        initializationVariable()
        fetchInfo()
    }
    
    func fetchInfo(){
        
        self.showLoader()
        FetchProfileProcessor().fetch { (success, message, response) in
            
            self.stopLoader()
            if success{
                
                self.rootView?.fillInfo()
            }
            else{
                self.alert(withTitle: AppInfoConfig.appName, message: message, successTitle: "Ok", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func painInterface(){
        
        paintBackButton()
        paintSettingButton()
    }
    
    func initializationVariable(){
        
        rootView?.controller = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "Edit Profile")
    }
    
    class func instance()->EditProfileController?{
        
        let storyboard = UIStoryboard(name: "EditProfile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditProfile") as? EditProfileController
        return controller
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EditProfileController{
}

