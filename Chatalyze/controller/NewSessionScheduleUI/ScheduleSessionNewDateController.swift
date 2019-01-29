//
//  ScheduleSessionNewDateController.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class ScheduleSessionNewDateController: InterfaceExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    class func instance()-> ScheduleSessionNewDateController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionNewDate") as? ScheduleSessionNewDateController
        return controller
    }
    
}
