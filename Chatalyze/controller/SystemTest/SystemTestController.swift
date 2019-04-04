//
//  SystemTestController.swift
//  Chatalyze
//
//  Created by Mansa on 25/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SystemTestController:InterfaceExtendedController {
    
    @IBOutlet var rootView:SystemRootView?
    var info:EventInfo?
    var presentingControllerObj:EventController?
    var dismissListner:((Bool)->())?
    //Below is using for the free events
    var isOnlySystemTestForTicket = false
        
    override func viewDidLayout(){
        super.viewDidLayout()
        
        //rootView?.backgroundColor = UIColor.clear
        rootView?.isOpaque = false
        initializeVariable()
        paintInterface()
        SEGAnalytics.shared().track("System Test")
    }
    
    func paintInterface(){
        
        if isOnlySystemTestForTicket{
            
            self.rootView?.skipView?.isHidden = true
            self.rootView?.skipHieght?.constant = 0
        }
    }
    
    func initializeVariable(){
        
        self.rootView?.controller = self
        self.rootView?.info = self.info
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SystemTestController{
    
    class func instance()->SystemTestController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SystemTest") as? SystemTestController
        return controller
    }
}
