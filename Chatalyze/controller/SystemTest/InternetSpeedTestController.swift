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

    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //self.speedLbl?.text = "Checking your system. This will just take a moment."
        //rotateImage(breakMethod:true)
        testInternet()
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
    
    func testInternet(){
        
        if !(InternetReachabilityCheck().isInternetAvailable()){
            
            let alert = UIAlertController(title: "Chatalyze", message: "Your internet connection is down", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: { (action) in
                
                self.rootController?.dismiss(animated: false, completion: {
                })
            }))
            RootControllerManager().getCurrentController()?.present(alert, animated: false) {
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
                        if (speed ?? 0.0) < 0.03125 {
                            
                            
                            self.speedLbl?.textColor = UIColor.red
                            self.speedLbl?.text = "Success"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.dismissAction()
                            }
                            return
                        }
                        
                        self.speedLbl?.text = "Success"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.cameraTest(sender: nil)
                        }
                        return
                    }
                }else{
                    
                    self.speedLbl?.text = "Fail"
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

