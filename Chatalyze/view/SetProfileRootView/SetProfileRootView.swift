//
//  SetProfileRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 18/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SetProfileRootView: ExtendedView {
    
    @IBOutlet private var infoTextView:UITextView?
    @IBOutlet private var textCounter:UILabel?
    private let cropper = ImageCropper()
    var controller:SetHostProfileController?
    @IBOutlet private var userNameLbl:UILabel?
    @IBOutlet private var setUpMyProfileContainer:UIView?
    @IBOutlet private var profileImage:UIImageView?
    private var isImageUploaded:Bool = false
    @IBOutlet var scrollBottomConstraint:NSLayoutConstraint?
    @IBOutlet var scrollFld:FieldManagingScrollView?
    let keyboardAccessoryView = SetUpProfileKeyboardAccessory()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        infoTextView?.delegate = self
        getSelectedImage()
        paintInfo()
        scrollFld?.bottomContentOffset = scrollBottomConstraint    
        initializeKeyboardAccessoryView()
    }
    
    func initializeKeyboardAccessoryView(){
    
        var heightOfKeyboardAccessory:CGFloat = 55.0
        if UIDevice.current.userInterfaceIdiom == .pad{
            heightOfKeyboardAccessory = 65
        }
        infoTextView?.inputAccessoryView = keyboardAccessoryView
        keyboardAccessoryView.delegate = self
        keyboardAccessoryView.frame = CGRect(x: 0, y:self.frame.size.height-300, width: self.frame.size.width, height: heightOfKeyboardAccessory)
    }
    
    func paintInfo(){
        
        if let name = SignedUserInfo.sharedInstance?.fullName{            
            userNameLbl?.text = name
        }
    }
    
    func getSelectedImage(){
        
        cropper.getCroppedImage = {(image) in
            
            self.isImageUploaded = true
            self.profileImage?.image = image
            self.verifySetUpProfileButton()
        }
    }
        
    @IBAction func changeImage(sender:UIButton){
        Log.echo(key: "yud", text: "Asking to show")
        cropper.show(controller: self.controller)
    }
}


extension SetProfileRootView:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text.count+text.count) > 0{
            
            Log.echo(key: "yud", text: "Text count is \(textView.text.count+text.count)")
        }
        
        if (textView.text.count+text.count) > 100{
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.textCounter?.text = "\(textView.text.count) of 100"
        self.keyboardAccessoryView.numberOfText?.text = "\(textView.text.count) of 100"
        
        if textView.text.count <= 0 || !self.isImageUploaded{
            
            setUpMyProfileContainer?.backgroundColor = UIColor(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1)
            return
        }
        setUpMyProfileContainer?.backgroundColor = UIColor(red: 105.0/255.0, green: 195.0/255.0, blue: 249.0/255.0, alpha: 1)
    }
    
    func verifySetUpProfileButton(){
        
        if self.infoTextView?.text?.count ?? 0 <= 0 || !self.isImageUploaded {
            
            setUpMyProfileContainer?.backgroundColor = UIColor(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1)
            return
        }
        setUpMyProfileContainer?.backgroundColor = UIColor(red: 105.0/255.0, green: 195.0/255.0, blue: 249.0/255.0, alpha: 1)
    }
    
    func validateField()->Bool{
        
        if self.infoTextView?.text?.count ?? 0 <= 0 || !self.isImageUploaded {
            return false
        }
        return true
    }
    
    func getParam()->[String:String]?{
        
        return ["description":self.infoTextView?.text ?? ""]
    }
    func getImage()->UIImage?{
        
        return profileImage?.image
    }
    
}


extension SetProfileRootView{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        scrollFld?.activeField = infoTextView
        return true
    }
}

extension SetProfileRootView:SetUpProfileKeyboardAccessoryDelegate{

    func doneTapped() {
        
        self.endEditing(true)
    }
}
