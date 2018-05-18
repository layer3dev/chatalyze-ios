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
    
    @IBOutlet var myTicketLbl:UILabel?
    @IBOutlet var myTicketImage:UIImageView?
    
    @IBOutlet var memoriesLbl:UILabel?
    @IBOutlet var memoriesImage:UIImageView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        fillInfo()
        paintInterface()
    }
    
    func paintInterface(){
      
        myTicketLbl?.textColor = UIColor(red: 130.0/255.0, green: 197.0/255.0, blue: 126.0/255.0, alpha: 1)
    }
    
    func fillInfo(){
        
        guard let info = SignedUserInfo.sharedInstance else {
            return
        }

        self.userName?.text = "\(info.firstName ?? "") \(info.lastName ?? "")"
    }
    
    func setTabInterface(controller:UIViewController?){
        
        guard let controller = controller else { return  }
    
        if controller.isKind(of: SettingController.self){
           
            resetColor()
            settingLbl?.textColor = UIColor(red: 130.0/255.0, green: 197.0/255.0, blue: 126.0/255.0, alpha: 1)
        }else if controller.isKind(of: MyTicketsController.self){
       
            resetColor()
            myTicketLbl?.textColor = UIColor(red: 130.0/255.0, green: 197.0/255.0, blue: 126.0/255.0, alpha: 1)
        }else if controller.isKind(of: MemoriesController.self){
            
            resetColor()
            memoriesLbl?.textColor = UIColor(red: 130.0/255.0, green: 197.0/255.0, blue: 126.0/255.0, alpha: 1)
        }else{
            
        }
            //else if{
//
//        }
   
    
    }
    
    func resetColor(){
     
        settingLbl?.textColor = UIColor.white
        myTicketLbl?.textColor = UIColor.white
        memoriesLbl?.textColor = UIColor.white
    }
}
