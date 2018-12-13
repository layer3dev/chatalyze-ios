//
//  MyTicketsVerticalController.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MyTicketsVerticalController: MyTicketsController{
    
    var fontSize:CGFloat = 16.0
    @IBOutlet var underLineLbl:UILabel?
    @IBOutlet var showView:UIView?
    var isShow = false
    
    //Implementing the eventDeleteListener
    var eventDeleteListener = EventDeletedListener()  
    var testingText = ""
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeFontSize()
        underLineLable()
        getTheRequiredDate()
        initializeListenrs()
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
        
//        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
//        print("Required date is \(dateFormatter.date(from: "Thu, 25 Oct 2018 11:20:15 GMT"))")
        
        let date = Date()
        
        //dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //let str = dateFormatter.string(from: date)
        //print("String date is \(dateFormatter.string(from: date))")
        
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "E, d MMM yyyy "
        
        print("Extented date is \(dateFormatter.string(from: date))")
        print("Date from str is  \(dateFormatter.date(from: "Thu, 25 Oct 2018 11:20:15 GMT"))")
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
        
        if let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont(name: "Questrial", size: fontSize)] as? [NSAttributedString.Key : Any]{
            
            let underlineAttributedString = NSAttributedString(string: testingText, attributes: underlineAttribute as [NSAttributedString.Key : Any])
            
            underLineLbl?.attributedText = underlineAttributedString
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
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyTicketsVertical") as? MyTicketsVerticalController
        return controller
    }
}


extension MyTicketsVerticalController{
    
    func initializeListenrs(){
        
        UserSocket.sharedInstance?.socket?.on("DeletedChatalyzeEvent", callback: { (data, emit) in
            
            self.fetchInfoForListenr()
            return
                Log.echo(key: "yud", text: "Got the deleted event having the deletedEventID")
        })
        
        eventDeleteListener.setListener { (deletedEventID) in
         
            self.fetchInfoForListenr()
            return
                
                Log.echo(key: "yud", text: "Got the deleted event having the deletedEventID is\(deletedEventID)")
            
            for events in self.ticketsArray{
                
                Log.echo(key: "yud", text: "Matched Event Id is \(events.callschedule?.id ?? 0) and coming from server is \(Int(deletedEventID ?? "0"))")
                
                if events.callschedule?.id ?? 0 == Int(deletedEventID ?? "0"){
                    
                    //  fetchInfo()
                    //self.exitAction()
                    Log.echo(key: "yud", text: "Yes I got matched \(deletedEventID)")
                }
            }
        }
    }
    
    
}
