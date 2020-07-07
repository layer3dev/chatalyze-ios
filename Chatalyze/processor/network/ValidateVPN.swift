//
//  ValidateVPN.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 26/06/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation

class ValidateVPN {
    
    private let TAG = "ValidateVPN"
    
    func showVPNWarningAlert(didLoadWindow : (()->())?){
        
        Log.echo(key: TAG, text: "ValidateVPN")
    
        if !isVPNConnected(){
            Log.echo(key: TAG, text: "VPN Not Connected")
            didLoadWindow?()
            return
        }
        guard let controller = getRootController()
            else{
                Log.echo(key: TAG, text: "NO ROOT :(")
                didLoadWindow?()
                return
        }
        
        Log.echo(key: TAG, text: "SHOWING ALERT :(")
        
        controller.alert(withTitle: "Warning", message: "We detect you are on a virtual private network (VPN), which puts you at high risk of having connectivity issues on Chatalyze. Please disconnect from your VPN before participating in any chats.", successTitle: "OK", rejectTitle: "Cancel", showCancel: false) { (success) in
            didLoadWindow?()
        }
        
    }
    
    
    func isVPNConnected() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings()
            else{
                return false
        }
        
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
       
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary
            else{
                return false
        }
        
        guard let keyList = keys.allKeys as? [String]
            else{
                return false
        }
        

        for key: String in keyList {
            
            Log.echo(key: TAG, text: "key -> \(key)")
            
            if (key == "tap" || key == "tun" || key == "ppp" || key == "ipsec" || key == "ipsec0" || key == "utun0" || key == "utun1") {
                return true
            }
        }
        return false
    }
    
    private func getRootController()->UIViewController?{
        
        guard let appDelegate = UIApplication.shared.delegate as?AppDelegate
            else{
                return nil
        }
        let window = appDelegate.window
        let rootController = window?.rootViewController
        return rootController
    }
}
