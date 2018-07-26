//
//  AccountHostController.swift
//  Chatalyze
//
//  Created by Mansa on 26/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AccountHostController: AccountController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   override func settingsAction(){
        
        pageViewHostController?.setSettingTab()
        rootView?.setTabInterface(controller: SettingController())
    }
    
   override func memoryAction(){
        
        pageViewHostController?.setMemoryTab()
        rootView?.setTabInterface(controller:SettingController())
    }
    
   override func ticketAction(){
        
        pageViewHostController?.setMyTicketTab()
        rootView?.setTabInterface(controller: SessionController())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override class func instance()->AccountHostController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AccountHostController") as? AccountHostController
        return controller
    }
}
