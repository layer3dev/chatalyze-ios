//
//  EditProfileRootview.swift
//  Chatalyze
//
//  Created by Mansa on 16/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileRootview: ExtendedView {
   
    let imageCropper = ImageCropper()
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollContentBottomOffset:NSLayoutConstraint?
    var controller:EditProfileController?
    @IBOutlet var picker:CountryPicker?
    @IBOutlet var countryCodeField:SigninFieldView?
    var newUpdates = false
    var chatUpdates = false
    var isCountryPickerHidden = true
    @IBOutlet var newUpadteImage:UIImageView?
    @IBOutlet var chatUpdatesImage:UIImageView?
    @IBOutlet var userImage:UIImageView?
    @IBOutlet var nameField:SigninFieldView?
    @IBOutlet var emailField:SigninFieldView?
    @IBOutlet var oldPasswordField:SigninFieldView?
    @IBOutlet var newPasswordField:SigninFieldView?
    @IBOutlet var confirmPasswordField:SigninFieldView?
    @IBOutlet var mobileNumberField:SigninFieldView?
    @IBOutlet var errorLabel:UILabel?
    @IBOutlet var mainInfoError:UILabel?
    @IBOutlet var passwordInfoError:UILabel?
    @IBOutlet var deactivateErrorLabel:UILabel?
    var countryCode = "+1"
    @IBOutlet var pickerContainer:UIView?
    @IBOutlet var saveMainInfoBtn:UIView?
    
    @IBOutlet var uploadImageViewHeightConstant:NSLayoutConstraint?
    @IBOutlet var changeImageViewHeightConstant:NSLayoutConstraint?
    @IBOutlet var accountPhotoView:UIView?
    @IBOutlet var versionNumber:UILabel?
    
    @IBOutlet var shortBioTextView:UITextView?
    @IBOutlet var shortBioErrorLbl:UILabel?
    
    @IBOutlet var shortBioView:SigninFieldView?
    @IBOutlet var shortbioCountLbl:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
      
        paintInterface()
    }
    
    func initializeThroughController(){
       
        initializeCountryPicker()
        implementTapGestuePicker()
        initializeVariable()
        //fillInfo()
        initializeImageCropper()
    }
    
    
    func initializeImageCropper(){
       
        imageCropper.getCroppedImage = { (croppedImage) in
            
            self.userImage?.image = croppedImage
            self.saveUserImageToServer(image:croppedImage)
            Log.echo(key: "yud", text: "Cropped image is \(croppedImage)")
        }
    }
    
    
    func paintInterface(){
                
        paintButton()
        nameField?.isCompleteBorderAllow = true
        emailField?.isCompleteBorderAllow = true
        oldPasswordField?.isCompleteBorderAllow = true
        newPasswordField?.isCompleteBorderAllow = true
        confirmPasswordField?.isCompleteBorderAllow = true
        mobileNumberField?.isCompleteBorderAllow = true
        countryCodeField?.isCompleteBorderAllow = true
        shortBioView?.isCompleteBorderAllow = true
    }
    
    func paintButton(){
        
        saveMainInfoBtn?.layer.cornerRadius = 3
        saveMainInfoBtn?.layer.masksToBounds = true
    }
    
    func showUploadImageView(){
        
        uploadImageViewHeightConstant?.priority = UILayoutPriority(rawValue: 250)
        changeImageViewHeightConstant?.priority = UILayoutPriority(rawValue: 999)
    }
    
    func showChangeImageView(){
        
        uploadImageViewHeightConstant?.priority = UILayoutPriority(rawValue: 999)
        changeImageViewHeightConstant?.priority = UILayoutPriority(rawValue: 250)
    }
    
    
    func initializeVariable(){
        
        if let roleId = SignedUserInfo.sharedInstance?.role{
            if roleId == .user{
                self.emailField?.isUserInteractionEnabled = true
            }
        }
        nameField?.textField?.delegate = self
        emailField?.textField?.delegate = self
        mobileNumberField?.textField?.delegate = self
        oldPasswordField?.textField?.delegate = self
        newPasswordField?.textField?.delegate = self
        confirmPasswordField?.textField?.delegate = self
        shortBioTextView?.delegate = self
        shortBioTextView?.textColor = UIColor(red: 195.0/255.0, green: 195.0/255.0, blue: 200.0/255.0, alpha: 1)
    }
    
    func implementTapGestuePicker(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.countryAction(sender:)))
        tap.delegate = self
        pickerContainer?.addGestureRecognizer(tap)
    }
    
    func initializeCountryPickerNew(){
        
        initializeCountryPicker()
    }
    
    func fillBio(description:String){
        
        if description == ""{
            return
        }
        shortbioCountLbl?.text = "\(description.count) of 140"
        shortBioTextView?.textColor = UIColor.black
        shortBioTextView?.text = description
    }
    
    func fillInfo() {
        
        guard let info =  SignedUserInfo.sharedInstance else {
            return
        }
        
        fillBio(description: info.userDescription ?? "")
        versionNumber?.text = AppInfoConfig.appversion
        nameField?.textField?.text = info.firstName
        emailField?.textField?.text = info.email
        mobileNumberField?.textField?.text = info.phone
        
        if info.eventMobReminder == true{
            
            chatUpdates = true
            chatUpdatesImage?.image = UIImage(named: "tick")
        }
        
        var code = info.countryCode
        code = code.replacingOccurrences(of: "+", with: "")
        code = "+"+code
        for info in IsoCountries.allCountries{
            if info.calling == code{
                picker?.setSelectedCountryCode(info.alpha2, animated: true)
                countryCodeField?.image?.image = picker?.selectedImage
                countryCode = info.calling
                countryCodeField?.textField?.text = countryCode
            }
        }
        
        //showUploadImageView()
        accountPhotoView?.isUserInteractionEnabled = false
        self.controller?.showLoader()
        if let imageStr = info.profileImage{
            
            userImage?.sd_setImage(with: URL(string:imageStr), placeholderImage: UIImage(named:"editUploadImagePlaceholder"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
                self.controller?.stopLoader()

                self.accountPhotoView?.isUserInteractionEnabled = true
                
                if image != nil{
                    
                    self.userImage?.image = image
                    self.showChangeImageView()
                }
            })
        }
    }
    
    func initializeCountryPicker(){
        
        picker?.delegate = self
    }
    
    @IBAction func countryAction(sender:UIButton){
        
        if isCountryPickerHidden{
            
            isCountryPickerHidden = false
            pickerContainer?.isHidden = false
        }else{
            
            isCountryPickerHidden = true
            pickerContainer?.isHidden = true
        }
    }
}

