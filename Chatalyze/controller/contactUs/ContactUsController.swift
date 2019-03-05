//
//  ContactUsController.swift
//  Chatalyze
//
//  Created by Mansa on 01/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ContactUsController: InterfaceExtendedController {
    
    @IBOutlet var subjectView:UIView?
    @IBOutlet var subjectTextField:UITextField?
    @IBOutlet var messageView:UIView?
    @IBOutlet var contactTextView:UITextView?
    @IBOutlet var contactPlaceholderLbl:UILabel?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var emailField:UITextField?
    @IBOutlet var nameField:UITextField?
    
    @IBOutlet var emailFieldView:UIView?
    @IBOutlet var nameFieldView:UIView?
    
    @IBOutlet fileprivate var scrollContentBottomOffset : NSLayoutConstraint?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painteInterface()
        paintTextfieldPlaceHolder()
    }
    
    @IBAction func backAction(sender:UIButton?){
        
        self.navigationController?.popViewController(animated: true)
    }
    
   
    func paintTextfieldPlaceHolder(){
        
        var fontSize:CGFloat = 16.0
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24.0
        }
        
        subjectTextField?.attributedPlaceholder =
            NSAttributedString(string: "Subject", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#8B959E"),NSAttributedString.Key.font:UIFont(name: "Questrial", size: fontSize)])
        
        emailField?.attributedPlaceholder =
            NSAttributedString(string: "Email address", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#8B959E"),NSAttributedString.Key.font:UIFont(name: "Questrial", size: fontSize)])
        
        nameField?.attributedPlaceholder =
            NSAttributedString(string: "Full name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#8B959E"),NSAttributedString.Key.font:UIFont(name: "Questrial", size: fontSize)])
        
    }
    
    func painteInterface(){
        
        initializeVariable()
        paintNavigationTitle(text: "Contact Us")
        paintBackButton()
        paintSettingButton()
        paintBorder()
    }
    
    func paintBorder(){
        
        emailFieldView?.layer.borderWidth = 1
        emailFieldView?.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        
        nameFieldView?.layer.borderWidth = 1
        nameFieldView?.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        
        subjectView?.layer.borderWidth = 1
        subjectView?.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        
        messageView?.layer.borderWidth = 1
        messageView?.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
    }
    
    
    func initializeVariable(){
        
        contactTextView?.delegate = self
    }
    
    @IBAction private func submitAction(){
        
        submit()
    }
    
    func submit(){
        
        let text  = contactTextView?.text.replacingOccurrences(of: " ", with: "")
        
        if text == ""{
            
            self.alert(withTitle: AppInfoConfig.appName, message: "Message field cannot be blank", showCancel: false, completion: { (success) in
            })
            return
        }
        
        guard let userInfo = SignedUserInfo.sharedInstance
            else{
                return
        }
        guard let getname = userInfo.fullName as? String else{
            return
        }
        guard let getemail = userInfo.email else{
            return
        }
        guard let getmessage = contactTextView?.text else{
            return
        }
        
        self.showLoader()
        submitContactUsRequest().contactUs(email: getemail, message: getmessage, name: getname) { (success) in
            self.stopLoader()
            if(!success){
                
                //                self.alert(withTitle: AppInfoConfig.appName, message: "Error", showCancel: false, completion: { (success) in
                //                })
                
                self.alert(withTitle: AppInfoConfig.appName, message: "Thank you for your message. We'll get back to you shortly!", showCancel: false, completion: { (success) in
                    
                    self.contactTextView?.text = ""
                    self.contactPlaceholderLbl?.text = "Enter Message"
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
                return
            }
            self.alert(withTitle: AppInfoConfig.appName, message: "Thank you for your message. We'll get back to you shortly!", showCancel: false, completion: { (success) in
                self.contactTextView?.text = ""
                self.contactPlaceholderLbl?.text = "Enter Message";
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
    }
    
    class func instance()->ContactUsController?{
        
        let storyboard = UIStoryboard(name: "ContactUs", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ContactUs") as? ContactUsController
        return controller
    }
}

extension ContactUsController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        contactPlaceholderLbl?.text = ""
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        contactPlaceholderLbl?.text = ""
        scrollView?.activeField = textView
        scrollView?.bottomContentOffset = scrollContentBottomOffset
        return true
    }
    
    func textViewDidChange(_ textView: UITextView){        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if (contactTextView?.text ?? ""  == ""){
            contactPlaceholderLbl?.text = "Enter Message"
        }
    }
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text.count+textView.text.count) > 255{
            return false
        }
        return true
    }
}
