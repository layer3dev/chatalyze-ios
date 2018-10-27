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
    var tabAction: ((LoginSignUpTabView)->())?
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    @IBAction func tabAction(sender:UIButton){
        
        if let action = tabAction{
            action(self)
        }
    }
    
    func reset(){
        
        bottomBar?.backgroundColor = UIColor.white
    }
    func select(){
        
        bottomBar?.backgroundColor = UIColor.darkGray
    }
    
    func tabAction(action: @escaping ((LoginSignUpTabView)->())){
        tabAction = action
    }
    
}
