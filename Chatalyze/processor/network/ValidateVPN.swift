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
        
        controller.alert(withTitle: "Warning", message: "Your device is connected to a VPN. This might cause chat connectivity issues. If possible, please disconnect from VPN.", successTitle: "OK", rejectTitle: "Cancel", showCancel: false) { (success) in
            didLoadWindow?()
        }
        
    }
    
    
    func isVPNConnected() -> Bool {
        let cfDict = CFNetworkCopySystemProxySettings()
        let nsDict = cfDict!.takeRetainedValue() as NSDictionary
        let keys = nsDict["__SCOPED__"] as! NSDictionary
        
        

        for key: String in keys.allKeys as! [String] {
            
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
