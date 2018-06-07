//
//  InternetSpeedTestController.swift
//  Chatalyze
//
//  Created by Mansa on 07/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class InternetSpeedTestController: InterfaceExtendedController {

    @IBOutlet var speedLbl:UILabel?
    var rootController:SystemTestController?
    
    override func viewDidLayout() {
        super.viewDidLayout()
       
        testInternet()
    }
    
    @IBAction func cameraTest(sender:UIButton){
        
        guard let controller = CameraTestController.instance() else {
            return
        }
        controller.rootController = self.rootController
        self.present(controller, animated: true) {
            
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
        
        self.speedLbl?.text = "Waiting for Internet test"
        self.showLoader()
        CheckInternetSpeed().testDownloadSpeedWithTimeOut(timeOut: 10.0) { (speed, error) in
            
            DispatchQueue.main.async {
                self.stopLoader()
                if error == nil{
                    if speed != nil{
                        let speedStr = String(format: "%.2f", speed ?? 0.0)
                        if (speed ?? 0.0) < 2.0 {
                            self.speedLbl?.text = "Your internet connection speed is not good \(speedStr) MBPS"
                            return
                        }
                        self.speedLbl?.text = "Your internet connection speed is  good \(speedStr) MBPS"
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

