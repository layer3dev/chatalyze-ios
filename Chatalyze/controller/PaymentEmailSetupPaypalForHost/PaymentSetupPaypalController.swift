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
    @IBOutlet var saveImage:UIImageView?
    @IBOutlet var scroll:FieldManagingScrollView?
    var isFetching = false
    var isFetechingCompleted = false
    var paymentArray = [AnalystPaymentInfo]()
    var limit = 8
    @IBOutlet var moreDetailsTextView:UITextView?
    @IBOutlet var moreDetailView:UIView?
    @IBOutlet var moreDetailMainView:UIView?

    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        maketextLinkable()
        makeMoreDetailsTextLinkable()
        paintInterface()
        fetchPaypalInfo()
        roundSaveButton()
        initializeLink()
        initializeMoreDetailLink()
        rootView?.controller = self
        rootView?.initializeAdapter()
        fetchPaymentHistory()
    }
    
    func fetchPaymentHistory(){
   
        FetchAnalystPaymentHistory().fetch(limit: limit, offset: 0) { (success, message, info) in

            self.stopLoader()
            self.paymentArray.removeAll()
            self.rootView?.updateInfo(info: self.paymentArray)
            if !success{
               return
            }
            guard let array  = info else{
                return
            }
            
            if array.count == 0 {
                self.isFetechingCompleted = true
                return
            }
            
            if array.count >= 0 && array.count < self.limit{
                
                self.isFetechingCompleted = true
                self.paymentArray = array
                self.rootView?.updateInfo(info: self.paymentArray)
            }
            
            if array.count > 0 && array.count >= self.limit{
                self.paymentArray = array
                self.rootView?.updateInfo(info: self.paymentArray)
            }
        }
    }
    
    
    func fetchPaymentHostoryForPagination(){
        
        if isFetching{
            return
        }
        if isFetechingCompleted{
            return
        }
        
        self.isFetching = true
        FetchAnalystPaymentHistory().fetch(limit: limit, offset: self.paymentArray.count) { (success, message, info) in
            
            self.isFetching = false
            if !success{
                return
            }
            guard let array  = info else{
                return
            }
            
            if array.count == 0 {
                self.isFetechingCompleted = true
                return
            }
            
            if array.count >= 0 && array.count < self.limit{
                
                self.isFetechingCompleted = true
                for info in array{
                    self.paymentArray.append(info)
                }
                self.rootView?.updateInfo(info: self.paymentArray)
            }
            
            if array.count > 0 && array.count >= self.limit{
              
                for info in array{
                    self.paymentArray.append(info)
                }
                self.rootView?.updateInfo(info: self.paymentArray)
            }
        }
    }
    
    func roundSaveButton(){
        
        saveBtn?.layer.cornerRadius = 3
        saveBtn?.layer.masksToBounds = true
        saveImage?.layer.cornerRadius = 3
        saveImage?.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "Payout Details")
    }
    
    func paintInterface(){
        
        paintBackButton()
        paintSettingButton()
        scroll?.delegate = self
        emailField?.textField?.delegate = self
        moreDetailView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 6:4
        moreDetailView?.layer.masksToBounds = true
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
            self.fetchBillingInfo()
            
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
    
    
    func fetchBillingInfo(){
        
        FetchBillingDetailProcessor().fetch { (success, message, info) in
           
            DispatchQueue.main.async {
                self.fetchPaymentHistory()
                self.rootView?.fillBiilingInfo(info:info)
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
        
        //Link your PayPal account to Chatalyze so you can receive payouts. More details
        
        let text = "Link your PayPal account to Chatalyze so you can receive payouts. "
        
        let textMutable = text.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1), isUnderLine: false)
        
        let text1 = "More details"
        
        let text1Attr = text1.toAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1), isUnderLine: false)
        
        let selectablePart = "More details".toAttributedStringLink(font: "Nunito-Regular", size: fontSize+1, color: UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1), isUnderLine: true,url:"https://www.paypal.com/us/webapps/mpp/account-selection")
        
        textMutable.append(selectablePart)
       // textMutable.append(text1Attr)
        // Center the text (optional)
        
        msgTextView?.attributedText = textMutable
        msgTextView?.setLineSpacing(lineSpacing: 2.0)
        msgTextView?.isUserInteractionEnabled = true
    }
    
    func makeMoreDetailsTextLinkable(){
        
        //        To get paid, you need to have a Paypal account. Please provide the email address associated with your Paypal account below. If you don't have a Paypal account, you can create one HERE (you'll be directed to Paypal's website).
        //
        
        var fontSize = 16
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24
        }
        
        //If you earn chat revenue for a given session, we’ll transfer your earnings via PayPal 48 hours post-session. All we need is the email address associated with your PayPal account. If you don’t have a PayPal account, you can create one HERE.
        
        let text = "If you earn chat revenue for a given session, we’ll transfer your earnings via PayPal 48 hours post-session. All we need is the email address associated with your PayPal account. If you don’t have a PayPal account, you can create one "
        
        let textMutable = text.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1), isUnderLine: false)
        
        let text1 = "More details"
        
        let text1Attr = text1.toAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1), isUnderLine: false)
        
        let selectablePart = "HERE.".toAttributedStringLink(font: "Nunito-Regular", size: fontSize+1, color: UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1), isUnderLine: true,url:"https://www.paypal.com/us/webapps/mpp/account-selection")
        
        textMutable.append(selectablePart)
        // textMutable.append(text1Attr)
        // Center the text (optional)
        
        moreDetailsTextView?.attributedText = textMutable
        moreDetailsTextView?.textAlignment = .center
        moreDetailsTextView?.setLineSpacing(lineSpacing: 2.0)
        moreDetailsTextView?.isUserInteractionEnabled = true
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
    
    @IBAction func crossAction(sender:UIButton?){
        
        self.hideMoreDetail()
    }
    
    func showMoreDetailView(){
        
        UIView.animate(withDuration: 0.35) {
            
            self.moreDetailMainView?.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hideMoreDetail(){
        
        UIView.animate(withDuration: 0.35) {
            
            self.moreDetailMainView?.alpha = 0
            self.view.layoutIfNeeded()
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
    
    func initializeMoreDetailLink(){
        
        moreDetailsTextView?.delegate = self
        moreDetailsTextView?.isSelectable = true
        moreDetailsTextView?.isEditable = false
        moreDetailsTextView?.dataDetectorTypes = .link
        moreDetailsTextView?.isUserInteractionEnabled = true
        moreDetailsTextView?.linkTextAttributes = [NSAttributedString.Key.font:UIColor(hexString:AppThemeConfig.themeColor)]
        
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
        
        if textView == moreDetailsTextView{
            
            if characterRange == moreDetailsTextView?.text?.range(of: "HERE.")?.nsRange {
                
                Log.echo(key: "yud", text: "interacting with moreDetailsTextView here")
                return true
            }
        }
        
        if textView == msgTextView{
         
            self.showMoreDetailView()
            return false
        }
//        if characterRange == msgTextView?.text?.range(of: "More Details")?.nsRange {
//
//            Log.echo(key: "yud", text: "interacting with url")
//
//            return false
//        }
         return true
    }
    
}



extension PaymentSetupPaypalController {
    
    class func instance()->PaymentSetupPaypalController? {
                
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PaymentSetupPaypal") as? PaymentSetupPaypalController
        return controller
    }
}


extension PaymentSetupPaypalController:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scroll?.activeField = emailField
        return true
    }
    
    
}