extension EditProfileRootview:CountryPickerDelegate{
    
    func countryPicker(_ picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
        
        Log.echo(key: "yud", text: "code is \(code)")
        countryCodeField?.textField?.text = picker.selectedCountryCode
        countryCodeField?.image?.image = picker.selectedImage
        
        if let countryCode = (picker.selectedLocale as NSLocale).object(forKey: .countryCode) as? String {
        }
        
        for info in IsoCountries.allCountries{
            if info.alpha2 == code{
                
                countryCodeField?.textField?.text = info.calling
                countryCode = info.calling
                Log.echo(key: "yud", text: "country code is \(countryCode)")
                countryCode = countryCode.replacingOccurrences(of: "+", with: "")
            }
        }
    }
}

extension EditProfileRootview{
    
    @IBAction func newUpdatesAction(sender:UIButton){
        
        if newUpdates{
            
            newUpdates = false
            newUpadteImage?.image = UIImage(named: "untick")
            return
        }
        newUpdates = true
        newUpadteImage?.image = UIImage(named: "tick")
    }
    
    @IBAction func chatTimeAction(sender:UIButton){
        
        if chatUpdates{
            
            chatUpdates = false
            chatUpdatesImage?.image = UIImage(named: "untick")
            return
        }
        chatUpdates = true
        chatUpdatesImage?.image = UIImage(named: "tick")
    }
}

