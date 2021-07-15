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
        
        controller.alert(withTitle: "Warning", message: "We detect you are on a virtual private network (VPN), which puts you at high risk of having connectivity issues on Chatalyze. Please disconnect from your VPN before participating in any chats.".localized() ?? "", successTitle: "Ok".localized() ?? "", rejectTitle: "Cancel".localized() ?? "", showCancel: false) { (success) in
            didLoadWindow?()
        }
        
    }
    
    
    func isVPNConnected() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings()
            else{
                return false
        }
        
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        Log.echo(key: TAG, text: "nsDict -> \(nsDict)")
       
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
            let key = key.lowercased()
            
            
            if (key.contains("tap")  || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") || key.contains("utun")) {
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
