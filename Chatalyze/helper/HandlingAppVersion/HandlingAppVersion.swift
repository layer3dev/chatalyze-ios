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
    
    override init(){
        super.init()
        
        Log.echo(key: "yud", text: "Initializing from the server")
        Log.echo(key: "yud", text: "lv is \(UserDefaults.standard.value(forKey: "latestVersion") as? Double ?? 0.0) dv is \(UserDefaults.standard.value(forKey: "deprecateVersion") as? Double ?? 0.0) ov is \(UserDefaults.standard.value(forKey: "obsoleteVersion") as? Double ?? 0.0)")
        
        self.latestVersion = UserDefaults.standard.value(forKey: "latestVersion") as? Double ?? 0.0
        self.deprecatedVersion = UserDefaults.standard.value(forKey: "deprecateVersion") as? Double ?? 0.0
        self.ObsoleteVersion = UserDefaults.standard.value(forKey: "obsoleteVersion") as? Double ?? 0.0
    }
    
    func checkForAlert(){
        
        guard let appVersion  = Double(AppInfoConfig.appversion) else{
            return
        }
        Log.echo(key: "yud", text: "App version is \(appVersion)")
        var rootController:UIViewController?
        //If user is not logged in
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        Log.echo(key: "yud", text: "Without Login RootView is\(appDelegate?.window?.rootViewController)")
        if let root = appDelegate?.window?.rootViewController{
            rootController = root
        }
        
        if appVersion <= ObsoleteVersion{
            
            if rootController?.presentedViewController as? ObsoleteAlertController != nil{
                Log.echo(key: "yud", text: "ObsoleteAlertController is already presented")
                return
            }
            
            if rootController?.presentedViewController != nil {
                rootController?.presentedViewController?.dismiss(animated: false, completion: {
                })
            }
            
            guard let controller = ObsoleteAlertController.instance() else{
                return
            }
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            rootController?.present(controller, animated: true, completion: {
            })
            
            //This is the Obsolete version
            return
        }
        else if appVersion <= deprecatedVersion{
            
            if !isThisTimeToShowAlert(){
                return
            }
            
            if rootController?.presentedViewController as? DeprecationAlertController != nil{
                Log.echo(key: "yud", text: "DeprecationAlertController is already presented")
                return
            }
            
            if rootController?.presentedViewController != nil{
                rootController?.presentedViewController?.dismiss(animated: false, completion: {
                })
            }
            
            saveTimeStampToShowAlert()
            guard let controller = DeprecationAlertController.instance() else{
                return
            }
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            rootController?.present(controller, animated: true, completion: {
            })
            //This is the Deprecated Version
            return
        }
        else if appVersion < latestVersion{
            
            if !isThisTimeToShowAlert(){
                return
            }
            
            if rootController?.presentedViewController as? UpdateAlertController != nil{
                
                Log.echo(key: "yud", text: "UpdateAlertController is already presented")
                return
            }
            
            if rootController?.presentedViewController != nil{
                rootController?.presentedViewController?.dismiss(animated: false, completion: {
                })
            }
            
            saveTimeStampToShowAlert()
            guard let controller = UpdateAlertController.instance() else{
                return
            }
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
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
            
            if timeDiffrence > 86400{
                
                return true
            }
            return false
        }
        return true
    }
    
    func saveTimeStampToShowAlert(){
        
        UserDefaults.standard.set(Date(), forKey: "lastSavedTimeForAlert")
    }
    
    func getAlertMessage()->String{
        
        guard let appVersion  = Double(AppInfoConfig.appversion) else{
            
            return ""
        }
        if appVersion <= self.ObsoleteVersion{
            
            return "This version of our app is no longer supported. You must update to the latest version to continue using our services."
        }
        else if appVersion <= deprecatedVersion{
            
            return "This version of our app will soon no longer work. Please update to the latest version now to avoid any issues."
        }
        else if appVersion < latestVersion{
            
            return "This version of our app is outdated. We recommend updating to the latest version."
        }
        return ""
    }
    
    static func goToAppStoreForUpdate(){
        
        if let itunesUrl = URL(string:"https://itunes.apple.com/us/app/chatalyze/id1313197231?ls=1&mt=8"){
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(itunesUrl)
                return
            }
            //Fallback on earlier versions
            UIApplication.shared.openURL(itunesUrl)
        }
    }
}
