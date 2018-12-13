//
//  InternetSpeedTestController.swift
//  Chatalyze
//
//  Created by Mansa on 07/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

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
        startSystemTest()
        
    }
    
    
    
    func appVersionAlert(){
        
    }
    
    func slowInternetConnectionAlert(){
        
    }
    
    func noInternetConnection(){
        
    }
    
    
    func startSystemTest(){
        
        initializeTest()
        showSystemTest()
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
            
            self.warningViewInternet?.isHidden = true
            self.warningViewVersion?.isHidden = false
        }
        else if warningType == .versionOutdatedWithInternetAverage{
            
            self.warningViewInternet?.isHidden = false
            self.warningViewVersion?.isHidden = false
        }
        else if warningType == .InternetAverage {
            
            self.warningViewInternet?.isHidden = false
            self.warningViewVersion?.isHidden = true
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
    
    
    
    //    func systemTest(){
    //
    //        if InternetConnection is not Good {
    //
    //            //Show Error
    //        }
    //
    //        if App version is out Date || Internet connectio is slow {
    //
    //            //Show Warning
    //            //CReate a method taking param type of warning
    //        }
    //
    //
    //
    //    }
    
    
    
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
        
        if HandlingAppVersion().getAlertMessage() != ""{
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
                //Return with the Error View of No InternetConnection
                
                Log.echo(key: "yud", text: "Yes I know internet is down")
            DispatchQueue.main.async {
                
                self.dismiss(animated: false, completion: {
                    
                    let alert = UIAlertController(title: "Chatalyze", message: "Your internet connection is down", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: { (action) in
                        
                    }))
                    
                    RootControllerManager().getCurrentController()?.present(alert, animated: false) {
                    }
                })
            }
            return
        }
        
        self.speedLbl?.text = "Checking your system. This will just take a moment."
        //self.showLoader()        
        CheckInternetSpeed().testDownloadSpeedWithTimeOut(timeOut: 10.0) { (speed, error) in
            
            DispatchQueue.main.async {
                //self.loaderImage?.isHidden = true
                self.stopLoader()
                if error == nil{
                    if speed != nil{
                        
                        let speedStr = String(format: "%.2f", speed ?? 0.0)
                        if (speed ?? 0.0) < 0.1875 {
                            
                            
                            self.errorType = .SlowInternetError
                            self.warningType = .none
                            self.showSlowInternetError()
                            return
                                
                                //showSlowInternetError()
                                //self.speedLbl?.textColor = UIColor.red
                            
                            //self.speedLbl?.text  =   "Fail"
                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                self.dismissAction()
//                            }
                            return
                        }
                            
                        else if (speed ?? 0.0) >= 0.1875 && (speed ?? 0.0) <= 0.25{
                            
                            self.errorType = .none
                            self.warningType = .InternetAverage
                            
                            if self.isVersionWarningExists(){
                                
                                self.warningType = .versionOutdatedWithInternetAverage
                                self.showWarning(warningType:self.warningType)
                                return
                            }
                            
                            self.showWarning(warningType:self.warningType)
                            return
                                
                                //showSlowInternetError()
                                //showWarning() of averageInternet

                                //self.speedLbl?.textColor = UIColor.red
                                //self.speedLbl?.text = "Fail"
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                self.dismissAction()
//                            }
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
                    }
                    
                }else{
                    
                    self.errorType = .SlowInternetError
                    self.warningType = .none
                    self.showSlowInternetError()
                    return
                    
//                    self.speedLbl?.text = "Fail"
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.dismissAction()
//                    }
//                    return
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

