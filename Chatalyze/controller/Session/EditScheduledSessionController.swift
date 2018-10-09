//
//  EditScheduledSessionController.swift
//  Chatalyze
//
//  Created by Yudhisther on 30/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EditScheduledSessionController: InterfaceExtendedController {
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        rootView?.controller = self
        paintIntreface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootView?.paintImageUploadBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "Edit Schedule Session")
    }
    
    func paintIntreface(){
        
        paintBackButton()
        paintSettingButton()
    }
 
    func fillInfo(param:[String:Any],totalDurationofEvent:Int,selectedImage:UIImage?){
        
        rootView?.fillInfo(info: param,totalDurationofEvent:totalDurationofEvent,selectedImage:selectedImage)
    }
    
    var rootView:EditScheduledSessionRootView?{
        
        get{
            return self.view as? EditScheduledSessionRootView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated.
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

extension EditScheduledSessionController{
    
    class func instance()->EditScheduledSessionController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSession", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditScheduledSession") as? EditScheduledSessionController
        return controller
    }
}
