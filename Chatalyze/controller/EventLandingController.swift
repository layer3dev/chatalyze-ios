//
//  EventLandingController.swift
//  Chatalyze
//
//  Created by Mansa on 24/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventLandingController: InterfaceExtendedController {

    override func viewDidLayout() {
        super.viewDidLayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //segue.identifier
        let controller = segue.destination as? EventSoldOutController
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
