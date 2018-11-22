//
//  EditScheduledSessionRootView.swift
//  Chatalyze
//
//  Created by Yudhisther on 30/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import QuartzCore
import CoreText
import UIKit

class EditScheduledSessionRootView:ExtendedView{
    
    let imagePicker = UIImagePickerController()
    let cropper = ImageCropper()
    
    var controller:EditScheduledSessionController?
    
    @IBOutlet var namePriceViewHieghtConstraints:NSLayoutConstraint?
    
    @IBOutlet var namePriceViewBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var namePriceEditViewHieghtConstraints:NSLayoutConstraint?
    @IBOutlet var namePriceEditViewBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var descriptionHeightConstraints:NSLayoutConstraint?
    @IBOutlet var descriptionBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var editDescriptionHeightConstraints:NSLayoutConstraint?
    @IBOutlet var editDescriptionBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var sessionNameLbl:UILabel?
    

    var priceAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font:UIFont(name: "Questrial", size: 17)]
    var titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 17)]
    
    var numberOfUnitAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#8C9DA1"),NSAttributedString.Key.font:UIFont(name: "Questrial", size: 16)]
    var editChatattributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: AppThemeConfig.themeColor),NSAttributedString.Key.font:UIFont(name: "Questrial", size: 16)]

    
    var param = [String:Any]()
    
