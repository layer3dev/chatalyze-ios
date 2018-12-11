//
//  DeprecationAlertController.swift
//  Chatalyze
//
//  Created by Mansa on 10/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class DeprecationAlertController: InterfaceExtendedController {

    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    @IBAction func updateApp(sender:UIButton){
        
        if let itunesUrl = URL(string:"https://itunes.apple.com/us/app/chatalyze/id1313197231?ls=1&mt=8"){
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(itunesUrl)
                return
            }
            //Fallback on earlier versions
            UIApplication.shared.openURL(itunesUrl)
        }
    }
    
    @IBAction func exit(sender:UIButton){
       
        self.dismiss(animated: true) {
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */    
    
    class func instance()->DeprecationAlertController?{
        
        let storyboard = UIStoryboard(name: "UpdateAlert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DeprecationAlert") as? DeprecationAlertController
        return controller
    }
    
}
