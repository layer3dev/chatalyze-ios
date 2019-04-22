//
//  MenuRootView.swift
//  Chatalyze
//
//  Created by Mansa on 21/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class MenuRootView:ExtendedView{
    
    @IBOutlet var underLineLbl:UILabel?
    var fontSize:CGFloat = 16.0
    
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
        case test = 15
        case proFeature = 16
        case achievements = 17
        case none = 5
    }
    var selectedSlideBarTab:((MenuRootView.MenuType?)->())?
    
    @IBOutlet var adapter:MenuAdapter?
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeFontSize()
        underLineLable()
        adapter?.selectedSlideBarTab = self.selectedSlideBarTab
        //        adapter?.selectedSlideBarTab = { (response) in
        //            Log.echo(key: "yud", text: "Response is calling")
        //        }
    }
    
    func initializeFontSize(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 22.0
        }else{
            fontSize = 16.0
        }
    }
    
    func underLineLable(){
        
        var testingText = "TEST MY PHONE"
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            testingText = "TEST MY IPAD"
        }
        
        if let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont(name: "Nunito-ExtraBold", size: fontSize)] as? [NSAttributedString.Key : Any]{
            
            let underlineAttributedString = NSAttributedString(string: testingText, attributes: underlineAttribute as [NSAttributedString.Key : Any])
            underLineLbl?.attributedText = underlineAttributedString
        }
    }
}
