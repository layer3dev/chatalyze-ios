//
//  SessionDetailController.swift
//  Chatalyze
//
//  Created by mansa infotech on 25/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionDetailController: InterfaceExtendedController {

    var eventInfo:EventInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Do any additional setup after loading the view.
        rootView?.controller = self
        rootView?.fillInfo(info: self.eventInfo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    var rootView:SessionDetailRootView?{
        return self.view as? SessionDetailRootView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func menuAction(){
        RootControllerManager().getCurrentController()?.toggleAnimation()
    }

    func backToHostDashboard(){
        self.navigationController?.popViewController(animated: true)
    }
    
    class func instance()-> SessionDetailController? {
        
        let storyboard = UIStoryboard(name: "SessionDetail", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionDetail") as? SessionDetailController
        return controller
    }
}


