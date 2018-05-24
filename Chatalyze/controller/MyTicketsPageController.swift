//
//  MyTicketsPageController.swift
//  Chatalyze
//
//  Created by Mansa on 23/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MyTicketsPageController: MyTicketsController {
        
    override class func instance()->MyTicketsPageController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyTicketsPage") as? MyTicketsPageController
        return controller
    }
}

