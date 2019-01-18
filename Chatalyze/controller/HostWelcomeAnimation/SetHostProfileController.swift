//
//  SetHostProfileController.swift
//  Chatalyze
//
//  Created by mansa infotech on 17/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SetHostProfileController: InterfaceExtendedController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rootView?.controller = self
    }
    
    var rootView:SetProfileRootView?{
        return self.view as? SetProfileRootView
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func revealMyProfile(sender:UIButton){
        
        if !(rootView?.validateField() ?? false)   {
            return
        }
        guard let  param = rootView?.getParam() else{
            return
        }
        guard let image = rootView?.getImage() else{
            return
        }
        
        self.showLoader()
        
        UploadUserImage().uploadImageFormatData(image: image, includeToken: true, params : param, progress: { (progress) in
            
            self.stopLoader()
            
        }) {(success) in
            
            if success{
                
                DispatchQueue.main.async {
                    
                    UserDefaults.standard.removeObject(forKey: "isHostWelcomeScreenNeedToShow")
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                    })
                }
                return
            }
        }
    }
    
    class func instance()->SetHostProfileController?{
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SetHostProfile") as? SetHostProfileController
        return controller
    }
    
}
