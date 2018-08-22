//
//  SessionDoneController.swift
//  Chatalyze
//
//  Created by Mansa on 22/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionDoneController: InterfaceExtendedController {

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

extension SessionDoneController{
    
    class func instance()->SessionDoneController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSession", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionDone") as? SessionDoneController
        return controller
    }
}
