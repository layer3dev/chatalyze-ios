//
//  LaunchDelayController.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 03/05/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit

class LaunchDelayController: ExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

extension LaunchDelayController{
    class func instance()->LaunchDelayController?{
        let storyboard = UIStoryboard(name : "launch_container", bundle : nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "launch_delay") as? LaunchDelayController
        return controller        
    }
}
