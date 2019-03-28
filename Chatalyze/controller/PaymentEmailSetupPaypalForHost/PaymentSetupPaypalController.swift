//
//  PaymentSetupPaypalController.swift
//  Chatalyze
//
//  Created by Mansa on 27/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import MobileCoreServices

class PaymentSetupPaypalController: InterfaceExtendedController {

    @IBOutlet var emailField :SigninFieldView?
    @IBOutlet var msgTextView:UITextView?
    @IBOutlet var saveBtn:UIButton?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        maketextLinkable()
        paintInterface()
        fetchPaypalInfo()
        roundSaveButton()
        //setUpGestureOnLabel()
        initializeLink()
    }
    
    func roundSaveButton(){
        
        saveBtn?.layer.cornerRadius = 3
        saveBtn?.layer.masksToBounds = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "Payments")
    }
    
    func paintInterface(){
        
        paintBackButton()
        paintSettingButton()
    }
    
    func validateFields()->Bool{
        
        let emailValidated  = validateEmail()
        return emailValidated
    }
    
    fileprivate func validateEmail()->Bool{
        
        if(emailField?.textField?.text == ""){
            emailField?.showError(text: "Email is required.")
            return false
        }
        else if !(FieldValidator.sharedInstance.validateEmailFormat(emailField?.textField?.text ?? "")){
            emailField?.showError(text: "Email looks incorrect !")
            return false
        }
        emailField?.resetErrorStatus()
        return true
    }
    
    func submit(){
        
        guard let analystID = SignedUserInfo.sharedInstance?.id else{
            return
        }
        let email = emailField?.textField?.text ?? ""
        self.showLoader()
        SubmitPaypalEmailProcessor().save(analystId: analystID, email: email) { (success, message, response) in
            self.stopLoader()
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    
    func fetchPaypalInfo(){
        
        self.showLoader()
        FetchPaypalEmailHost().fetchInfo { (success, response) in
            
            self.stopLoader()
            if success{
                
                guard let res = response else{
                    return
                }
                if let dict = res.dictionary{
                    if let email = dict["email"]?.stringValue{
                 
                        self.emailField?.textField?.text = email
                    }
                }
            }
        }
    }
        
    @IBAction func submitAction(sender:UIButton){
        
        if(validateFields()){
            //self.resetErrorStatus()
            submit()
        }
    }
    
    func maketextLinkable(){
        
        //        To get paid, you need to have a Paypal account. Please provide the email address associated with your Paypal account below. If you don't have a Paypal account, you can create one HERE (you'll be directed to Paypal's website).
        //
        
        var fontSize = 16
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24
        }
        
        let text = "To get paid, you need to have a Paypal account. Please provide the email address associated with your Paypal account below. If you don't have a Paypal account, you can create one "
        
        let textMutable = text.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor.black, isUnderLine: false)
        
        let text1 = " (you'll be directed to Paypal's website)"
        
        let text1Attr = text1.toAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor.black, isUnderLine: false)
        
        let selectablePart = "HERE".toAttributedStringLink(font: "Nunito-Regular", size: fontSize+2, color: UIColor(hexString: "#FAA579"), isUnderLine: true,url:"https://www.paypal.com/us/webapps/mpp/account-selection")
        
        textMutable.append(selectablePart)
        textMutable.append(text1Attr)
        // Center the text (optional)
        
        msgTextView?.attributedText = textMutable
        msgTextView?.setLineSpacing(lineSpacing: 5.0)
        msgTextView?.isUserInteractionEnabled = true
    }
    
    func setUpGestureOnLabel(){
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
        self.msgTextView?.addGestureRecognizer(tap)
        self.msgTextView?.isUserInteractionEnabled = true
    }
    
    @objc func tapLabel(tap: UITapGestureRecognizer) {
        
        if #available(iOS 10.0, *) {
            
            guard let url = URL(string: "https://www.paypal.com/us/webapps/mpp/account-selection") else{
                return
            }
            
            UIApplication.shared.open(url, options: [:])
        } else {
            // Fallback on earlier versions
        }
    }
    
   
    var rootView:PaymentSetupPaypalRootView?{
   
        get{
            return self.view as? PaymentSetupPaypalRootView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


extension PaymentSetupPaypalController:UITextViewDelegate{
    
    func initializeLink(){
        
        msgTextView?.delegate = self
        msgTextView?.isSelectable = true
        msgTextView?.isEditable = false
        msgTextView?.dataDetectorTypes = .link
        msgTextView?.isUserInteractionEnabled = true
        msgTextView?.linkTextAttributes = [NSAttributedString.Key.font:UIColor(hexString:AppThemeConfig.themeColor)]
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range == textView.text?.range(of: "HERE")?.nsRange {
            Log.echo(key: "yud", text: "contact us is called")
        }
        
        if  range == textView.text?.range(of: "our FAQs")?.nsRange {
            Log.echo(key: "yud", text: "FAQ is called")
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        Log.echo(key: "yud", text: "interacting with url")
        
        if characterRange == msgTextView?.text?.range(of: "HERE")?.nsRange {
          
            Log.echo(key: "yud", text: "interacting with url")
            return true
        }
         return true
    }
}



extension PaymentSetupPaypalController{
    
    class func instance()->PaymentSetupPaypalController? {
                
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PaymentSetupPaypal") as? PaymentSetupPaypalController
        return controller
    }
}


