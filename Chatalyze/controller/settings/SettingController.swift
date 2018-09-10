//
//  SettingControllerViewController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


protocol getSettingScrollInstet {
    
    func getSettingScrollInset(scrollView:UIScrollView)
}

import UIKit
import FacebookShare
import FBSDKShareKit
import SDWebImage
//import TwitterKit
//import TwitterShareExtensionUI
//import TwitterCore

class SettingController : InterfaceExtendedController {
    
    @IBOutlet var scroll:UIScrollView?
    var delegate:getSettingScrollInstet?
    
    @IBOutlet var ScheduleHeightPriority:NSLayoutConstraint?
    @IBOutlet var MySessionHeightConstraint:NSLayoutConstraint?
    
    
    @IBAction private func signoutAction(){
        
        RootControllerManager().signOut(completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    private func initialization(){
        
        initializeInterface()
        initializeVariable()
    }
    
    private func initializeVariable(){
        
        self.scroll?.delegate = self
        self.scroll?.alwaysBounceVertical = false
        self.scroll?.bounces = false
    }
    
    private func initializeInterface(){
        
        if let roleId = SignedUserInfo.sharedInstance?.role{
            
            if roleId == .analyst{
              
                ScheduleHeightPriority?.priority = UILayoutPriority(250.0)
                MySessionHeightConstraint?.priority = UILayoutPriority(250.0)
      
            }else{
                
                ScheduleHeightPriority?.priority = UILayoutPriority(999.0)
                MySessionHeightConstraint?.priority = UILayoutPriority(999.0)
            }
        }
        
        paintNavigationBar()
        //edgesForExtendedLayout = UIRectEdge()
    }
    
    private func paintNavigationBar(){
        
        paintNavigationTitle(text : "Settings")
        paintSettingButton()
        paintBackButton()
    }
    
    @IBAction func settingAction(sender:UIButton){
        
        guard let roleType = SignedUserInfo.sharedInstance?.role else {
            return
        }
        
        if roleType == .analyst{
            
            guard let controller = EditProfileHostController.instance() else {
                return
            }
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else{
            
            guard let controller = EditProfileController.instance() else {
                return
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func paymentListingAction(sender:UIButton){
        
        
        guard let roleType = SignedUserInfo.sharedInstance?.role else {
            return
        }
        if roleType == .analyst{        
            
            guard let controller = PaymentSetupPaypalController.instance() else {
                return
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            
            guard let controller = PaymentListingController.instance() else {
                return
            }            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func scheduleAction(sender:UIButton?){
        
        
        guard let controller = ScheduleSessionController.instance() else{
            return
        }
        controller.delegate = self
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func myScheduleSessions(sender:UIButton?){
        
        
        guard let controller = MyScheduledSessionsController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func aboutAction(sender:UIButton){
        
        guard let controller = TestController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
        
//        guard let controller = ContactUsController.instance() else{
//            return
//        }
//        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension SettingController{
    
    class func instance()->SettingController?{
        
        let storyboard = UIStoryboard(name: "setting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "setting") as? SettingController
        return controller
    }
}

extension SettingController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        delegate?.getSettingScrollInset(scrollView: scrollView)
        if ((scroll?.contentOffset.y ?? 0.0) >= (scroll?.contentSize.height ?? 0.0) - (scroll?.frame.size.height ?? 0.0)) {
            
            scroll?.setContentOffset(CGPoint(x: (scroll?.contentOffset.x ?? 0.0), y: (scroll?.contentSize.height ?? 0.0) - (scroll?.frame.size.height ?? 0.0)), animated: true)
        }
    }
}


extension SettingController:ScheduleSessionDelegate{
    
    func navigateToMySession(){
        
        guard let controller = MyScheduledSessionsController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

