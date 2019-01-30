//
//  HostDashboardController.swift
//  Chatalyze
//
//  Created by Mansa on 24/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostDashboardController: MyScheduledSessionsController {
    
    @IBOutlet var testingLabel:UILabel?
    @IBOutlet var tableHeight:NSLayoutConstraint?
    @IBOutlet var scheduleSessionBtnContainer:UIView?
    var testingText = ""
    @IBOutlet var sharingLbl:UILabel?
    var sharedLinkListener:((EventInfo)->())?
    @IBOutlet var importantView:UIView?
    @IBOutlet var heightOfShareViewHeightConstraint:NSLayoutConstraint?    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialize()
        paint()
        checkForShowingHostWelcomeAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()
        rootView?.paintNewUI()
    }
    
    func checkForShowingHostWelcomeAnimation(){
        
        //This method is responsible to showing the new signUp animation for only Hosts.
        
        guard let isRequired = UserDefaults.standard.value(forKey: "isHostWelcomeScreenNeedToShow") as? Bool else {
            return
        }
        
        if !isRequired{
            return
        }
        
        guard let controller = HostWelcomeAnimationController.instance() else {
            return
        }
        
        self.present(controller, animated: true, completion: {
        })
    }    
    
    override func showShareView(){
       
       // heightOfShareViewHeightConstraint?.priority = UILayoutPriority(rawValue: 250)
    }
    
    override func hideShareView(){
        
        //heightOfShareViewHeightConstraint?.priority = UILayoutPriority(rawValue: 999)
    }
    
    func paint(){
        
        importantView?.layer.cornerRadius = 2
        importantView?.layer.masksToBounds = true
        
        noSessionView?.layer.borderWidth = 1
        noSessionView?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
        noSessionView?.layer.masksToBounds = true
                
        setSharableUrlText()
    }
    
    func setSharableUrlText(){
        
        //https://dev.chatalyze.com/profile/NekBanda/485
        var str = AppConnectionConfig.systemTestUrl
        str = str + "/profile/"
        str = str + (SignedUserInfo.sharedInstance?.firstName ?? "")
        str = str + "/"
        str = str + "\(SignedUserInfo.sharedInstance?.id ?? "0")"
        self.sharingLbl?.text = str
        //str  = str.replacingOccurrences(of: " ", with: "")
        Log.echo(key: "yud", text: "url id is \(str)")
        str  = str.replacingOccurrences(of: " ", with: "")
    }
    
    
    func initialize(){
      
        //sharingTextFld?.delegate = self
        roundSessionButton()
        testingLabel?.font = UIFont(name: "Poppins", size: 15)
        Log.echo(key: "yud", text: "is this dvelopement profile \(ProvisiningProfileStatus.isDevelopmentProvisioningProfile())")
        initializeName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.rootView?.adapter.sharedLinkListener = {(info) in
        }
    }
    
    func initializeName(){
        
        var testingText = "TEST MY PHONE"
        self.testingText = testingText
        if UIDevice.current.userInterfaceIdiom == .pad{
            testingText = "TEST MY IPAD"
            self.testingText = testingText
        }
    }
    
    func roundSessionButton(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
           
            scheduleSessionBtnContainer?.layer.cornerRadius = 5
            scheduleSessionBtnContainer?.layer.masksToBounds = true
            return
        }
        
        scheduleSessionBtnContainer?.layer.cornerRadius = 3
        scheduleSessionBtnContainer?.layer.masksToBounds = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(sender:UIButton){
        
        let alertMessage = HandlingAppVersion().getAlertMessage()
        
        let alertActionSheet = UIAlertController(title: AppInfoConfig.appName, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        
        let uploadAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.default) { (success) in
         
            HandlingAppVersion.goToAppStoreForUpdate()
        }
        
        let callRoomAction = UIAlertAction(title: self.testingText, style: UIAlertAction.Style.destructive) { (success) in
          
            self.gotoSystemTest()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (success) in
        }
        
        alertActionSheet.addAction(cancel)
        alertActionSheet.addAction(uploadAction)
        alertActionSheet.addAction(callRoomAction)
        
        //alertActionSheet.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        if let presenter = alertActionSheet.popoverPresentationController {            
            alertActionSheet.popoverPresentationController?.sourceView = self.view
            alertActionSheet.popoverPresentationController?.sourceRect = sender.frame
        }
        
        self.present(alertActionSheet, animated: true) {
        }
    }
    
    @IBAction func copyTextOnClipboard(sender:UIButton){
        
        var str = AppConnectionConfig.systemTestUrl
        str = str + "/profile/"
        str = str + (SignedUserInfo.sharedInstance?.firstName ?? "")
        str = str + "/"
        str = str + "\(SignedUserInfo.sharedInstance?.id ?? "0")"
        //str  = str.replacingOccurrences(of: " ", with: "")
        Log.echo(key: "yud", text: "url id is \(str)")
        str  = str.replacingOccurrences(of: " ", with: "")
        UIPasteboard.general.string = str
        self.alert(withTitle:AppInfoConfig.appName, message: "Text copied on the clipboard", successTitle: "OK", rejectTitle: "cancel", showCancel: false) { (success) in
        }        
    }
    
    
    @IBAction func scheduleSessionAction(sender:UIButton){
        
        Log.echo(key: "yud", text: "I am calling")
        
        DispatchQueue.main.async {
            
//            guard let controller = ScheduleSessionController.instance() else{
//                return
//            }
            guard let controller = SessionScheduleNewController.instance() else{
                return
            }
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    func gotoSystemTest(){
        
        guard let controller = InternetSpeedTestController.instance() else{
            return
        }
        controller.onlySystemTest = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
        })
    }
    
    @IBAction func systemTestAction(sender:UIButton){
      
        self.gotoSystemTest()
    }
    
    @IBAction func settingAction(sender:UIButton){
        
        RootControllerManager().getCurrentController()?.showProfileScreen()
    }
    
    @IBAction func copyText(send:UIButton){
        
        //str  = str.replacingOccurrences(of: " ", with: "")
        guard var str = sharingLbl?.text else{
            return
        }
        
        str  = str.replacingOccurrences(of: " ", with: "")
        
        Log.echo(key: "yud", text: "url id is \(str)")
        if let url = URL(string: str){
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                
                let shareText = "Chatalyze"
                let shareItems: [Any] = [url]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = send.frame
                self.present(activityVC, animated: false, completion: nil)
                
            }else{
                
                let shareText = "Chatalyze"
                let shareItems: [Any] = [url]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                self.present(activityVC, animated: false, completion: nil)
            }
        }
        return
    }
    
    override func updateScrollViewWithTable(height:CGFloat){
        
        Log.echo(key: "yud", text: "The height of the table is \(height)")
        tableHeight?.constant = height
        self.updateViewConstraints()
        self.view.layoutIfNeeded()
    }
   
    override class func instance()->HostDashboardController?{
        
        let storyboard = UIStoryboard(name: "HostDashBoard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HostDashboard") as? HostDashboardController
        return controller
    }
    
    @IBAction func menuAction(sender:UIButton){
        
        self.toggle()
    }
}
