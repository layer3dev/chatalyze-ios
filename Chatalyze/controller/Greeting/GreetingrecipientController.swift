//
//  GreetingrecipientController.swift
//  Chatalyze
//
//  Created by Mansa on 10/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class GreetingrecipientController: InterfaceExtendedController {

    @IBOutlet var rootView:GreetingRecipientRootView?
    var info:GreetingInfo?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        initializeVariable()
    }

    func paintInterface(){
        
        self.paintBackButton()
        self.paintNavigationTitle(text: "GREETING RECIPIENT")
    }
    
    func initializeVariable(){
        
        rootView?.controller = self
        self.rootView?.info = self.info
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

extension GreetingrecipientController{
    
    class func instance()->GreetingrecipientController?{
        
        let storyboard = UIStoryboard(name: "Greeting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Greetingrecipient") as? GreetingrecipientController
        return controller
    }
}
