//
//  InternetSpeedTestController.swift
//  Chatalyze
//
//  Created by Mansa on 07/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Analytics

class InternetSpeedTestController: InterfaceExtendedController {
    
    @IBOutlet var speedLbl:UILabel?
    var rootController:EventController?
    @IBOutlet var loaderImage:UIView?
    var onSuccessTest:((Bool)->())?
    var dismissListner:((Bool)->())?
    var info:EventInfo?
    var isOnlySystemTestForTicket = false
    var onlySystemTest = false
    
    @IBOutlet var systemTestView:UIView?
    @IBOutlet var warningView:UIView?
    @IBOutlet var errorView:UIView?
    @IBOutlet var noInternetConnectionView:UIView?
    
    @IBOutlet var warningViewInternet:UIView?
    @IBOutlet var warningViewVersion:UIView?
    
    
    @IBOutlet var heightWarningViewInternetConstraint:NSLayoutConstraint?
    @IBOutlet var heightwarningViewVersionConstraint:NSLayoutConstraint?

    
    enum errorStatus:Int{
        
        case NoInternetConnectionError = 0
        case SlowInternetError = 1
        case none = 2
    }
    
    enum warningStatus:Int {
        
        case versionOutdated = 0
        case InternetAverage = 1
        case versionOutdatedWithInternetAverage = 2
        case none = 4
    }
    
