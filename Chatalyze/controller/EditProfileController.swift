//
//  EditProfileController.swift
//  Chatalyze
//
//  Created by Mansa on 16/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import CountryPicker

class EditProfileController: InterfaceExtendedController {
    
    
    @IBOutlet var rootView:EditProfileRootview?
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
        initializationVariable()
    }

    func painInterface(){
        
        paintNavigationTitle(text: "EDIT PROFILE")
        paintBackButton()
    }
    
    func initializationVariable(){
        
        rootView?.controller = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EditProfileController{
    
    class func instance()->EditProfileController?{
        
        let storyboard = UIStoryboard(name: "EditProfile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditProfile") as? EditProfileController
        return controller
    }
}

