//
//  AccountRootView.swift
//  Chatalyze
//
//  Created by Mansa on 17/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AccountRootView: ExtendedView {
    
    var controller:AccountController?
    
    @IBOutlet var userName:UILabel?
    
    @IBOutlet var settingLbl:UILabel?
    @IBOutlet var settingImage:UIImageView?
    @IBOutlet var settingsBtn:UIButton?
    
    @IBOutlet var myTicketLbl:UILabel?
    @IBOutlet var myTicketImage:UIImageView?
    @IBOutlet var myTicketBtn:UIButton?

    @IBOutlet var memoriesLbl:UILabel?
    @IBOutlet var memoriesImage:UIImageView?
    @IBOutlet var memoriesBtn:UIButton?
    @IBOutlet var stackContainerView:UIView?
    @IBOutlet var myTicketView:UIView?
    @IBOutlet var memoriesView:UIView?
    @IBOutlet var settingView:UIView?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        fillInfo()
        paintInterface()
    }
    
    func paintInterface(){
       
        myTicketView?.backgroundColor = UIColor(red: 39.0/255.0, green: 184.0/255.0, blue: 121.0/255.0, alpha: 1)
        myTicketLbl?.textColor = UIColor.white
        memoriesLbl?.textColor = UIColor(red: 140.0/255.0, green: 157.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        settingLbl?.textColor = UIColor(red: 140.0/255.0, green: 157.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        stackContainerView?.layer.cornerRadius = 5
        stackContainerView?.layer.masksToBounds = true
        stackContainerView?.layer.borderWidth = 1
        stackContainerView?.layer.borderColor = UIColor(hexString: "#27B879").cgColor
    }
    
    func fillInfo(){
        
        guard let info = SignedUserInfo.sharedInstance else {
            return
        }

        self.userName?.text = "\(info.firstName ?? "") \(info.lastName ?? "")"
    }
    
    func setTabInterface(controller:UIViewController?){
        
        guard let controller = controller else { return }
    
        if controller.isKind(of: SettingController.self){
           
            resetColor()
            settingView?.backgroundColor = UIColor(red: 39.0/255.0, green: 184.0/255.0, blue: 121.0/255.0, alpha: 1)
            settingLbl?.textColor = UIColor.white
            
        }else if controller.isKind(of: MyTicketsController.self){
       
            resetColor()
            myTicketView?.backgroundColor = UIColor(red: 39.0/255.0, green: 184.0/255.0, blue: 121.0/255.0, alpha: 1)
            myTicketLbl?.textColor = UIColor.white
            
        }else if controller.isKind(of: MemoriesController.self){
            
            resetColor()
            memoriesView?.backgroundColor = UIColor(red: 39.0/255.0, green: 184.0/255.0, blue: 121.0/255.0, alpha: 1)
            memoriesLbl?.textColor = UIColor.white
            
        }else{
        }
    }
    
    func resetColor(){
        
        settingView?.backgroundColor = UIColor(red: 242.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1)
        myTicketView?.backgroundColor =  UIColor(red: 242.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1)
        memoriesView?.backgroundColor =  UIColor(red: 242.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1)
        myTicketLbl?.textColor = UIColor(red: 140.0/255.0, green: 157.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        memoriesLbl?.textColor = UIColor(red: 140.0/255.0, green: 157.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        settingLbl?.textColor = UIColor(red: 140.0/255.0, green: 157.0/255.0, blue: 161.0/255.0, alpha: 1.0)
    }
}

extension AccountRootView{
    
    @IBAction func settingsAction(){
        
        self.controller?.settingsAction()
    }
    
    @IBAction func memoryAction(){
        
        self.controller?.memoryAction()
    }
    
    @IBAction func myTicketsAction(){
        
        self.controller?.ticketAction()
    }
}
