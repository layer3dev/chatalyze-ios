//
//  SessionChatInfoRootView.swift
//  Chatalyze
//
//  Created by Mansa on 09/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class SessionChatInfoRootView:ExtendedView{
    
    var controller:SessionChatInfoController?
    enum slotDurationMin:Int{
    
        case two = 0
        case three = 1
        case five = 2
        case ten = 3
        case fifteen = 4
        case thirty = 5
        case none = 6
    }
    
    enum isSelfieAllowed:Int{
        
        case yes = 0
        case no = 1
        case none = 2
    }
    
    @IBOutlet var priceField:SigninFieldView?
    
    @IBOutlet var twoMinutesBtn:UIButton?
    @IBOutlet var threeMinutesBtn:UIButton?
    @IBOutlet var fiveMinutesBtn:UIButton?
    @IBOutlet var tenMinutesBtn:UIButton?
    @IBOutlet var fifteenMinutesBtn:UIButton?
    @IBOutlet var thirtyMinutesBtn:UIButton?
    
    @IBOutlet var isSocialYesBtn:UIButton?
    @IBOutlet var isSocialNoBtn:UIButton?
    
    var slotSelected:slotDurationMin = .none
    var isSocialSelfieAllowed:isSelfieAllowed = .none
    
    @IBOutlet var socialErrorLbl:UILabel?
    @IBOutlet var slotDurationErrorLbl:UILabel?
    
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollContentBottonOffset:NSLayoutConstraint?
    
    override func viewDidLayout(){
        super.viewDidLayout()
       
        initializeVariable()
    }
    
    func initializeVariable(){
  
        scrollView?.bottomContentOffset = scrollContentBottonOffset
        priceField?.textField?.delegate = self
        priceField?.textField?.keyboardType = UIKeyboardType.numberPad
        
    }
    
    
    func resetDurationSelection(){
        
        twoMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        threeMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        fiveMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        tenMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        
        fifteenMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        thirtyMinutesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
    }
    func resetSocialSelection(){
       
        isSocialYesBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
        isSocialNoBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
    }
    

    @IBAction func chatSlotDurationAction(sender:UIButton){
       
        if sender.tag == 0 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .two
        }
        else if sender.tag == 1 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .three
        }
        else if sender.tag == 2 {

            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .five
        }
        else if sender.tag == 3 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .ten
        }
        else if sender.tag == 4 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .fifteen
        }
        else if sender.tag == 5 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .thirty
        }
    }
    
    @IBAction func isAllowedForSelfieAction(sender:UIButton){
        
        if sender.tag == 0 {
            
            resetSocialSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.isSocialSelfieAllowed = .yes
        }
        else if sender.tag == 1{
            
            resetSocialSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.isSocialSelfieAllowed = .no
        }
    }
    
    @IBAction func nextAction(sender:UIButton){
    
        if(validateFields()){
            self.resetErrorStatus()
            next()
        }
    }
    
    func next(){
        
        Log.echo(key: "yud", text: "You are eligible ")
        
    }
    
    
    func resetErrorStatus(){
        
        slotDurationErrorLbl?.text = ""
        socialErrorLbl?.text = ""
        priceField?.resetErrorStatus()
    }
    
    func validateFields()->Bool{
      
        let priceValidated  = priceValidation()
        let durationValidated = validateSlotTime()
        let socialValidation = validateSocialSharing()
        return priceValidated && socialValidation && durationValidated
    }
    
    fileprivate func priceValidation()->Bool{
        
        if(priceField?.textField?.text == ""){
            
            priceField?.showError(text: "Price is required.")
            return false
        }
        priceField?.resetErrorStatus()
        return true
    }
    fileprivate func validateSlotTime()->Bool{
        
        if(slotSelected == .none){
            
            slotDurationErrorLbl?.text = "Chat duration is required."
            return false
        }
        slotDurationErrorLbl?.text = ""
        return true
    }
    
    fileprivate func validateSocialSharing()->Bool{
        
        if(isSocialSelfieAllowed == .none){
            
            socialErrorLbl?.text = "Please tell if you are comfortable with the screenshot capture."
            return false
        }
        socialErrorLbl?.text = ""
        return true
    }
    
    func showError(message:String?){
        //errorLbl?.text =  message ?? ""
    }
}

extension SessionChatInfoRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = priceField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("String is \(string)")
        return true
    }
}