//    var param:[String:Any] = ["isFree": false, "screenshotAllow": "automatic", "title": "Chat Session", "end": "2018-08-31T06:06:27.000+0000", "duration": 5, "price": "1000", "start": "2018-08-31T05:36:27.000+0000", "userId": "36"]
    
    
    @IBOutlet var hostnameLbl:UILabel?
    
    @IBOutlet var eventNameLbl:UILabel?
    
    @IBOutlet var costofEventLbl:UILabel?
    
    @IBOutlet var dateTimeLbl:UILabel?
    
    @IBOutlet var eventInfoLbl:UILabel?
    
    @IBOutlet var eventDetailInfo:UILabel?
    
    @IBOutlet var descriptionBackLbl:UILabel?
  
    @IBOutlet var descriptionEditLbl:UILabel?
    
    @IBOutlet var sessionNameField:SigninFieldView?
   
    @IBOutlet var descriptionEditTextViewContainer:UIView?
   
    @IBOutlet var descriptionTextView:UITextView?
    
    @IBOutlet var scrollView:FieldManagingScrollView?
    
    @IBOutlet var contentBottomOffsetConstraints:NSLayoutConstraint?
    
    var delegate:UpdateForEditScheduleSessionDelgete?
    var totalTimeDuration = 0
    var editedParam = [String:Any]()
    
    @IBOutlet var imageUploadingView:UIView?
   
    @IBOutlet var uploadedImage:UIImageView?
    
   
    @IBOutlet var heightOfUploadImageConstraint:NSLayoutConstraint?
    
    @IBOutlet var heightOfuploadedImageConstraint:NSLayoutConstraint?
    
    @IBOutlet var editImageLbl:UILabel?
    
    var selectedImage:UIImage?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeVariable()
        paintInerface()
    }
    
    func paintImageUploadBorder(){
        
        imagePicker.delegate = self
        
//        imageUploadingView?.layer.borderWidth = 2.0
//        imageUploadingView?.layer.borderColor = UIColor(hexString: "#27B879").cgColor
        
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor(hexString: AppThemeConfig.themeColor).cgColor
        yourViewBorder.lineDashPattern = [8, 4]
        yourViewBorder.frame = (imageUploadingView?.bounds) ?? CGRect.zero
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: (imageUploadingView?.bounds) ?? CGRect.zero).cgPath
         imageUploadingView?.layer.addSublayer(yourViewBorder)
    }
    
    
    func paintInerface(){
    
        //paintImageUploadBorder()
        paintEditChangeImagelbl()
        
        imagePicker.navigationBar.barTintColor = UIColor.black
        descriptionEditTextViewContainer?.layer.borderWidth = 0.5
        descriptionEditTextViewContainer?.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func fillInfo(info:[String:Any]?,totalDurationofEvent:Int,selectedImage:UIImage?){
        
//        Log.echo(key: "yud", text: "The current time zone ios \(Locale.current.identifier)\(Locale.current.regionCode)")
        
        guard let info = info else {
            return
        }
        
        self.param = info
        self.totalTimeDuration = totalDurationofEvent
        self.selectedImage = selectedImage
        
        if selectedImage != nil{
            
            uploadedImage?.image = selectedImage
            self.heightOfUploadImageConstraint?.priority = UILayoutPriority(999.0)
            self.heightOfuploadedImageConstraint?.priority = UILayoutPriority(250.0)
        }
        
        
        if let userInfo = SignedUserInfo.sharedInstance{
            
            let username = userInfo.fullName
            hostnameLbl?.text = username
        }
        if let title = info["title"] as? String{
            
            sessionNameField?.textField?.text = title
            
            let firstStr = NSMutableAttributedString(string: title, attributes: self.titleAttribute as [NSAttributedString.Key : Any])
            
            let secondStr = NSMutableAttributedString(string: " Edit Chat", attributes: editChatattributes as [NSAttributedString.Key : Any])
            
            let requiredStr = NSMutableAttributedString()
            requiredStr.append(firstStr)
            requiredStr.append(secondStr)
            
            //Log.echo(key: "yud", text: "price is requiered String \(requiredStr)")
            eventNameLbl?.attributedText = requiredStr
        }
        
        if let price = info["price"]{
            
            costofEventLbl?.isHidden = false
            
            let firstStr = NSMutableAttributedString(string: "$ \(price)", attributes: self.priceAttribute as [NSAttributedString.Key : Any])
            
            let secondStr = NSMutableAttributedString(string: " per chat", attributes: numberOfUnitAttributes as [NSAttributedString.Key : Any])
            
            let requiredStr = NSMutableAttributedString()
            requiredStr.append(firstStr)
            requiredStr.append(secondStr)
            
            Log.echo(key: "yud", text: "price is requiered String \(requiredStr) and the price is \(price)")
            
            costofEventLbl?.attributedText = requiredStr
           
            //costofEventLbl?.text = "asdasfdsfds"
            
            Log.echo(key: "yud", text: "costofEventLbl text is \(costofEventLbl?.text)")
        }
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info["start"] as? String, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "EE, MMM dd yyyy"){
            
            self.dateTimeLbl?.text = startTime
        }
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info["start"] as? String, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "hh:mm"){
            
            self.eventInfoLbl?.text = "\(self.eventInfoLbl?.text ?? "") \(startTime)-"
            
            if let endTime = DateParser.convertDateToDesiredFormat(date: info["end"] as? String, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "hh:mm a"){
                
                self.eventInfoLbl?.text = "\(self.eventInfoLbl?.text ?? "")\(endTime) \(Locale.current.regionCode ?? "")"
                
                eventInfoLbl?.text = "\(info["duration"] ?? 0.0)-minutes video chats available from \(startTime)-\(endTime) \(Locale.current.regionCode ?? "")"
                
               // 3-minute video chats available from 07:00 - 07:30 PM IST
            }
        }
        
        
        let durate = info["duration"] as? Int
        let numberofEvent = (totalDurationofEvent/(durate ?? 1))
        
        if param["description"] == nil{
            
            eventDetailInfo?.text = "I'm hosting \(numberofEvent) private 1:1 video chats during this session. If you purchase a chat, you'll receive a scheduled time when we'll connect. We'll talk, you can ask questions, and we'll get to know each other!"
            
            descriptionTextView?.text = "I'm hosting \(numberofEvent) private 1:1 video chats during this session. If you purchase a chat, you'll receive a scheduled time when we'll connect. We'll talk, you can ask questions, and we'll get to know each other!"
        }else{
          
            eventDetailInfo?.text = param["description"] as? String
            descriptionTextView?.text = param["description"] as? String
        }
        
