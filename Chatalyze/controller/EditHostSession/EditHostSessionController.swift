//
//  EditHostSessionController.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EditHostSessionController: EditScheduledSessionController{
    
    var eventInfo:EventInfo?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        DispatchQueue.main.async {
            
            self.fillInfoToRoot()
        }
    }
    
    func fillInfoToRoot(){
        
        guard let info = self.eventInfo else{
            return
        }
        rootView?.fillInfo(eventInfo: info)
    }
    
    override var rootView: EditHostSessionRootView?{
        
        return self.view as? EditHostSessionRootView
    }

    override func back(){
        
        guard let eventId = self.eventInfo?.id else{
            return
        }
        
        if rootView?.selectedImage != nil {
            
            EditMySessionProcessor().uploadEventBannerImage(image: selectedImage,eventId: eventId,description:self.rootView?.info?.eventDescription ?? "") { (success, jsonInfo) in
                
                if success{
                    
                    self.alert(withTitle: AppInfoConfig.appName, message: "Session info edited successfully", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.alert(withTitle: AppInfoConfig.appName, message: "Error occurred", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
                return
            }
        }else{
            
            
            EditMySessionProcessor().uploadEventBanner(eventId: eventId,description:self.rootView?.info?.eventDescription ?? "") { (success, jsonInfo) in
                
                if success{
                    
                    self.alert(withTitle: AppInfoConfig.appName, message: "Session info edited successfully", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.alert(withTitle: AppInfoConfig.appName, message: "Error occurred", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
                return
            }
        }
        
        Log.echo(key: "Selected image is", text: "\( rootView?.selectedImage == nil)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override class func instance()->EditHostSessionController?{
        
        let storyboard = UIStoryboard(name: "EditScheduleSession", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditHostSession") as? EditHostSessionController
        return controller
    }
    
}
