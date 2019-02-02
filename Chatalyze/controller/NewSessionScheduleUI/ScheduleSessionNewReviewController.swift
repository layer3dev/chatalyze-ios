//
//  ScheduleSessionNewReviewController.swift
//  Chatalyze
//
//  Created by mansa infotech on 01/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol ScheduleSessionNewReviewControllerDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToDoneScreen()
}

class ScheduleSessionNewReviewController: UIViewController {
    
    var delegate:ScheduleSessionNewReviewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootView?.fillInfo()
    }
    
    
    var rootView:ScheduleSessionNewReviewRootView?{
        return self.view as? ScheduleSessionNewReviewRootView
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    func scheduleAction(){
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        
        if info.bannerImage != nil{
            scheduleActionWithImage()
            return
        }
        
        guard var paramForUpload = rootView?.getParam() else{
            return
        }
        
        self.showLoader()
        
        Log.echo(key: "yud", text: "Param sending to web \(paramForUpload)")
        
        //For inserting the paragraph
        let paraText = paramForUpload["description"] as? String
        let ParaArray = paraText?.components(separatedBy: "\n")
        
        var requiredStr = ""
        for info in ParaArray ?? []{
            requiredStr = requiredStr+"<p>"+info+"</p>"
        }
        paramForUpload["description"] = requiredStr
        
        ScheduleSessionRequest().save(params: paramForUpload) { (success, message, response) in
            
            Log.echo(key: "yud", text: "Response in succesful event creation is \(String(describing: response))")
            
            DispatchQueue.main.async {
            
                self.stopLoader()
                
                if !success{
                    self.rootView?.showError(message:message)
                    return
                }
                
                if let info = response{
                    
                    let eventInfo = EventInfo(info: info)
                    self.delegate?.getSchduleSessionInfo()?.eventInfo = eventInfo
                }
                self.delegate?.goToDoneScreen()
            }
        }
    }
    
    private func uploadImage(completion : ((_ success :Bool, _ info : JSON?)->())?){
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        guard let image = info.bannerImage else{
            return
        }
        guard var paramForUpload = rootView?.getParam() else{
            return
        }
        guard let data = image.jpegData(compressionQuality: 1.0)
            else{
                completion?(false, nil)
                return
        }
        
        Log.echo(key: "imageUploading", text: "The parameteres that I am sending is \(paramForUpload)")
        let imageBase64 = "data:image/png;base64," +  data.base64EncodedString(options: .lineLength64Characters)
        
        paramForUpload["eventBanner"] = imageBase64
        
        var requiredParamForUpload = paramForUpload
        requiredParamForUpload["selectedHourSlot"] = nil
        
        //For inserting the paragraph
        let paraText = requiredParamForUpload["description"] as? String
        let ParaArray = paraText?.components(separatedBy: "\n")
        
        var requiredStr = ""
        for info in ParaArray ?? []{
            requiredStr = requiredStr+"<p>"+info+"</p>"
        }
        requiredParamForUpload["description"] = requiredStr
        
        Log.echo(key: "yud", text: " \nRequired param sending to web \(requiredParamForUpload)")
        
        self.showLoader()
        SessionRequestWithImageProcessor().schedule(params: requiredParamForUpload) { [weak self] (success, info) in
            
            Log.echo(key: "yud", text: "Response in succesful event creation is \(String(describing: info))")
            
            DispatchQueue.main.async {
              
                self?.stopLoader()
                if !success{
                    self?.rootView?.showError(message: info?["message"].stringValue ?? "")
                    completion?(success,info)
                    return
                }
                completion?(success,info)
            }
        }
    }
    
    func scheduleActionWithImage(){
        
        uploadImage { (success, response) in
            
            DispatchQueue.main.async {
            
                if !success{
                    return
                }
                
                if let info = response{
                    
                    let eventInfo = EventInfo(info: info)
                    self.delegate?.getSchduleSessionInfo()?.eventInfo = eventInfo
                }
                self.delegate?.goToDoneScreen()
            }
        }
    }
    
    
    class func instance()-> ScheduleSessionNewReviewController? {
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionNewReview") as? ScheduleSessionNewReviewController
        return controller
    }
    
}

extension ScheduleSessionNewReviewController:ScheduleSessionNewReviewRootViewDelegate{
    
    func goToEditScheduleSession() {
       
        guard let controller = EditScheduleSessionNewController.instance() else{
            return
        }
        controller.sessionInfo = delegate?.getSchduleSessionInfo()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?{
        
        return self.delegate?.getSchduleSessionInfo()
    }
    
    func goToNextScreen(){
        
        delegate?.goToDoneScreen()
    }
    
    func scheduleSession() {
        scheduleAction()
    }

    
}
