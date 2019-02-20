//
//  HostCategoryController.swift
//  Chatalyze
//
//  Created by mansa infotech on 20/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class HostCategoryController: InterfaceExtendedController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    
    var rootView:HostCategoryRootView?{
        return self.view as? HostCategoryRootView
    }
    
    func nextScreen(){
        
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
