//
//  ValidateDevice.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 10/06/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation

class ValidateDevice {
    
    private let TAG = "ValidateDevice"
    
    func showDeviceSupportWarningAlert(didLoadWindow : (()->())?){
        
        Log.echo(key: TAG, text: "Validate Device")
    
        if #available(iOS 13.0, *){
            Log.echo(key: TAG, text: "iOS 13 it is")
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
        
        controller.alert(withTitle: "Warning", message: "Your iOS version is out of date. This might cause chat connectivity issues. If possible, please upgrade to iOS 13 or higher. If you choose not to upgrade and have trouble connecting to a chat, try hanging up and re-joining.".localized() ?? "", successTitle: "OK".localized() ?? "", rejectTitle: "Cancel".localized() ?? "", showCancel: false) { (success) in
            didLoadWindow?()
        }
        
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
