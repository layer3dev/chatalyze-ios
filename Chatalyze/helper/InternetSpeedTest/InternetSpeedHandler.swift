//
//  InternetSpeedHandler.swift
//  Chatalyze
//
//  Created by Sumant Handa on 15/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class InternetSpeedHandler{
    
    private var speedProcessor : CheckInternetSpeed?
    
    private var isReleased = false
    private var didShowAlert = false
    
    private var controller : InterfaceExtendedController?
    private var listener : ((_ speed : Double?)->())?
    
    init(controller : InterfaceExtendedController?){
        self.controller = controller
    }
    
    
    func setSpeedListener(listener : ((_ speed : Double?)->())?){
        self.listener = listener
    }
    
    func release(){
        isReleased = true
    }

    
    func startSpeedProcessing(){
        checkForInternetConnection()
        let speedProcessor = CheckInternetSpeed()
        self.speedProcessor = speedProcessor
        
        speedProcessor.testDownloadSpeedWithTimeOut(timeOut: 8.0) {[weak self] (speed, error) in
            
            DispatchQueue.main.async {
                
                guard let weakSelf = self
                    else{
                        return
                }
                
                if(weakSelf.isReleased){
                    return
                }
                
                self?.recursiveCall()
                
                if(error != nil){
                    return
                }
                
                guard let speed = speed
                    else{
                        return
                }
                
                
                
                weakSelf.listener?(speed)
                
                if(speed >= 1.5){
                    return
                }
                
                weakSelf.showLowSpeedAlert()
                
            }
        }
    }
    
    private func recursiveCall(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {[weak self] in
            
            guard let weakSelf = self
                else{
                    return
            }
            
            if weakSelf.isReleased{
                return
            }
            
            weakSelf.startSpeedProcessing()
        }
    }
    
    private func checkForInternetConnection(){
        if !(InternetReachabilityCheck().isInternetAvailable()){
            
            let requiredPermission = VideoCallController.permissionsCheck.noInternet
            self.showMediaAlert(alert : requiredPermission)
            return
        }
    }
    
    private func showLowSpeedAlert(){
        if(didShowAlert){
            return
        }
        
        didShowAlert = true
        showMediaAlert(alert: .slowInternet)
    }
    
    private func showMediaAlert(alert : VideoCallController.permissionsCheck?){
        
        if self.controller?.presentedViewController as? MediaAlertController != nil{
            return
        }
        
        guard let controller = MediaAlertController.instance() else {
            return
        }
        
        controller.alert = alert ?? .none
        
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        self.controller?.present(controller, animated: true, completion: {
        })
    }

    
}
