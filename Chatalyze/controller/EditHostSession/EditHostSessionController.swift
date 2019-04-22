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
            
            self.rootView?.rootController = self
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveDescription(){
        
        
        guard let eventId = self.eventInfo?.id else{
            return
        }
        
        self.showLoader()
        
        //For inserting the paragraph
        let paraText = self.rootView?.info?.eventDescription ?? ""
        let ParaArray = paraText.components(separatedBy: "\n")
        
        var requiredStr = ""
        for info in ParaArray {
            requiredStr = requiredStr+"<p>"+info+"</p>"
        }
        EditMySessionProcessor().uploadEventBanner(eventId: eventId,description:requiredStr) { (success, jsonInfo) in
            
            self.stopLoader()
            if success{
                
                self.alert(withTitle: AppInfoConfig.appName, message: "Session info edited successfully", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                })
                return
            }
            self.alert(withTitle: AppInfoConfig.appName, message: "Error occurred", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
            })
            return
        }
    }
    
    
    func updateSessionBannerImage(){
        
        
        guard let eventId = self.eventInfo?.id else{
            return
        }
        
        if rootView?.selectedImage != nil {
            
            //For inserting the paragraph
            let paraText = self.rootView?.info?.eventDescription ?? ""
            let ParaArray = paraText.components(separatedBy: "\n")
            
            var requiredStr = ""
            for info in ParaArray {
                requiredStr = requiredStr+"<p>"+info+"</p>"
            }
            
            self.showLoader()
            EditMySessionProcessor().uploadEventBannerImage(image: rootView?.selectedImage,eventId: eventId,description:requiredStr) { (success, jsonInfo) in
                
                self.stopLoader()
                if success{
                    
                    self.alert(withTitle: AppInfoConfig.appName, message: "Session info edited successfully", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                    
                    })
                    return
                }
                self.alert(withTitle: AppInfoConfig.appName, message: "Error occurred", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                
                })
                return
            }
        }
    }
    
    @IBAction func share(sender:UIButton){
        
        Log.echo(key: "yud", text: "info are \(self.eventInfo?.id) and the url is \(self.eventInfo?.title)")
        
        guard let id = self.eventInfo?.id else{
            return
        }
        
        var str = "https://chatalyze.com/"
        str = str + "sessions/"
        str = str + (self.eventInfo?.title ?? "")
        str = str + "/"
        str = str + "\(id)"
        Log.echo(key: "yud", text: "url id is \(str)")
        str  = str.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: str) {
            
            Log.echo(key: "yud", text: "Successfully converted url \(str)")
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                
                let shareText = "Chatalyze"
                let shareItems: [Any] = [url]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = sender.frame
                self.present(activityVC, animated: false, completion: nil)
                
            }else{
                
                let shareText = "Chatalyze"
                let shareItems: [Any] = [url]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                self.present(activityVC, animated: false, completion: nil)
            }
        }
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
