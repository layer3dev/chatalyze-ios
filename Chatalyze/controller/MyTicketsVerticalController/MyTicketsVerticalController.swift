//
//  MyTicketsVerticalController.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import Bugsnag

class MyTicketsVerticalController: MyTicketsController{
    
    var fontSize:CGFloat = 16.0
    @IBOutlet var underLineLbl:UILabel?
    @IBOutlet var showView:UIView?
    var isShow = false
    var eventDeleteListener = EventDeletedListener()
    var testingText = ""
    @IBOutlet var learnMoreLbl:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //        Bugsnag.notifyError(NSError(domain:"com.customCrash:MyTickets", code:408, userInfo:nil))
        
        initializeFontSize()
        underLineLable()
        getTheRequiredDate()
        initializeListenrs()
        underLineLearnMore()
        hitEventOnSegmentIO()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showNavigationBar()
    }
    
    func hitEventOnSegmentIO(){
        
        SEGAnalytics.shared().track("My Tickets Page")
    }
    
    @IBAction func showUserAnimation(){
        
        guard let controller = OnBoardFlowController.instance() else{
            return
        }
        controller.isComingFromDashboard = true
        self.navigationController?.present(controller, animated: true, completion: {
        })
    }
    
    
    @IBAction func animateInfo(){
        
        if isShow{
            
            isShow = false
            UIView.animate(withDuration: 0.35) {
                
                self.showView?.alpha = 0
                self.view.layoutIfNeeded()
            }
            return
        }
        isShow = true
        UIView.animate(withDuration: 0.35) {
            
            self.showView?.alpha = 1
            self.view.layoutIfNeeded()
        }
        return
    }
    
    
    @IBAction func  disableInfoAction(){
     
        isShow = false
        UIView.animate(withDuration: 0.35) {
            self.showView?.alpha = 0
            self.view.layoutIfNeeded()
        }
        return
    }
    
    func getTheRequiredDate(){
    
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "E, d MMM yyyy "
    }
    
    func initializeFontSize(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 22.0
        }else{
            fontSize = 16.0
        }
    }
    
    func underLineLable(){
        
        var testingText = "TEST MY PHONE"
        self.testingText = testingText
        if UIDevice.current.userInterfaceIdiom == .pad{
            testingText = "TEST MY IPAD"
            self.testingText = testingText
        }
        
        if let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont(name: "Nunito-Regular", size: fontSize)] as? [NSAttributedString.Key : Any]{
            
            let underlineAttributedString = NSAttributedString(string: testingText, attributes: underlineAttribute as [NSAttributedString.Key : Any])
            
            underLineLbl?.attributedText = underlineAttributedString
        }
    }

    func underLineLearnMore(){
        
        let testingText = "HOW IT WORKS"
        var fontSize:CGFloat = 16
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 20
        }
        
        if let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont(name: "open sans", size: fontSize)] as? [NSAttributedString.Key : Any]{
            
            let underlineAttributedString = NSAttributedString(string: testingText, attributes: underlineAttribute as [NSAttributedString.Key : Any])
            
            learnMoreLbl?.attributedText = underlineAttributedString
        }
    }
    
    func showAlert(sender:UIButton){
        
        let alertMessage = HandlingAppVersion().getAlertMessage()
        
        let alertActionSheet = UIAlertController(title: AppInfoConfig.appName, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        
        let uploadAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.default) { (success) in
          
            HandlingAppVersion.goToAppStoreForUpdate()
        }
        
        let callRoomAction = UIAlertAction(title: self.testingText, style: UIAlertAction.Style.destructive) { (success) in
            
             self.goToSystemTest()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (success) in
        }
        
        alertActionSheet.addAction(cancel)
        alertActionSheet.addAction(uploadAction)
        alertActionSheet.addAction(callRoomAction)
        
        //alertActionSheet.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        if let presenter = alertActionSheet.popoverPresentationController {
            
            alertActionSheet.popoverPresentationController?.sourceView =                 self.view
            alertActionSheet.popoverPresentationController?.sourceRect = sender.frame
        }
        self.present(alertActionSheet, animated: true) {
        }
    }
    
    
    func goToSystemTest(){
        
        guard let controller = InternetSpeedTestController.instance() else{
            return
        }
        
        controller.onlySystemTest = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
        })
    }
    
    
    @IBAction func systemTest(sender:UIButton){
      
//        if HandlingAppVersion().getAlertMessage() != "" {
//            
//            showAlert(sender: sender)
//            return
//        }
        
        self.goToSystemTest()
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override class func instance()->MyTicketsVerticalController?{
        
        let storyboard = UIStoryboard(name: "UserTicketUI", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyTicketsVertical") as? MyTicketsVerticalController
        return controller
    }
}


extension MyTicketsVerticalController{
    
    func initializeListenrs(){
      
        UserSocket.sharedInstance?.socket?.on("DeletedChatalyzeEvent", callback: { (data, emit) in
            
            self.fetchInfoForListenr()
            return
        })
        
        eventDeleteListener.setListener { (deletedEventID) in
         
            self.fetchInfoForListenr()
            return
                
            
            for events in self.ticketsArray{
                
                Log.echo(key: "yud", text: "Matched Event Id is \(events.callschedule?.id ?? 0) and coming from server is \(String(describing: Int(deletedEventID ?? "0")))")
                
                if events.callschedule?.id ?? 0 == Int(deletedEventID ?? "0"){
                    
                    //  fetchInfo()
                    //self.exitAction()
                    Log.echo(key: "yud", text: "Yes I got matched \(String(describing: deletedEventID))")
                }
            }
        }
    }
}