extension EditProfileRootview{
    
    @IBAction func save(sender:UIButton){
        
        errorLabel?.text = ""
        if validateFields(){
            save()
        }        
    }
    
    
    @IBAction func saveMainInfo(sender:UIButton){
        
        mainInfoError?.text = ""
        if validateMainInfo(){
            saveMainInfo()
        }
    }
    
    @IBAction func savePasswordInfo(sender:UIButton){
        
        showChangeImageView()
        passwordInfoError?.text = ""
        if validateChangePassword(){
            savePasswordInfo()
        }
    }
    
    func isMobileNumberActive()->Bool{
        
        if let count = mobileNumberField?.textField?.text?.count{
            if count != 0 {
                return true
            }
            return false
        }
        return false
    }
    
    func save(){
        
        var param = [String:Any]()
        
        if oldPasswordField?.textField?.text != ""{
            
            if isMobileNumberActive(){
                
                param["mobile"] = mobileNumberField?.textField?.text
                param["countryCode"] = countryCode
            }else{
                
                param["mobile"] = NSNull()
                param["countryCode"] = NSNull()
            }
            
            param["oldpassword"] = oldPasswordField?.textField?.text
            param["password"] = newPasswordField?.textField?.text
            param["firstName"] = nameField?.textField?.text
            param["email"] = emailField?.textField?.text
            param["eventMobReminder"] = chatUpdates
            
            Log.echo(key: "yud", text: "params are \(param)")
            
            self.controller?.showLoader()
            EditProfileProcessor().edit(params: param) { (success, message, response) in
                print(message)
                self.controller?.stopLoader()
                if !success{
                    self.errorLabel?.text = message
                    return
                }
                RootControllerManager().signOut(completion: nil)
            }
        }else{
            
            if isMobileNumberActive(){
                
                param["mobile"] = mobileNumberField?.textField?.text
                param["countryCode"] = countryCode
            }else{
                
                param["mobile"] = NSNull()
                param["countryCode"] = NSNull()
            }
            param["firstName"] = nameField?.textField?.text
            param["email"] = emailField?.textField?.text
            param["eventMobReminder"] = chatUpdates
            
            Log.echo(key: "yud", text: "params are \(param)")
            
            self.controller?.showLoader()
            EditProfileProcessor().edit(params: param) { (success, message, response) in
                
                //self.controller?.stopLoader()
                Log.echo(key: "yud", text: "the velue of the success is \(success)")
                if !success{
                    self.controller?.stopLoader()
                    self.errorLabel?.text = message
                    return
                }
                self.fetchProfile()
            }
        }
    }
    
    
    func saveMainInfo(){
        
        var param = [String:Any]()
        
        if isMobileNumberActive(){
            
            param["mobile"] = mobileNumberField?.textField?.text
            param["countryCode"] = countryCode
            
        }else{
            
            param["mobile"] = NSNull()
            param["countryCode"] = NSNull()
            
        }
        
        param["firstName"] = nameField?.textField?.text
        param["email"] = emailField?.textField?.text
        param["eventMobReminder"] = chatUpdates
        param["description"] = shortBioTextView?.text
        
        Log.echo(key: "yud", text: "params are \(param)")
        
        self.controller?.showLoader()
        EditProfileProcessor().edit(params: param) { (success, message, response) in
            
            self.controller?.stopLoader()
            Log.echo(key: "yud", text: "the velue of the success is \(success)")
          
            if !success{
                
                self.controller?.stopLoader()
                self.mainInfoError?.text = message
                return
            }
            
            self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Profile updated", successTitle: "Ok", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                
                self.fetchProfile()
            })
        }
        Log.echo(key: "yud", text: "Please save the mainInfo data acces granted!!")
        
    }
    
    func savePasswordInfo(){
      
        var param = [String:Any]()
        
        param["oldpassword"] = oldPasswordField?.textField?.text
        param["password"] = newPasswordField?.textField?.text
        
        Log.echo(key: "yud", text: "params are \(param)")
        
        self.controller?.showLoader()
        EditProfileProcessor().edit(params: param) { (success, message, response) in
            
            self.controller?.stopLoader()
            if !success{
                self.passwordInfoError?.text = message
                return
            }
            RootControllerManager().signOut(completion: nil)
        }
        Log.echo(key: "yud", text: "Please save the password data access granted!!")
    }
    
    func fetchProfile(){
        
        self.controller?.showLoader()
        FetchProfileProcessor().fetch { (success, message, response) in
            
            self.controller?.stopLoader()
            //self.controller?.navigationController?.popViewController(animated: true)
        }
    }    
    
    @IBAction func deactivateAccount(sender:UIButton){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Are you sure you want to deactivate your account?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alert) in
            
            self.deactivate()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
        }))
        
        self.controller?.present(alert, animated: true, completion: {
            
        })
    }
    
    func deactivate(){
        
        deactivateErrorLabel?.text = ""
        self.controller?.showLoader()
        DeactivateAccountProcessor().deactivate { (success, message, response) in
            
            self.controller?.stopLoader()
            if !success{
                self.deactivateErrorLabel?.text = message
                return
            }
            RootControllerManager().signOut(completion: nil)
        }
    }
}