//        if let startTime = DateParser.convertDateToDesiredFormat(date: info["start"] as? String, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "MMM dd"){
//
//            self.eventDetailInfo?.text = "\(self.eventDetailInfo?.text ?? "") \(startTime)! Here's how:"
//        }
    }
    
    func askToSelectUploadType(){
        
        let sheet = UIAlertController(title: "Select Action", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
           
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Choose from Gallery", style: .default) { (action) in
            /**
             *  Create fake photo
             */
            //            let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate"))
            //            self.addMedia(photoItem!)
            self.openGallery()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(photoAction)
        sheet.addAction(galleryAction)
        sheet.addAction(cancelAction)
        self.controller?.present(sheet, animated: true, completion: nil)
    }
    
    
    func openCamera(){
        
        if !UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera) {
            return
        }
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.controller?.present(imagePicker, animated: true, completion: nil)
            return;
            
            
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    self.controller?.present(self.imagePicker, animated: true, completion: nil)
                    return;
                    
                } else {
                    
                    let alert = UIAlertController(title: AppInfoConfig.appName, message: "Please give the camera permission from the settings", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
                        
                        UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                        
//                        UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL, options: ., completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
                    }))
                    self.controller?.present(alert, animated: true, completion: {
                    })
                }
            })
        }
    }
    func openGallery(){
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.controller?.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(sender:UIButton?){
        
        
        cropper.show(controller: self.controller)
        
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//        imagePicker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//
//        self.controller?.present(imagePicker, animated: true, completion: {
//
//        })
        //imagePicker.popoverPresentationController?. = sender
    }
    
    @objc func changeImage(sender:UIButton?){
       
        delegate?.selectedImage(image:nil)
        uploadedImage?.image = UIImage(named:"base")
        selectedImage = nil
        heightOfUploadImageConstraint?.priority = UILayoutPriority(250.0)
        heightOfuploadedImageConstraint?.priority = UILayoutPriority(999.0)
    }
    
    
    @IBAction func saveTitleAction(sender:UIButton?){
        
        //Verifying for title text to be empty.
        guard let titleText =  sessionNameField?.textField?.text else {
            return
        }
        let text = titleText.replacingOccurrences(of: " ", with: "")
        if text == ""{
            return
        }
        self.param["title"] = sessionNameField?.textField?.text
        self.editedParam["title"] = sessionNameField?.textField?.text
        self.fillInfo(info: self.param, totalDurationofEvent: self.totalTimeDuration, selectedImage: self.selectedImage)
        delegate?.updatedEditedParams(info:self.editedParam)
        hideNamePriceEditInfoView()
        showNamePriceInfoView()
    }
    
    @IBAction func saveDescriptionAction(sender:UIButton?){
        
        //Verifying for title text to be empty.
        guard let descriptionText =  descriptionTextView?.text else {
            return
        }
        let description = descriptionText.replacingOccurrences(of: " ", with: "")
        if description == ""{
            return
        }
        self.param["description"] = descriptionTextView?.text
        self.editedParam["description"] = descriptionTextView?.text
        self.fillInfo(info: self.param, totalDurationofEvent: self.totalTimeDuration, selectedImage: self.selectedImage)
        delegate?.updatedEditedParams(info:self.editedParam)
        hideEditDescriptionInfoView()
        showDescriptionInfoView()
    }
    
    func initializeVariable(){
        
        implementGestureOnEditSessionName()
        scrollView?.bottomContentOffset = contentBottomOffsetConstraints
        sessionNameField?.textField?.delegate = self
        descriptionTextView?.delegate = self
        initializeCropper()
    }
    
    
    func initializeCropper(){
       
        cropper.isOnlySquare = true
        cropper.getCroppedImage = {(croppedImage) in
           
            self.uploadedImage?.contentMode = .scaleAspectFit
            self.uploadedImage?.image = croppedImage
            self.selectedImage = croppedImage
            self.delegate?.selectedImage(image:self.selectedImage)
            self.heightOfUploadImageConstraint?.priority = UILayoutPriority(999.0)
            self.heightOfuploadedImageConstraint?.priority = UILayoutPriority(250.0)
        }
    }
    
    
    func paintEditChangeImagelbl(){
        
        var fontSize = 15
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 18
        }
        
        let text = "Change picture"
        editImageLbl?.attributedText = text.toAttributedString(font: "Questrial", size: fontSize, color: UIColor(hexString: "#Faa579"), isUnderLine: true)
    }
    
    func implementGestureOnEditSessionName(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.editSessionNameAction))
        self.sessionNameLbl?.isUserInteractionEnabled = true
        self.sessionNameLbl?.isEnabled = true
        sessionNameLbl?.addGestureRecognizer(tapGesture)
        
        
        let tapGestureOnEditDescription = UITapGestureRecognizer(target: self, action: #selector(self.editDescriptionAction))
        self.descriptionEditLbl?.isUserInteractionEnabled = true
        self.descriptionEditLbl?.isEnabled = true
        descriptionEditLbl?.addGestureRecognizer(tapGestureOnEditDescription)
        
        let tapGestureOnDisbleEditDescription = UITapGestureRecognizer(target: self, action: #selector(self.disableEditDescriptionAction))
        self.descriptionBackLbl?.isUserInteractionEnabled = true
        self.descriptionBackLbl?.isEnabled = true
        descriptionBackLbl?.addGestureRecognizer(tapGestureOnDisbleEditDescription)        
        
        let tapGestureEditImage = UITapGestureRecognizer(target: self, action: #selector(self.changeImage(sender:)))
        self.editImageLbl?.isUserInteractionEnabled = true
        self.editImageLbl?.isEnabled = true
        editImageLbl?.addGestureRecognizer(tapGestureEditImage)
    }
    
    func hideNamePriceInfoView(){
        
        namePriceViewHieghtConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showNamePriceInfoView(){
        
        namePriceViewHieghtConstraints?.priority = UILayoutPriority(250.0)
    }
    
    func hideNamePriceEditInfoView(){
        
        namePriceEditViewHieghtConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showNamePriceEditInfoView(){
        
        namePriceEditViewHieghtConstraints?.priority = UILayoutPriority(250.0)
    }
    
    func hideDescriptionInfoView(){
        
        descriptionHeightConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showDescriptionInfoView(){
        
        descriptionHeightConstraints?.priority = UILayoutPriority(250.0)
    }
    
    func hideEditDescriptionInfoView(){
        
        editDescriptionHeightConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showEditDescriptionInfoView(){
        
        editDescriptionHeightConstraints?.priority = UILayoutPriority(250.0)
    }
    
    @objc func editSessionNameAction(){
        
        showNamePriceEditInfoView()
        hideNamePriceInfoView()
        self.layoutIfNeeded()
    }
    
    @IBAction func disableEditSessionNameAction(){
        
        hideNamePriceEditInfoView()
        showNamePriceInfoView()
        self.layoutIfNeeded()
    }
    
    @IBAction func editDescriptionAction(){
        
        hideDescriptionInfoView()
        showEditDescriptionInfoView()
        self.layoutIfNeeded()
    }
    
    @IBAction func disableEditDescriptionAction(){
        
        showDescriptionInfoView()
        hideEditDescriptionInfoView()
        self.layoutIfNeeded()
    }
    
}

extension EditScheduledSessionRootView:UITextFieldDelegate,UITextViewDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = sessionNameField
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        scrollView?.activeField = descriptionTextView
        return true
    }
    
}

extension EditScheduledSessionRootView:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let  chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            uploadedImage?.contentMode = .scaleAspectFit
            uploadedImage?.image = chosenImage
            selectedImage = chosenImage
            delegate?.selectedImage(image:selectedImage)
            
            self.heightOfUploadImageConstraint?.priority = UILayoutPriority(999.0)
            self.heightOfuploadedImageConstraint?.priority = UILayoutPriority(250.0)
            
            self.controller?.dismiss(animated:true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.controller?.dismiss(animated: true, completion: {
        })
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
