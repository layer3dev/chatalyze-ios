//
//  ScheduleSessionNewReviewController.swift
//  Chatalyze
//
//  Created by mansa infotech on 01/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

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
        
        guard var paramForUpload = rootView?.getParam() else{
            return
        }
        
        paramForUpload["eventBannerInfo"] = false
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
            
            Log.echo(key: "yud", text: "Response in succesful event creation is \(response)")
            
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
    
    class func instance()-> ScheduleSessionNewReviewController? {
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionNewReview") as? ScheduleSessionNewReviewController
        return controller
    }
    
}

extension ScheduleSessionNewReviewController:ScheduleSessionNewReviewRootViewDelegate{
    
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
