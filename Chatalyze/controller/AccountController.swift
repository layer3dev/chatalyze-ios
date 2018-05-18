//
//  AccountController.swift
//  Chatalyze
//
//  Created by Mansa on 18/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AccountController: TabChildLoadController {

    @IBOutlet var rootView:AccountRootView?
    var pageViewController:AcccountPageViewController?
    
    override func viewDidLayout(){
        super.viewDidLayout()
      
        initializeVariable()
        paintInterafce()
    }
    
    override func viewGotLoaded() {
        super.viewGotLoaded()
    }
    
    func paintInterafce(){
        
        paintNavigationTitle(text: "Account")
        paintSettingButton()
    }
    
    func initializeVariable(){
        
        rootView?.controller = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueIdentifier  = segue.identifier
        if segueIdentifier == "pagination"{
            
           pageViewController = segue.destination as? AcccountPageViewController
            pageViewController?.accountDelegate = self
        }
    }
}

extension AccountController{
    
    class func instance()->AccountController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Account") as? AccountController
        return controller
    }
}


extension AccountController:stateofAccountTabDelegate{
   
    func currentViewController(currentController: UIViewController?) {
        
        guard let controller = currentController else { return  }
        rootView?.setTabInterface(controller:controller)
    }
}
