//
//  GreetingDateTimeController.swift
//  Chatalyze
//
//  Created by Mansa on 07/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class GreetingDateTimeController: InterfaceExtendedController {

    @IBOutlet var rootView:GreetingDateTimeRootView?
    var info:GreetingInfo?
    override func viewDidLayout(){
        super.viewDidLayout()
        
        initializeVariable()
        painInterface()
    }
    
    func painInterface(){
        
        paintNavigationTitle(text: "DELIVERY DATE TIME")
        paintBackButton()
    }
    
    
    func initializeVariable(){
        
        rootView?.controller = self
        self.rootView?.info = self.info
        self.rootView?.controller = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

extension GreetingDateTimeController{
    
    class func instance()->GreetingDateTimeController?{
        
        let storyboard = UIStoryboard(name: "Greeting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GreetingDateTime") as? GreetingDateTimeController
        return controller
    }
}
