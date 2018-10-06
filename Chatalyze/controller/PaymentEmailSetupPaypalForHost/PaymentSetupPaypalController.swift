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
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //maketextLinkable()
        setUpGestureOnLabel()
        paintInterface()
        fetchPaypalInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "PAYMENT")
    }
    
    func paintInterface(){
        
        paintBackButton()
    }
    
    func validateFields()->Bool{
        
        let emailValidated  = validateEmail()
        return emailValidated
    }
    
    fileprivate func validateEmail()->Bool{
        
        if(emailField?.textField?.text == ""){
            emailField?.showError(text: "Email field can't be left empty !")
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
        
        //https://dev.chatalyze.com/api/paymentEmail/
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
        
        let attributeForStringHere = [NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size:18),NSAttributedStringKey.underlineColor:UIColor(hexString: AppThemeConfig.themeColor),NSAttributedStringKey.underlineStyle:1,NSAttributedStringKey.link:" HERE ",NSAttributedStringKey.strokeColor:UIColor(hexString: AppThemeConfig.themeColor),NSAttributedStringKey.foregroundColor: UIColor(hexString: AppThemeConfig.themeColor)] as [NSAttributedStringKey : Any]
        
        //        let secondStr = NSMutableAttributedString(string: " 2 3", attributes: self.whiteAttribute)
        
        let text = NSMutableAttributedString(string: "To get paid, you need to have a Paypal account. Please provide the email address associated with your Paypal account below. If you don't have a Paypal account, you can create one")
        
        text.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue", size: 16), range: NSMakeRange(0, text.length))
        
        let text1 = NSMutableAttributedString(string: "(you'll be directed to Paypal's website)")
        
        text1.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue", size: 16), range: NSMakeRange(0, text1.length))
        
        
        let selectablePart = NSMutableAttributedString(string: " HERE ", attributes: attributeForStringHere)
        
        //        msgLbl?.
        
        //        selectablePart.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue", size: 16), range: NSMakeRange(0, selectablePart.length))
        //        // Add an underline to indicate this portion of text is selectable (optional)
        //        selectablePart.addAttribute(NSAttributedStringKey.underlineStyle, value: 1, range: NSMakeRange(0,selectablePart.length))
        //
        //        selectablePart.addAttribute(NSAttributedStringKey.underlineColor, value: UIColor.green, range: NSMakeRange(0, selectablePart.length))
        //
        //        selectablePart.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green, range: NSMakeRange(0, selectablePart.length))
        //        // Add an NSLinkAttributeName with a value of an url or anything else
        //
        //        selectablePart.addAttribute(NSAttributedStringKey.link, value: "HERE ", range: NSMakeRange(0,selectablePart.length))
        //        selectablePart.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green, range: NSMakeRange(0, selectablePart.length))
        //
                
        // Combine the non-selectable string with the selectable string
        text.append(selectablePart)
        text.append(text1)
        // Center the text (optional)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
       
        //        text.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        
        //Explicit
        //        let linkAttributes: [NSAttributedStringKey: Any] = [
        //            .link: NSURL(string: "https://www.apple.com")!
        //        ]
        
        // selectablePart.setAttributes(linkAttributes, range: NSMakeRange(0,selectablePart.length))
        //Doing
        
        //To set the link text color (optional)
        
        //        msgLbl?.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:UIColor.green, NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue", size: 20)] as? [String : Any]
        
        //Set the text view to contain the attributed text
        
        msgLbl?.attributedText = text
        msgLbl?.isUserInteractionEnabled = true
    }
    
    func setUpGestureOnLabel(){
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
        self.msgLbl?.addGestureRecognizer(tap)
        self.msgLbl?.isUserInteractionEnabled = true
    }
    
    @objc func tapLabel(tap: UITapGestureRecognizer) {
        
        if let msglabel = self.msgLbl{
            guard let range = msglabel.text?.range(of: "create one HERE (you'll")?.nsRange else {
                return
            }
            if tap.didTapAttributedTextInLabel(label: msglabel, inRange: range) {
                Log.echo(key: "yud",text: "Sub string is tapped")
                
                if #available(iOS 10.0, *) {
                    
                    guard let url = URL(string: "https://www.paypal.com/us/webapps/mpp/account-selection") else{
                        return
                    }
                    
                    UIApplication.shared.open(url, options: [:])
                } else {
                    // Fallback on earlier versions
                }
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


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}
