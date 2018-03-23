//
//  SettingControllerViewController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SettingController : InterfaceExtendedController {
    
    @IBAction private func signoutAction(){
        RootControllerManager().signOut(completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initialization()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialization(){
        initializeInterface()
    }
    
    private func initializeInterface(){
        paintNavigationBar()
        edgesForExtendedLayout = UIRectEdge()
    }
    
    private func paintNavigationBar(){
        paintNavigationTitle(text : "Settings")
        paintSettingButton()
        paintBackButton()
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


extension SettingController{
    
    class func instance()->SettingController?{
        
        let storyboard = UIStoryboard(name: "setting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "setting") as? SettingController
        return controller
    }
}
