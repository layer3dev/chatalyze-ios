//
//  MyTicketsVerticalController.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MyTicketsVerticalController: MyTicketsController {
   
    @IBOutlet var myTicketsVerticalTableView:UITableView?
    @IBOutlet var mainRootView:MyTicketsVerticalRootView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        mainRootView?.table = myTicketsVerticalTableView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override class func instance()->MyTicketsVerticalController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyTicketsVertical") as? MyTicketsVerticalController
        return controller
    }
}
