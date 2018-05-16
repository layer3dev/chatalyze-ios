//
//  SignInTextViewField.swift
//  Chatalyze
//
//  Created by Mansa on 10/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit

class SignInTextViewField: ExtendedView {
    
    @IBOutlet var textview : PlaceholderTextView?
    @IBOutlet fileprivate var borderView : UIView?
    @IBOutlet fileprivate var errorLabel : UILabel?
    var root:GreetingRecipientRootView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    fileprivate func initialization(){
        //textview?.root = self
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
    func updateScrollField(textView:UITextView?){

        root?.updateScrollField(textview:textView)
    }
}
