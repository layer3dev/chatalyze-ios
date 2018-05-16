//
//  EditProfileRootview.swift
//  Chatalyze
//
//  Created by Mansa on 16/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import CountryPicker

class EditProfileRootview: ExtendedView {

    var controller:EditProfileController?
    @IBOutlet var picker:CountryPicker?
    @IBOutlet var countryCodeField:SigninFieldView?
    var newUpdates = false
    var chatUpdates = false
    var isCountryPickerHidden = true
    @IBOutlet var newUpadteImage:UIImageView?
    @IBOutlet var chatUpdatesImage:UIImageView?
    @IBOutlet var nameField:SigninFieldView?
    @IBOutlet var emailField:SigninFieldView?
    @IBOutlet var oldPasswordField:SigninFieldView?
    @IBOutlet var newPasswordField:SigninFieldView?
    @IBOutlet var confirmPasswordField:SigninFieldView?
    @IBOutlet var mobileNumberField:SigninFieldView?
    @IBOutlet var errorLabel:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
      
        initializeCountryPicker()
    }
    
    func initializeCountryPicker(){
        
        let locale = Locale.current
        picker?.countryPickerDelegate = self
        picker?.showPhoneNumbers = true
        if let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
            picker?.setCountry(code)
        }
    }
    
    @IBAction func countryAction(sender:UIButton){
        
        if isCountryPickerHidden{
            
            isCountryPickerHidden = false
            picker?.isHidden = false
        }else{

            isCountryPickerHidden = true
            picker?.isHidden = true
        }
    }
}

extension EditProfileRootview:CountryPickerDelegate{
  
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        countryCodeField?.textField?.text = phoneCode
        countryCodeField?.image?.image = flag
    }
}

extension EditProfileRootview{
    
    @IBAction func newUpdatesAction(sender:UIButton){
        
//        var newUpdates = false
//        var chatUpdates = false
//        var isCountryPickerHidden = true
//        @IBOutlet var newUpadteImage:UIImageView?
//        @IBOutlet var chatUpdatesImage:UIImageView?
        
//        if newUpdates{
//            newUpdates = false
//
//        }
    }
    
    @IBAction func chatTimeAction(sender:UIButton){
        
    }
}

extension EditProfileRootview{
    
    @IBAction func save(sender:UIButton){
        
        if !validateFields(){
            save()
        }        
    }
    
    func save(){
        
    }
    
    
    @IBAction func deactivateAccount(sender:UIButton){
    }
    
}

extension EditProfileRootview{
    
    func validateFields()->Bool{
        
        let nameValidate = validateName()
        let emailValidated  = validateEmail()
        let oldPasswordValidate = validateOldPassword()
        let newPassword = validateNewPassword()
        let confirmPasswordValidate = valiadteConfirmPassword()
        let codeValidate = validateCountryCode()
        let mobileValidate = validateMobileNumber()

        return nameValidate && emailValidated && oldPasswordValidate && newPassword && confirmPasswordValidate && codeValidate && mobileValidate
    }
    
    func resetErrorStatus(){
        
        errorLabel?.text = ""
        emailField?.resetErrorStatus()
        nameField?.resetErrorStatus()
        oldPasswordField?.resetErrorStatus()
        newPasswordField?.resetErrorStatus()
        confirmPasswordField?.resetErrorStatus()
        mobileNumberField?.resetErrorStatus()
        countryCodeField?.resetErrorStatus()
        
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
    
    fileprivate func validateOldPassword()->Bool{
        
        if(oldPasswordField?.textField?.text == ""){
            oldPasswordField?.showError(text: "Old password field can't be left empty !")
            return false
        }
        oldPasswordField?.resetErrorStatus()
        return true
    }
    
    
    fileprivate func validateNewPassword()->Bool{
        
        if(newPasswordField?.textField?.text == ""){
            newPasswordField?.showError(text: "New password field can't be left empty !")
            return false
        }
        if let text = newPasswordField?.textField?.text {
            if (!text.containsNumbers()) || !(text.containsUpperCaseLetter()) || !(text.containsLowerCaseLetter()){
                newPasswordField?.showError(text: "Password field should contain an uppercase letter , a numeric and a lowercase letter !")
                return false
            }
        }
        newPasswordField?.resetErrorStatus()
        return true
    }
    
    
    fileprivate func valiadteConfirmPassword()->Bool{
        
        if(confirmPasswordField?.textField?.text == ""){
            confirmPasswordField?.showError(text: "Confirm password field can't be left empty !")
            return false
        }
        else if (confirmPasswordField?.textField?.text != newPasswordField?.textField?.text){
            
            confirmPasswordField?.showError(text: "Password does not match to new password!")
            return false
        }
        confirmPasswordField?.resetErrorStatus()
        return true
    }
    
    
    fileprivate func validateName()->Bool{
        
        if(nameField?.textField?.text == ""){
            nameField?.showError(text: "Name field can't be left empty !")
            return false
        }
        else if !(FieldValidator.sharedInstance.validatePlainString(nameField?.textField?.text ?? "")){
            nameField?.showError(text: "Name looks incorrect !")
            return false
        }
        nameField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validateCountryCode()->Bool{
        
        if(countryCodeField?.textField?.text == ""){
            countryCodeField?.showError(text: "CountryCode field can't be left empty !")
            return false
        }
        countryCodeField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validateMobileNumber()->Bool{
        
        if(mobileNumberField?.textField?.text == ""){
            mobileNumberField?.showError(text: "Mobile number field can't be left empty !")
            return false
        }
        mobileNumberField?.resetErrorStatus()
        return true
    }
}

extension String{
    
    func containsNumbers() -> Bool {
        
        // check if there's a range for a number
        let range = self.rangeOfCharacter(from: .decimalDigits)
        // range will be nil if no whitespace is found
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
    func containsLowerCaseLetter() -> Bool {
        
        // check if there's a range for a number
        let range = self.rangeOfCharacter(from: .lowercaseLetters)
        // range will be nil if no whitespace is found
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
    func containsUpperCaseLetter() -> Bool {
        
        // check if there's a range for a number
        let range = self.rangeOfCharacter(from: .uppercaseLetters)
        // range will be nil if no whitespace is found
        if let _ = range {
            return true
        } else {
            return false
        }
    }
}

