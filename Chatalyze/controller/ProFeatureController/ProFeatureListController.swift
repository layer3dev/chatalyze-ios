//
//  ProFeatureListController.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class ProFeatureListController: InterfaceExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backDismiss(sender:UIButton?){
        
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

    
    class func instance()->ProFeatureListController?{
        
        let storyboard = UIStoryboard(name: "ProFeature", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProFeatureList") as? ProFeatureListController
        return controller
    }
}
