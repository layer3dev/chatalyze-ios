//
//  CustomTicketsController.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 05/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation


class CustomTicketsController: InterfaceExtendedController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    @IBOutlet weak var rootView:CustomTicketsRootView?
    
    fileprivate func initilization(){
        rootView?.controller = self

    }
    
    
    func fetchData(){
        
        
        guard let userId = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        CustomTicketsHandler().fetchInfo(with: userId, offset: 0) { (success, response) in
           
            
            guard let info = response else {return}
            
            for i in 0...info.count{
                Log.echo(key: "CustomTicketsController", text: "\(String(describing: info[i].room_id))")
            }
        }
        
    }
    
    
}

extension CustomTicketsController {
    
    class func instance()->CustomTicketsController?{
        
        let storyboard = UIStoryboard(name: "ClaimCustomTickets", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CustomTicketsController") as? CustomTicketsController
        return controller
    }
}
