//
//  GreetingInfoController.swift
//  Chatalyze
//
//  Created by Mansa on 05/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class GreetingInfoController: InterfaceExtendedController {

    var info:GreetingInfo?
    @IBOutlet var rootView:GreetingInfoRootView?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        paintInterface()
        initializeVariable()
    }
    
    func paintInterface(){    
        
        self.paintNavigationTitle(text: info?.name)
        self.paintBackButton()
    }
    
    func initializeVariable(){
        
        self.rootView?.info = self.info
        self.rootView?.controller = self
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension GreetingInfoController{
    
    class func instance()->GreetingInfoController?{
        
        let storyboard = UIStoryboard(name: "Greeting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GreetingInfo") as? GreetingInfoController
        return controller
    }
}
