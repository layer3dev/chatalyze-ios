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
        
        guard let controller = CameraTestController.instance() else {
            return
        }
        controller.rootController = self
        controller.onSuccessTest = self.onSuccessTest
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(controller, animated: true) {
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
            
            let alert = UIAlertController(title: "Chatalyze", message: "Your internet connection is down", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
                
                self.rootController?.dismiss(animated: true, completion: {
                })
            }))
            self.present(alert, animated: true) {
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
                            
                            self.speedLbl?.text = "Your internet connection speed is not good \(speedStr) MBPS"
                            
                            return
                        }
                        
                        self.speedLbl?.text = "Your internet connection speed is good \(speedStr) MBPS"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.cameraTest(sender: nil)
                        }
                        return
                    }
                }else{
                    
                    self.speedLbl?.text = "some error occured plz try again"
                }
            }
        }
    }
    
    @IBAction func dismissAction(){
        
        self.rootController?.dismiss(animated: true, completion: {
        })
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

