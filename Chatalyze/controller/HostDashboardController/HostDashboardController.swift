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
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        roundSessionButton()
        testingLabel?.font = UIFont(name: "Poppins", size: 15)
        Log.echo(key: "yud", text: "is this dvelopement profile \(ProvisiningProfileStatus.isDevelopmentProvisioningProfile())")
        initializeName()
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
    
    @IBAction func scheduleSessionAction(sender:UIButton){
        
        DispatchQueue.main.async {
            
            guard let controller = ScheduleSessionController.instance() else{
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
      
        if HandlingAppVersion().getAlertMessage() != "" {
            
            showAlert(sender: sender)
            return
        }
        self.gotoSystemTest()
    }    
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
}
