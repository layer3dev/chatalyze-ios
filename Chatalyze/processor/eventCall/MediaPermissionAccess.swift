//
//  MediaPermissionAccess.swift
//  Chatalyze
//
//  Created by Sumant Handa on 07/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MediaPermissionAccess{

    private var controller : InterfaceExtendedController
    private var callback : ((_ success : Bool)->())?
    
    init(controller : InterfaceExtendedController){
        self.controller = controller
    }
    
    func verifyMediaAccess(callback : ((_ success : Bool)->())?){
        self.callback = callback
        checkForMediaAccess { (success) in
            if(success){
                callback?(success)
                return
            }
            self.alertToProvideMediaAccess(callback : {
                 callback?(success)
            })
           
        }
       
    }
    
    private func checkForMediaAccess(callback : ((_ success : Bool)->())?){
        checkForCameraAccess { (cameraAccess) in
            self.checkforMicrophoneAccess(callback: { (microphoneAccess) in
                if(cameraAccess && microphoneAccess){
                    callback?(true)
                    return
                }
                callback?(false)
                return
            })
            
        }
    }
    
    
    private func checkForCameraAccess(callback : ((_ success : Bool)->())?){
        
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .denied:
            callback?(false)
            return
        case .authorized:
            callback?(true)
            return
        case .restricted:
             callback?(false)
            return
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    callback?(true)
                    return
                } else {
                    callback?(false)
                    return
                }
            }
            break
        }
    }
    
    
    private func checkforMicrophoneAccess(callback : ((_ success : Bool)->())?){
        
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            callback?(true)
            return
        case AVAudioSessionRecordPermission.denied:
            callback?(false)
            return
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if !granted{
                    callback?(false)
                    return
                }
                callback?(true)
                return
            })
        }
    }
    
    
    
    private func alertToProvideMediaAccess(callback : (()->())?){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide Camera & Microphone access to be able to continue to session.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.controller.dismiss(animated: true, completion: {
                callback?()
                if let settingUrl = URL(string: UIApplicationOpenSettingsURLString){
                    UIApplication.shared.openURL(settingUrl)
                }
            })
        }))
        controller.present(alert, animated: true) {
        }
    }
    
}
