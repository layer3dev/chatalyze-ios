//
//  MyScheduledSessionsController.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MyScheduledSessionsController: InterfaceExtendedController {

    @IBOutlet var sessionListingTableView:UITableView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeVariable()
        paintInterface()
    }
    
    func initializeVariable(){
    }
    
    func paintInterface(){
    }
    
    var rootView:MySessionRootView?{
        
        get{
            return self.view as? MySessionRootView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
}

extension MyScheduledSessionsController{
    
    class func instance()->MyScheduledSessionsController?{
        
        let storyboard = UIStoryboard(name: "MySessions", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyScheduledSessions") as? MyScheduledSessionsController
        return controller
    }
}