extension EditProfileRootview{
    
    func validateMainInfo()->Bool{
        
        resetMainInfoError()
        let nameValidate = validateName()
        let emailValidated  = validateEmail()
        let mobileValidate = validateMobileNumber()
        let bioValidate = validateBio()
        return nameValidate && emailValidated && mobileValidate && bioValidate
    }
    
    func validateChangePassword()->Bool{
      
        resetChangePasswordError()
        let oldPasswordValidate = validateOldPassword()
        let newPassword = validateNewPassword()
        return oldPasswordValidate && newPassword
    }
    
    func validateFields()->Bool{
        
        resetErrorStatus()
        if oldPasswordField?.textField?.text != "" || newPasswordField?.textField?.text != "" || confirmPasswordField?.textField?.text != ""{
                        
            let nameValidate = validateName()
            let emailValidated  = validateEmail()
            let oldPasswordValidate = validateOldPassword()
            let newPassword = validateNewPassword()
            let confirmPasswordValidate = valiadteConfirmPassword()
            let codeValidate = validateCountryCode()
            let mobileValidate = validateMobileNumber()
            let recieveEventValidate = validateRecieveEvent()
            
            return nameValidate && emailValidated && oldPasswordValidate && newPassword && confirmPasswordValidate && codeValidate && mobileValidate && recieveEventValidate
            
        }else{
            
            let nameValidate = validateName()
            let emailValidated  = validateEmail()
            let codeValidate = validateCountryCode()
            let mobileValidate = validateMobileNumber()
            let recieveEventValidate = validateRecieveEvent()

            return nameValidate && emailValidated && codeValidate && mobileValidate && recieveEventValidate
        }
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
        shortBioErrorLbl?.text = ""
    }
    
    func resetMainInfoError(){
        
        mainInfoError?.text = ""
        emailField?.resetErrorStatus()
        nameField?.resetErrorStatus()
        mobileNumberField?.resetErrorStatus()
        countryCodeField?.resetErrorStatus()
    }
    
