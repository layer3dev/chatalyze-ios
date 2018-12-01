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
    @IBOutlet var msgLbl:UILabel?
    @IBOutlet var saveBtn:UIButton?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        maketextLinkable()
        paintInterface()
        fetchPaypalInfo()
        roundSaveButton()
        setUpGestureOnLabel()
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
        
        let textMutable = text.toMutableAttributedString(font: "Questrial", size: fontSize, color: UIColor.black, isUnderLine: false)
        
        let text1 = " (you'll be directed to Paypal's website)"
        
        let text1Attr = text1.toAttributedString(font: "Questrial", size: fontSize, color: UIColor.black, isUnderLine: false)
        
        let selectablePart = "Here".toAttributedString(font: "Questrial", size: fontSize, color: UIColor(hexString: "#FAA579"), isUnderLine: true)
        
        textMutable.append(selectablePart)
        textMutable.append(text1Attr)
        // Center the text (optional)
        
        msgLbl?.attributedText = textMutable
        msgLbl?.isUserInteractionEnabled = true
    }
    
    func setUpGestureOnLabel(){
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
        self.msgLbl?.addGestureRecognizer(tap)
        self.msgLbl?.isUserInteractionEnabled = true
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
        
        if let msglabel = self.msgLbl{
            guard let range = msglabel.text?.range(of: "create one HERE (you'll")?.nsRange else {
                return
            }
            if tap.didTapAttributedTextInLabel(label: msglabel, inRange: range) {
                Log.echo(key: "yud",text: "Sub string is tapped")
                
                
                //Substring tapped
            }
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

extension PaymentSetupPaypalController:UITextViewDelegate {
        
//    @available(iOS 10.0, *)
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//
//        Log.echo(key: "yud", text: "I am in the url \(URL)")
//
//        UIApplication.shared.open(URL, options: [:])
//        return false
//    }
//
//    /// deprecated delegate method. Gets called if iOS version is < 10.
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
//        return textViewShouldInteractWithURL(URL: URL)
//    }
//
//    func textViewShouldInteractWithURL(URL: URL) -> Bool {
//        // common logic here
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(URL, options: [:])
//        } else {
//            // Fallback on earlier versions
//        }
//        return false
//    }
}


extension PaymentSetupPaypalController{
    
    class func instance()->PaymentSetupPaypalController?{
                
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PaymentSetupPaypal") as? PaymentSetupPaypalController
        return controller
    }
}


