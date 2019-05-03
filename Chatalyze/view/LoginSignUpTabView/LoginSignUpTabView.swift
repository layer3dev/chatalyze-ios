//
//  LoginSignUpTabView.swift
//  Chatalyze
//
//  Created by Mansa on 19/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class LoginSignUpTabView:ExtendedView{
    
    @IBOutlet var bottomBar:UIView?
    @IBOutlet var heightOfBottomBarView:NSLayoutConstraint?
    @IBOutlet var nameLabel:UILabel?

    var tabAction: ((LoginSignUpTabView)->())?
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    @IBAction func tabAction(sender:UIButton){
        
        if let action = tabAction {
            action(self)
        }
    }
    
    func reset(){
        
        bottomBar?.backgroundColor = UIColor.white
        heightOfBottomBarView?.constant = 1
        nameLabel?.font = UIFont(name: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16 )
    }
    func select(){
        
        bottomBar?.backgroundColor = UIColor.white
        heightOfBottomBarView?.constant = UIDevice.current.userInterfaceIdiom == .pad ? 4:3
        nameLabel?.font = UIFont(name: "Nunito-ExtraBold", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16 )
    }
    
    func tabAction(action: @escaping ((LoginSignUpTabView)->())){
        tabAction = action
    }
    
}
