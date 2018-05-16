//
//  GreetingRecipientRootView.swift
//  Chatalyze
//
//  Created by Mansa on 10/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class GreetingRecipientRootView: ExtendedView {
    
    var controller:GreetingrecipientController?
    @IBOutlet fileprivate var emailField : SigninFieldView?
    @IBOutlet fileprivate var firstName : SigninFieldView?
    @IBOutlet var occasionFieldView:SigninFieldView?
    @IBOutlet var note1Field:SigninFieldView?
    @IBOutlet var note2Field:SigninFieldView?
    @IBOutlet var note3Field:SigninFieldView?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollViewBottomConstraints:NSLayoutConstraint?
    @IBOutlet var errorLabel:UILabel?
    @IBOutlet var signUpBtn:UIView?
    @IBOutlet var pickerView:UIView?
    @IBOutlet var picker:UIPickerView?
    var pickerIsHidden = true
    var occassionArray = ["Anniversary","Birthday","Congrats","Get Well","Motivational"]
    var info:GreetingInfo?
    var param = [String:Any]()
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        initializeVariable()
    }
    
    func paintInterface(){
        
        signUpBtn?.layer.cornerRadius = 5
        signUpBtn?.layer.masksToBounds = true
    }    
    
    func initializeVariable(){
        
        picker?.dataSource = self
        picker?.delegate = self
        picker?.reloadAllComponents()
        note1Field?.textField?.delegate = self
        note2Field?.textField?.delegate = self
        note3Field?.textField?.delegate = self
        emailField?.textField?.delegate = self
        firstName?.textField?.delegate = self
        scrollView?.bottomContentOffset = scrollViewBottomConstraints     
    }
    
    func updateScrollField(textview:UITextView?){
        
        self.scrollView?.activeField = textview
    }
    
    @IBAction func nextAction(sender:UIButton){
        
        if(validateFields()){
            
            self.resetErrorStatus()
            requestGreeting()
        }
    }
    
    func requestGreeting(){
        
        guard let controller = PaymentController.instance() else {
            return
        }
        controller.param = self.getParam()
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getParam()->[String:Any]{
        
        if let occasion = occasionFieldView?.textField?.text{
           
            param["occasion"] = occasion
        }
        if let name = firstName?.textField?.text{
            
            param["name"] = name
        }
        if let email = emailField?.textField?.text{
            
            param["email"] = email
        }
        if let analystId  = self.info?.id{
            
            param["analystId"] = analystId
        }
        
        param["delivery_date"] = "2018-06-06T15:50:00+05:30"
        
        if let note1 = note1Field?.textField?.text{
            
             param["personal_note"] = "\([["text":note1],["text":""],["text":""]])"
            if let note2 = note1Field?.textField?.text{
                param["personal_note"] = "\([["text":note1],["text":note2],["text":""]])"
                if let note3 = note1Field?.textField?.text{
                    param["personal_note"] = "\([["text":note1],["text":note2],["text":note3]])"
                }
            }
        }
        
        param["remember"] = false
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return param
        }
        param["userId"] = selfId
        
        print(param)
        return param
    }
    
}

extension GreetingRecipientRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView?.activeField = textField
        return true
    }
}
extension GreetingRecipientRootView{
    
    func validateFields()->Bool{
        
        let firstnameValidate = valiadteFirstName()
        let emailValidated  = validateEmail()
        let occasionValidated  = valiadteOccasion()
        let note1Validated  = validNotes1()
        let note2Validated  = validNotes2()
        let note3Validated  = validNotes3()
        return emailValidated && firstnameValidate && occasionValidated && note1Validated && note2Validated && note3Validated
    }
    
    func resetErrorStatus(){
        
        errorLabel?.text = ""
        emailField?.resetErrorStatus()
        firstName?.resetErrorStatus()
        occasionFieldView?.resetErrorStatus()
        note1Field?.resetErrorStatus()
        note2Field?.resetErrorStatus()
        note3Field?.resetErrorStatus()
    }
    
    func showError(text : String?){
        
        errorLabel?.text = text
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

    fileprivate func valiadteFirstName()->Bool{
        
        
        if(firstName?.textField?.text == ""){
            firstName?.showError(text: "Firstname field can't be left empty !")
            return false
        }
        else if !(FieldValidator.sharedInstance.validatePlainString(firstName?.textField?.text ?? "")){
            firstName?.showError(text: "Firstname looks incorrect !")
            return false
        }
        firstName?.resetErrorStatus()
        return true
    }
    
    fileprivate func valiadteOccasion()->Bool{
        
        if(occasionFieldView?.textField?.text == ""){
            occasionFieldView?.showError(text: "Occasion field can't be left empty !")
            return false
        }
        occasionFieldView?.resetErrorStatus()
        return true
    }
   
    fileprivate func validNotes1()->Bool{
        
        
        if(note1Field?.textField?.text == ""){
            note1Field?.showError(text: "Note field can't be left empty !")
            return false
        }
        note1Field?.resetErrorStatus()
        return true
    }
    fileprivate func validNotes2()->Bool{
        
        
        if( note2Field?.textField?.text == ""){
            note2Field?.showError(text: "Note field can't be left empty !")
            return false
        }
        note2Field?.resetErrorStatus()
        return true
    }
    fileprivate func validNotes3()->Bool{
        
        
        if(note3Field?.textField?.text == ""){
            note3Field?.showError(text: "Note field can't be left empty !")
            return false
        }
        note3Field?.resetErrorStatus()
        return true
    }
}

extension GreetingRecipientRootView{
    
    @IBAction func signUpButton(sender:UIButton){
        
        if validateFields(){
        }
    }
    
    @IBAction func occasionAction(sender:UIButton){
        
        
        if pickerIsHidden{
            pickerView?.isHidden = false
            pickerIsHidden = false
        }else{
            pickerView?.isHidden = true
            pickerIsHidden = true
        }
    }
}


extension GreetingRecipientRootView:UIPickerViewDelegate,UIPickerViewDataSource{
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
       return occassionArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.occasionFieldView?.textField?.text = occassionArray[row]
    }
    
    @IBAction func doneAction(sender:UIButton){
       
        self.pickerView?.isHidden = true
        self.pickerIsHidden = true
    }
}