    var errorType = InternetSpeedTestController.errorStatus.none
    var warningType = InternetSpeedTestController.warningStatus.none
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //self.speedLbl?.text = "Checking your system. This will just take a moment."
        //rotateImage(breakMethod:true)
        
        
        SEGAnalytics.shared().track("System Test")
        startSystemTest()
    }
    
    func appVersionAlert(){
        
        self.alert(withTitle: AppInfoConfig.appName, message: "Your app version is outdated, To avoid potential issues, please update to the latest version", successTitle: "Ok" ,rejectTitle: "Cancel", showCancel: false) { (success) in
        }
    }
    
    func slowInternetConnectionAlert(){
     
        self.alert(withTitle: AppInfoConfig.appName, message: "You internet connection seem to be slow. Please update your internet and then try testing again.", successTitle: "Ok" ,rejectTitle: "Cancel", showCancel: false) { (success) in
        }
    }
    
    func averageInternetConnectionAlert(){
        
        self.alert(withTitle: AppInfoConfig.appName, message: "You internet connection seem to be average. You can update your internet or continue for the system test", successTitle: "Ok" ,rejectTitle: "Cancel", showCancel: false) { (success) in
        }
    }
    
    func noInternetConnectionAlert(){
       
        self.alert(withTitle: AppInfoConfig.appName, message: "You seem to be offline. Please connect to the internet and then try testing again.", successTitle: "Ok" ,rejectTitle: "Cancel", showCancel: false) { (success) in
        }
    }
    
        
    func startSystemTest(){
        
        showSystemTest()
        initializeTest()
    }
    
    @IBAction func continueToCameraTest(){
        
        self.cameraTest(sender: nil)
    }
    
    @IBAction func retryTest(){
        
        startSystemTest()
    }
        
    func showSystemTest(){
        
        self.systemTestView?.isHidden = false
        self.warningView?.isHidden = true
        self.errorView?.isHidden = true
        self.noInternetConnectionView?.isHidden = true
    }
    
    func showSlowInternetError(){
        
        self.systemTestView?.isHidden = true
        self.warningView?.isHidden = true
        self.errorView?.isHidden = false
        self.noInternetConnectionView?.isHidden = true
    }
    
    func showWarning(warningType:warningStatus){
        
        if warningType == .versionOutdated{
         
            self.heightWarningViewInternetConstraint?.priority = UILayoutPriority(999.0)
            self.heightwarningViewVersionConstraint?.priority = UILayoutPriority(250.0)
            self.view.layoutIfNeeded()

//            self.warningViewInternet?.isHidden = true
//            self.warningViewVersion?.isHidden = false
        }
        else if warningType == .versionOutdatedWithInternetAverage{
       
            self.heightWarningViewInternetConstraint?.priority = UILayoutPriority(250.0)
            self.heightwarningViewVersionConstraint?.priority = UILayoutPriority(250.0)
            self.view.layoutIfNeeded()

//            self.warningViewInternet?.isHidden = false
//            self.warningViewVersion?.isHidden = false
        }
        else if warningType == .InternetAverage {
      
            self.heightWarningViewInternetConstraint?.priority = UILayoutPriority(250.0)
            self.heightwarningViewVersionConstraint?.priority = UILayoutPriority(999.0)
            self.view.layoutIfNeeded()
//            self.warningViewInternet?.isHidden = false
//            self.warningViewVersion?.isHidden = true
        }
        self.systemTestView?.isHidden = true
        self.warningView?.isHidden = false
        self.errorView?.isHidden = true
        self.noInternetConnectionView?.isHidden = true
    }
    
    func shownoInternetConnection(){
        
        self.systemTestView?.isHidden = true
        self.warningView?.isHidden = true
        self.errorView?.isHidden = true
        self.noInternetConnectionView?.isHidden = false
    }
    
    @IBAction func poorInternetInfoAction(){
        
        self.slowInternetConnectionAlert()
    }
    
    @IBAction func averageInternetInfoAction(){
     
        slowInternetConnectionAlert()
    }
    
    @IBAction func noInternetConnectionAction(){
      
        noInternetConnectionAlert()
    }
    
    @IBAction func versionInfoAction(){
        
        self.appVersionAlert()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        self.rotateImage(sender: nil)
    }
    
    @IBAction func cameraTest(sender:UIButton?){
        
        self.dismiss(animated: false) {
            
            guard let controller = CameraTestController.instance() else {
                return
            }
            controller.info = self.info
            controller.rootController = self
            controller.onSuccessTest = self.onSuccessTest
            controller.isOnlySystemTestForTicket = self.isOnlySystemTestForTicket
            controller.onlySystemTest = self.onlySystemTest
            controller.dismissListner = {
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: {
                        if let listner = self.dismissListner{
                            listner(false)
                        }
                    })
                }
            }
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            RootControllerManager().getCurrentController()?.present(controller, animated: false){
            }
        }       
    }
    
    @IBAction func rotateImage(sender:UIButton?){
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { () -> Void in
            
            self.loaderImage?.transform = (self.loaderImage?.transform.rotated(by: CGFloat(Double.pi/4)))!
            
        }) { (finished) -> Void in
            
            self.rotateImage(sender: nil)
        }
    }
    
    
    func initializeTest(){
        
        self.errorType = .none
        self.warningType = .versionOutdated
        self.testInternet()
    }
    
    func isVersionWarningExists()->Bool{
        
        if HandlingAppVersion().getAlertMessage() == "This version of our app will soon no longer work. Please update to the latest version now to avoid any issues."{
            return true
            self.speedLbl?.textColor = UIColor.red
            self.speedLbl?.text = HandlingAppVersion().getAlertMessage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                
                self.speedLbl?.textColor = UIColor(hexString: AppThemeConfig.themeColor)
                self.speedLbl?.text = ""
                self.testInternet()
            }
        }
        return false
    }
    
    
    func testInternet(){
        
        if !(InternetReachabilityCheck().isInternetAvailable()){
            
            self.errorType = .NoInternetConnectionError
            self.warningType = .none
            self.shownoInternetConnection()
            return
        }
        
        self.speedLbl?.text = "Checking your system. This will just take a moment."
        //self.showLoader()        
        CheckInternetSpeed().testDownloadSpeedWithTimeOut(timeOut: 10.0) { (speed, error) in
            
            DispatchQueue.main.async {
                
                self.stopLoader()
                if error == nil{
                   
                    let speedMb = (speed ?? 0.0) * 8
                    Log.echo(key: "speedLogTest", text: "Speed in the Mbps is \(speedMb)")
                    
                    
                        if (speedMb) < 1.5 {
                        
                            self.errorType = .none
                            self.warningType = .InternetAverage
                            
                            if self.isVersionWarningExists(){
                                
                                self.warningType = .versionOutdatedWithInternetAverage
                            }
                            
                            self.showWarning(warningType:self.warningType)
                            return
                        }

                        if self.isVersionWarningExists(){
                            
                            self.errorType = .none
                            self.warningType = .versionOutdated
                            self.showWarning(warningType:self.warningType)
                            return
                        }
                        
                        //Check for outdated warning Too.
                    
                        self.speedLbl?.text = "Success"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.cameraTest(sender: nil)
                        }
                        return
                }else{
                    
                    //Error Support in the Internet Test
                    
                    self.errorType = .SlowInternetError
                    self.warningType = .none
                    self.showSlowInternetError()
                    return
                }
            }
        }
    }
    
    
    @IBAction func dismissAction(){
        
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
                if let listner = self.dismissListner{
                    listner(false)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension InternetSpeedTestController{
    
    class func instance()->InternetSpeedTestController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InternetSpeedTest") as? InternetSpeedTestController
        return controller
    }
}

