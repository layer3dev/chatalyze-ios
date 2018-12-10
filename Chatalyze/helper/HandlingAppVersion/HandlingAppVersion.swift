//
//  HandlingAppVersion.swift
//  Chatalyze
//
//  Created by Mansa on 10/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class HandlingAppVersion:NSObject {
    
    var latestVersion:Double = 0.0
    var deprecatedVersion:Double = 0.0
    var ObsoleteVersion:Double = 0.0
    init(latestVersion:Double?,deprecatedVersion:Double?,ObsoleteVersion:Double?){
        super.init()
        
        self.latestVersion = latestVersion ?? 0.0
        self.deprecatedVersion = deprecatedVersion ?? 0.0
        self.ObsoleteVersion = ObsoleteVersion ?? 0.0
        checkingForAlert()
    }
    
    func checkingForAlert(){
        
        guard let appVersion  = Double(AppInfoConfig.appversion) else{
            return
        }
        
        var rootController:UIViewController?
        //If user is not logged in
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        Log.echo(key: "yud", text: "Without Login RootView is\(appDelegate?.window?.rootViewController)")
        if let root = appDelegate?.window?.rootViewController{
            
            if root.presentedViewController != nil{
                root.presentedViewController?.dismiss(animated: false, completion: {
                })
            }
            rootController = root
        }
        
        if appVersion <= ObsoleteVersion{
            
            guard let controller = ObsoleteAlertController.instance() else{
                return
            }
            rootController?.present(controller, animated: true, completion: {
            })
            //This is the Obsolete version
            return
        }
        else if appVersion <= deprecatedVersion{
            
            guard let controller = DeprecationAlertController.instance() else{
                return
            }
            rootController?.present(controller, animated: true, completion: {
            })
            //This is the Deprecated Version
            return
        }
        else if appVersion < latestVersion{
            
            guard let controller = UpdateAlertController.instance() else{
                return
            }
            rootController?.present(controller, animated: true, completion: {
            })
            //This is the not latest Version
            return
        }
    }
}
