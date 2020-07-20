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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintUI()
      rootView?.paintInterface()
        self.checkForShowingHostWelcomeAnimation()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        rootView?.paintInterface()
        //self.changeOrientationToPortrait()
    }
    
    
    func checkForShowingHostWelcomeAnimation(){
        
        //This method is responsible to showing the new signUp animation for only Hosts.
        guard let isRequired = UserDefaults.standard.value(forKey: "isHostWelcomeScreenNeedToShow") as? Bool else {
            return
        }
        
        if !isRequired{
            return
        }
        
        guard let controller = HostWelcomeAnimationController.instance() else {
            return
        }
        
        controller.modalPresentationStyle = .fullScreen

        
        self.present(controller, animated: true, completion: {
        })
    }
//  private func showTermsAndCondtionsPageForOrganizationHost(){
//
//
//    guard let organizationId = SignedUserInfo.sharedInstance?.organizationId else {return}
//
//    if organizationId == ""{
//      return
//    }
//    guard let isTermsAceepted = SignedUserInfo.sharedInstance?.isTermsAccepted else {
//      return
//    }
//
//    if isTermsAceepted{
//      print("Terms and Condtion are already accepted for organization Id\(organizationId)")
//      return
//    }else{
//      print("Terms and Condtion not acceptedfor organization Id\(organizationId)")
//    }
//
//    let vc = HostTermsAndContions()
//    vc.modalPresentationStyle = .fullScreen
//    navigationController?.present(vc, animated: true, completion: nil)
//  }
    
    var rootView:HostNewUIRootView?{
        return self.view as? HostNewUIRootView
    }
    
    func paintUI(){
        
        paintNavigationTitle(text: "Dashboard")
        paintSettingButton()        
    }
    
    
    @IBAction func testmyPhone(sender:UIButton?){
        
         DispatchQueue.main.async {
               self.validateVPN {
                 Log.echo(key: "dhi", text: "validate VPN response on SystemCheck")
                self.gotoSystemTest()
               }
             }
    }
  private func validateVPN(completion : (()->())?){
         ValidateVPN().showVPNWarningAlert {
             completion?()
         }
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
        
//        guard let controller = HostWelcomeAnimationController.instance() else{
//            return
//        }
//
//        self.present(controller, animated: true) {
//        }
        
        guard let controller = HostDashboardController.instance() else{
            return
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
   
    @IBAction func scheduleSessionAction(sender:UIButton?){
        
        DispatchQueue.main.async {
            
            
            guard let controller  = ScheduleSessionSinglePageController.instance() else{
                return
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    @IBAction func payOutDetailsAction(sender:UIButton?){
        
        guard let controller = PaymentSetupPaypalController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func chatScreenShotAction(sender:UIButton?){
        
        guard let controller = EditProfileHostController.instance() else{
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
        
        guard let controller = ReferralController.instance() else {
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


    
