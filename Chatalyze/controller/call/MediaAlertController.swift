//
//  MediaAlertController.swift
//  Chatalyze
//
//  Created by Mansa on 17/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MediaAlertController: InterfaceExtendedController {
    
    var alert:VideoCallController.permissionsCheck  = .none

    @IBOutlet var alertLbl:UILabel?
    @IBOutlet var noInternetConnectionView:UIView?
    @IBOutlet var noCameraAccessView:UIView?
    @IBOutlet var noMicAccessView:UIView?
    @IBOutlet var slowInternetView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        hideAllAlert()
        showalert()        
        // Do any additional setup after loading the view.
    }
    
    func hideAllAlert(){
        
        self.noInternetConnectionView?.isHidden = true
        self.noCameraAccessView?.isHidden = true
        self.noMicAccessView?.isHidden = true
        self.slowInternetView?.isHidden = true
    }
    
    
    func showalert(){
        
        if alert == .none{
           
            hideAllAlert()
            return
        }
            
        else if alert == .cameraPermission{
            
            self.noInternetConnectionView?.isHidden = true
            self.noCameraAccessView?.isHidden = false
            self.noMicAccessView?.isHidden = true
            self.slowInternetView?.isHidden = true
        }
            
        else if alert == .micPermission{
            
            self.noInternetConnectionView?.isHidden = true
            self.noCameraAccessView?.isHidden = true
            self.noMicAccessView?.isHidden = false
            self.slowInternetView?.isHidden = true
        }
       
        else if alert == .slowInternet{
            
            self.noInternetConnectionView?.isHidden = true
            self.noCameraAccessView?.isHidden = true
            self.noMicAccessView?.isHidden = true
            self.slowInternetView?.isHidden = false
        }
            
        else if alert == .noInternet{
            
            self.noInternetConnectionView?.isHidden = false
            self.noCameraAccessView?.isHidden = true
            self.noMicAccessView?.isHidden = true
            self.slowInternetView?.isHidden = true
        }
    }
    
    @IBAction func exit(sender:UIButton){
        
        self.dismiss(animated: true, completion: {
        })
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    class func instance()->MediaAlertController?{
        
        let storyboard = UIStoryboard(name: "call_view", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MediaAlert") as? MediaAlertController
        return controller
    }
    
}
