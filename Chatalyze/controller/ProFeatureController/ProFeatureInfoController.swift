//
//  ProFeatureInfoController.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class ProFeatureInfoController: InterfaceExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavigationBar()
    }
    
    @IBAction func backActionDismiss(sender:UIButton?){
        
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    class func instance()->ProFeatureInfoController?{
        
        let storyboard = UIStoryboard(name: "ProFeature", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProFeatureInfo") as? ProFeatureInfoController
        return controller
    }
}