    func resetChangePasswordError(){
        
        passwordInfoError?.text = ""
        oldPasswordField?.resetErrorStatus()
        newPasswordField?.resetErrorStatus()
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
        
        //        if(mobileNumberField?.textField?.text == ""){
        //            mobileNumberField?.showError(text: "Mobile number field can't be left empty !")
        //            return false
        //        }else
        
        if mobileNumberField?.textField?.text?.count  ?? 0 != 0{
            
            if (mobileNumberField?.textField?.text?.count ?? 0) < 8{
                
                mobileNumberField?.showError(text: "Mobile number looks incorrect !")
                return false
            }
            
        }
       else if mobileNumberField?.textField?.text?.count  ?? 0 == 0{
           
            if chatUpdates == true{
                mobileNumberField?.showError(text: "Please provide the mobile number!!")
                return false
            }
        }
        
        mobileNumberField?.resetErrorStatus()
        return true
    }
    
    
    fileprivate func validateRecieveEvent()->Bool{
        
        if (mobileNumberField?.textField?.text?.count ?? 0) == 0 && chatUpdates{
            
            mobileNumberField?.showError(text: "Please fill mobile number")
            return false
        }
        mobileNumberField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validateBio()->Bool{
        
        if(shortBioTextView?.text == "Short bio") || shortBioTextView?.text.replacingOccurrences(of: " ", with: "") == "" || ((shortBioTextView?.text.replacingOccurrences(of: "\n", with: "")) == ""){

            shortBioErrorLbl?.text = "Short bio is required."
            return false
        }
        shortBioErrorLbl?.text = ""
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
    
    func containsLowerCaseLetter() -> Bool{
        
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

extension EditProfileRootview:UIGestureRecognizerDelegate{
}

extension EditProfileRootview:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView?.activeField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField == nameField?.textField{
            emailField?.textField?.becomeFirstResponder()
        }else if textField == emailField?.textField{
            oldPasswordField?.textField?.becomeFirstResponder()
        }else  if textField == oldPasswordField?.textField{
            newPasswordField?.textField?.becomeFirstResponder()
        }else  if textField == newPasswordField?.textField{
            confirmPasswordField?.textField?.becomeFirstResponder()
        }else if textField == confirmPasswordField?.textField{
            mobileNumberField?.textField?.returnKeyType = UIReturnKeyType.done
            mobileNumberField?.textField?.becomeFirstResponder()
        }else{
        }
        return true
    }
}

extension EditProfileRootview{
    
    @IBAction func uploadImage(sender:UIButton?){
        
        imageCropper.show(controller:self.controller)
    }
    
    
    @IBAction func removeImage(sender:UIButton?){
        
        self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Are you sure to remove profile picture?", successTitle: "Yes", rejectTitle: "No", showCancel: true, completion: { (success) in
            
            if !success{
                return
            }
            self.removeImage()
        })
    }
    
    func removeImage(){
       
        self.controller?.showLoader()
        UploadUserImage().deleteUploadedImage { (success, response) in
            self.controller?.stopLoader()
            if success{
                
                self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Profile picture changed successfully.", successTitle: "Ok", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                   
                    self.userImage?.image = UIImage(named:"editUploadImagePlaceholder")
                    self.controller?.fetchInfo()
                    self.showUploadImageView()
                    return
                })
            }
            
            self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Error occurred", successTitle: "Ok", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                
                self.userImage?.image = UIImage(named:"editUploadImagePlaceholder")
                self.controller?.fetchInfo()
                self.showUploadImageView()
                return
            })
            return
        }
    }
    
    func saveUserImageToServer(image:UIImage){
        
        self.controller?.showLoader()
        
        UploadUserImage().uploadImageFormatData(image: image, includeToken: true, progress: { (progress) in
       
        }) {(success) in
            
            if success{
                
                self.controller?.fetchInfo()
                self.userImage?.image = image
                self.showChangeImageView()
                return
            }
            self.controller?.stopLoader()
        }
    }
}


extension EditProfileRootview:UITextViewDelegate{
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text.count + text.count > 140 {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        shortbioCountLbl?.text = "\(textView.text.count) of 140"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        scrollView?.activeField = textView
        if shortBioTextView?.text == "Short bio"{
           
            shortBioTextView?.text = ""
            shortBioTextView?.textColor = UIColor.black
            return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
        if shortBioTextView?.text == ""{
           
            shortBioTextView?.text = "Short bio"
            shortBioTextView?.textColor = UIColor(red: 195.0/255.0, green: 195.0/255.0, blue: 200.0/255.0, alpha: 1)
            return
        }
        shortBioTextView?.textColor = UIColor.black
        return
    }
}
