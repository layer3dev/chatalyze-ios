//
//  MenuRootView.swift
//  Chatalyze
//
//  Created by Mansa on 21/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class MenuRootView:ExtendedView{
    
    enum MenuType:Int{
        
        case mySessionAnalyst = 0
        case paymentAnalyst = 1
        case scheduledSessionAnalyst = 2
        case editProfileAnalyst = 3
        case contactUsUser = 4
        case editProfileUser = 6
        case paymentUser = 7
        case contactUsAnalyst = 8
        case autograph = 9
        case tickets = 10
        case userAccount = 11
        case analystAccount = 12
        case events = 13
        case settings = 14
        case none = 5
    }
    var selectedSlideBarTab:((MenuRootView.MenuType?)->())?
    
    @IBOutlet var adapter:MenuAdapter?
    override func viewDidLayout() {
        super.viewDidLayout()
        
        adapter?.selectedSlideBarTab = self.selectedSlideBarTab
//        adapter?.selectedSlideBarTab = { (response) in
//            Log.echo(key: "yud", text: "Response is calling")
//        }
    }
}
