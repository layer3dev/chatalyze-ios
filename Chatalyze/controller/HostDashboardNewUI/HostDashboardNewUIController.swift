//
//  HostDashboardNewUIController.swift
//  Chatalyze
//
//  Created by mansa infotech on 28/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import Bugsnag

class HostDashboardNewUIController: InterfaceExtendedController {
    
    let updatedEventScheduleListner = EventListener()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintUI()
        eventListener()
    }
    
    func eventListener(){
        
        updatedEventScheduleListner.setListener {
            
            self.verifyForEarlyExistingCall()
        }
    }
    
    var rootView:HostNewUIRootView?{
        return self.view as? HostNewUIRootView
    }
    
    func paintUI(){
        
        paintNavigationTitle(text: "Dashboard")
        paintSettingButton()
        rootView?.paintInterface()
    }
    
    @IBAction func testmyPhone(sender:UIButton?){
        
        self.gotoSystemTest()
    }
    
    func gotoSystemTest(){
        
        guard let controller = InternetSpeedTestController.instance() else {
            return
        }
        controller.onlySystemTest = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
        })
    }
    
    
    @IBAction func mySessionAction(sender:UIButton?){
        
        guard let controller  = HostDashboardController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
   
    @IBAction func scheduleSessionAction(sender:UIButton?){
        
        guard let controller  = ScheduleSessionSinglePageController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func payOutDetailsAction(sender:UIButton?){
        
        guard let controller = PaymentSetupPaypalController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func chatScreenShotAction(sender:UIButton?){
        
        guard let controller = EditProfileController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func getInTouchAction(sender:UIButton?){
        
        guard let controller = ContactUsController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func referFriendAndEarnAction(sender:UIButton?){
        
        guard let controller = ReferralController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HostDashboardNewUIController{
    
    class func instance()->HostDashboardNewUIController?{
        
        let storyboard = UIStoryboard(name: "HostDashboardNewUI", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HostDashboardNewUI") as? HostDashboardNewUIController
        return controller
    }
}


extension HostDashboardNewUIController{
    
    func verifyForEarlyExistingCall(){
        
        VerifyForEarlyCallProcessor().verifyEarlyExistingCall { (info) in
            
            if info != nil{
                
                if let controller = RootControllerManager().getCurrentController()?.presentedViewController as? EarlyCallAlertController{
                    return
                }
                
                guard let controller = EarlyCallAlertController.instance() else{
                    return
                }
                controller.requiredDate = info?.startDate
                controller.info  = info
                
                Log.echo(key: "yud`", text: "Presented in the HostDashboard UI")
                RootControllerManager().getCurrentController()?.present(controller, animated: true, completion: nil)
            }
        }
    }
}
