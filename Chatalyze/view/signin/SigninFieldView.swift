
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
    @IBOutlet var image:UIImageView?
    @IBOutlet var textFieldContainer:UIView?
    
    var isCompleteBorderAllow = false
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    fileprivate func initialization(){
        
        layoutUI()
    }
    
    fileprivate func layoutUI(){
        
        if isCompleteBorderAllow{
           
            self.textFieldContainer?.layer.borderWidth = 1
            self.textFieldContainer?.layer.borderColor = UIColor(hexString: AppThemeConfig.borderGrayColor).cgColor
            self.textFieldContainer?.layer.cornerRadius = 3
            self.textFieldContainer?.layer.masksToBounds = true
            borderView?.backgroundColor = UIColor.clear
            return
        }        
        borderView?.backgroundColor = UIColor(hexString: AppThemeConfig.borderGrayColor)
        self.layer.masksToBounds = true
    }
    
    func showError(text : String?){
       // borderView?.backgroundColor = UIColor.red
        errorLabel?.text = text
    }
    
    func resetErrorStatus(){
        
        if isCompleteBorderAllow {
            borderView?.backgroundColor = UIColor.clear
            errorLabel?.text = ""
            return
        }
        borderView?.backgroundColor = UIColor(hexString: AppThemeConfig.borderGrayColor)
        errorLabel?.text = ""
    }
}
