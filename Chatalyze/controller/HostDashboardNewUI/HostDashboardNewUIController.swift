//
//  HostDashboardNewUIController.swift
//  Chatalyze
//
//  Created by mansa infotech on 28/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class HostDashboardNewUIController: InterfaceExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintUI()
    }
    
    func paintUI(){
        
        paintNavigationTitle(text: "Dashboard")
        paintSettingButton()
        //paintBackButton()
    }
    
    @IBAction func mySessionAction(sender:UIButton?){
        
        guard let controller  = HostDashboardController.instance() else{
            return
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
   
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HostDashboardNewUIController{
    
    class func instance()->HostDashboardNewUIController?{
        
        let storyboard = UIStoryboard(name: "HostDashboardNewUI", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HostDashboardNewUI") as? HostDashboardNewUIController
        return controller
    }
}
