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
            
            if !isThisTimeToShowAlert(){
                return
            }
            saveTimeStampToShowAlert()
            guard let controller = DeprecationAlertController.instance() else{
                return
            }
            rootController?.present(controller, animated: true, completion: {
            })
            //This is the Deprecated Version
            return
        }
        else if appVersion < latestVersion{
           
            if !isThisTimeToShowAlert(){
                return
            }
            saveTimeStampToShowAlert()
            guard let controller = UpdateAlertController.instance() else{
                return
            }
            rootController?.present(controller, animated: true, completion: {
            })
            //This is the not latest Version
            return
        }
    }
    
    func isThisTimeToShowAlert()->Bool{
        
        if UserDefaults.standard.value(forKey: "lastSavedTimeForAlert") as? Date == nil {
            return true
        }
        
        if let lastSavedDate = UserDefaults.standard.value(forKey: "lastSavedTimeForAlert") as? Date{
            
            let timeDiffrence  = Date().timeIntervalSince(lastSavedDate)
            
            Log.echo(key: "yud", text: "Time Difference in showing the alert is \(timeDiffrence)")
            
            if timeDiffrence > 20{
                return true
            }
            return false
        }
        return true
    }
    
    func saveTimeStampToShowAlert(){
        
        UserDefaults.standard.set(Date(), forKey: "lastSavedTimeForAlert")
    }
    
}
