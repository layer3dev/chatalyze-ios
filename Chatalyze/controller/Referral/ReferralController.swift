//
//  ReferralController.swift
//  Chatalyze
//
//  Created by mansa infotech on 23/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class ReferralController: InterfaceExtendedController {
    
    
    
    
    @IBOutlet var dataView:UIView?
    @IBOutlet var linkView:UIView?
    @IBOutlet var copyView:UIView?
    
    @IBOutlet var sharingLbl:UILabel?
    @IBOutlet var importantTextLabel:UILabel?
    
    @IBOutlet var backToMyProfile:UIButton?
    @IBOutlet var inviteButtonView:UIView?
    
    @IBOutlet var inviteEmailView:UIView?
    
    @IBOutlet var emailAddress:UITextField?
    @IBOutlet var errorLabel:UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        paintInterface()
        
        linkView?.layer.borderWidth = 1
        linkView?.layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1).cgColor
        
        inviteEmailView?.layer.borderWidth = 1
        inviteEmailView?.layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1).cgColor
        
        copyView?.layer.borderWidth = 1
        copyView?.layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1).cgColor
        
        dataView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 7:5
        
        self.paintText()
      
        self.setSharableUrlText()
        
        backToMyProfile?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 32.5:22.5
        
        backToMyProfile?.layer.borderWidth = 1
        backToMyProfile?.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1).cgColor
        
        backToMyProfile?.layer.masksToBounds = true
        
        roundViewToInviteButton()
    }
    
    func validateEmail()->Bool{
        
        if emailAddress?.text == ""{
            
            errorLabel?.text = "Please fill email address to refer link on your referrer's email address."
            return false
        }
        
        if !(FieldValidator().validateEmailFormat(emailAddress?.text ?? "")){
            
            errorLabel?.text = "Please fill correct email address."
            return false
        }
        
        errorLabel?.text = ""
        return true
    }
    
    
    @IBAction func sendInvites(sender:UIButton){
        
        if !validateEmail(){
            return
        }
        let text:[String] = ["\(emailAddress?.text ?? "")"]
        
        self.showLoader()
       
        SendRefrerrelInvitation().send(param: ["members":text]) { (success,response) in
            
            self.stopLoader()
            
            let resp = response?.dictionary
            let message = resp?["message"]?.stringValue
            
            Log.echo(key: "yud", text: "success is \(success)")
            
            if  message == ""{
                
                self.errorLabel?.text = message
                return
            }
            self.alert(withTitle: AppInfoConfig.appName, message: "Invitaion sent successfully at the email address.", successTitle: "OK", rejectTitle: "", showCancel: false , completion: { (success) in
                
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
    
    
    func roundViewToInviteButton(){
        
        inviteButtonView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 30:22.5
        inviteButtonView?.layer.masksToBounds = true
    }
    
    @IBAction func menuAction(){
        
        RootControllerManager().getCurrentController()?.toggleAnimation()
    }
    
    @IBAction func backToPreviousController(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dataView?.dropShadow(color: UIColor.lightGray, opacity: 0.5, offSet: CGSize.zero, radius: UIDevice.current.userInterfaceIdiom == .pad ? 8:5, scale: true , layerCornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 7:5)
    }
    
    func paintInterface(){
        
        paintHideBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        showNavigationBar()
    }
    
    @IBAction func backToMySession(sender:UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setSharableUrlText() {
        
        self.showLoader()
        FetchReferralUrl().fetch() { (success, response) in
          
            self.stopLoader()

            Log.echo(key: "yud", text: "Repo is \(response)")
            
            if success{
                self.sharingLbl?.text = response ?? ""
                return
            }
            self.sharingLbl?.text = ""
        }
        
//        var str = AppConnectionConfig.basicUrl
//        str = str + "/profile/"
//        str = str + (SignedUserInfo.sharedInstance?.firstName ?? "")
//        str = str + "/"
//        str = str + "\(SignedUserInfo.sharedInstance?.id ?? "0")"
//        //self.sharingLbl?.text = str
//        str  = str.replacingOccurrences(of: " ", with: "")
    }
    
    func paintText(){
        
        DispatchQueue.main.async {
            
            // Invite a friend and get 5% of their earning for a year. Terms apply
            let textOne = "Invite a friend and get 5% of their earning for a year. "
            let textOneMutable = textOne.toMutableAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 19:15, color: UIColor.white, isUnderLine: false)
            
            let textTwo = "Terms apply "
            let texttwoAttr = textTwo.toAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 19:15, color: UIColor.white, isUnderLine: true)
            
            textOneMutable.append(texttwoAttr)
            self.importantTextLabel?.attributedText = textOneMutable
        }
    }
    
    
    @IBAction func copyText(send:UIButton){
        
        //str  = str.replacingOccurrences(of: " ", with: "")
        guard var str = sharingLbl?.text else {
            return
        }
        
        str  = str.replacingOccurrences(of: " ", with: "")
        
        if let url = URL(string: str){
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                let shareText = "Chatalyze"
                let shareItems: [Any] = [url]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = send.frame
                self.present(activityVC, animated: false, completion: nil)
                
            }else {
                
                let shareText = "Chatalyze"
                let shareItems: [Any] = [url]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                self.present(activityVC, animated: false, completion: nil)
            }
        }
        return
    }
    
    
    @IBAction func copyTextOnClipboard(sender:UIButton){
        
        var str = AppConnectionConfig.basicUrl
        str = str + "/profile/"
        str = str + (SignedUserInfo.sharedInstance?.firstName ?? "")
        str = str + "/"
        str = str + "\(SignedUserInfo.sharedInstance?.id ?? "0")"
        //str  = str.replacingOccurrences(of: " ", with: "")
        Log.echo(key: "yud", text: "url id is \(str)")
        str  = str.replacingOccurrences(of: " ", with: "")
        UIPasteboard.general.string = str
        self.alert(withTitle:AppInfoConfig.appName, message: "Text copied to clipboard.", successTitle: "OK", rejectTitle: "cancel", showCancel: false) { (success) in
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    class func instance()->ReferralController?{
        
        let storyboard = UIStoryboard(name: "Referral", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Referral") as? ReferralController
        return controller
    }
    
}
