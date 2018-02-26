
//
//  SigninFieldView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 26/02/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SigninFieldView: ExtendedView {
    
    @IBOutlet var textField : UITextField?
    @IBOutlet fileprivate var borderView : UIView?
    @IBOutlet fileprivate var errorLabel : UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    fileprivate func initialization(){
        layoutUI()
    }
    
    fileprivate func layoutUI(){
        borderView?.backgroundColor = UIColor(hexString: AppThemeConfig.borderGrayColor)
    }
    
    func showError(text : String?){
        borderView?.backgroundColor = UIColor.red
        errorLabel?.text = text
    }
    
    func resetErrorStatus(){
        borderView?.backgroundColor = UIColor(hexString: AppThemeConfig.borderGrayColor)
        errorLabel?.text = ""
    }

}
