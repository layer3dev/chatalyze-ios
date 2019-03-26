//
//  SessionScheduleNewController.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import YLProgressBar

class SessionScheduleNewController: UIViewController {
    
    var pageViewController:SessionScheduleNewPageController?
    var scheduleInfo = ScheduleSessionInfo()
    @IBOutlet var progressBar:YLProgressBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initializeGradient()
        updateProfile()
        fetchMinimumPlanPriceToScheuleIfExists()
    }
    
    func askForStarterPlanIfNotAskedYet(){
        
        guard let userType = SignedUserInfo.sharedInstance?.role else{
            return
        }
        
        if userType == .user{
            return
        }
        
        guard let shouldAskForPlan = SignedUserInfo.sharedInstance?.shouldAskForPlan else{
            return
        }
        
        Log.echo(key: "container", text: "Should I ask for plan \(shouldAskForPlan)")
        
        if !shouldAskForPlan {
            return
        }
        
        guard let controller = ProFeatureEndTrialController.instance() else{
            return
        }
        
        self.getTopMostPresentedController()?.present(controller, animated: true, completion: {
        })
    }
    
    func updateProfile(){
        
        self.showLoader()
        FetchProfileProcessor().fetch { (suucess, error, response) in
            
            self.stopLoader()
            self.askForStarterPlanIfNotAskedYet()
        }
    }
    
    func fetchMinimumPlanPriceToScheuleIfExists(){
        
            GetPlanRequestProcessor().fetch { (success,error,response) in
                
                if !success {
                    return
                }
                guard let response = response else{
                    return
                }
                let info = PlanInfo(info: response)
                self.scheduleInfo.minimumPlanPriceToSchedule = info.minPrice ?? 0.0
                self.scheduleInfo.chatalyzeFeePercent = info.chatalyzeFee ?? nil
                Log.echo(key: "Earning Screen", text: "id of plan is \(info.id) name of the plan is \(info.name) min. price is \(info.minPrice)")
            }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func initializeGradient(){
        
        let tintColors = [UIColor(red: 249.0/255.0, green: 128.0/255.0, blue: 106/255.0, alpha: 1), UIColor(red: 248.0/255.0, green: 149.0/255.0, blue: 92/255.0, alpha: 1)]
        progressBar?.type = YLProgressBarType.flat
        progressBar?.progressTintColors = tintColors
        progressBar?.hideStripes = true
        progressBar?.hideTrack = true
        progressBar?.behavior = YLProgressBarBehavior.default
        progressBar?.setProgress(0.11, animated: true)
    }
    
    func paintProgressBar(){
        
        guard let currentStatus = pageViewController?.getCurrentPageController() else{
            return
        }
        
        if currentStatus == SessionScheduleNewPageController.CurretController.title || currentStatus == SessionScheduleNewPageController.CurretController.none{
            progressBar?.setProgress(0.10, animated: true)
            return
        }
        
        if currentStatus == SessionScheduleNewPageController.CurretController.first{
            progressBar?.setProgress(0.20, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.second {
            progressBar?.setProgress(0.30, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.third {
            progressBar?.setProgress(0.40, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fourth {
            progressBar?.setProgress(0.50, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fifth {
            progressBar?.setProgress(0.60, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.sixth {
            progressBar?.setProgress(0.70, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.seventh {
            progressBar?.setProgress(0.80, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.eighth {
            progressBar?.setProgress(0.90, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.ninth {
            progressBar?.setProgress(1.0, animated: true)
            return
        }
    }
    
    @IBAction func backButton(sender:UIButton){
        
        guard let currentStatus = pageViewController?.getCurrentPageController() else{
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.title || currentStatus == SessionScheduleNewPageController.CurretController.none{
            
            paintProgressBar()
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.first{
            
            paintProgressBar()
            pageViewController?.setTitleController(direction: .reverse)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.second {
            
            paintProgressBar()
            pageViewController?.setFirstController(direction: .reverse)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.third {
            
            paintProgressBar()
            pageViewController?.setSecondController(direction: .reverse)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fourth {
            
            paintProgressBar()
            pageViewController?.setThirdController(direction: .reverse)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fifth {
            
            paintProgressBar()
            pageViewController?.setFourthController(direction: .reverse)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.sixth {
            
            paintProgressBar()
            pageViewController?.setFifthController(direction: .reverse)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.seventh {
            
            paintProgressBar()
            pageViewController?.setSixthController(direction: .reverse)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.eighth {
            
            pageViewController?.setSeventhController(direction: .reverse)
            paintProgressBar()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.ninth {
            paintProgressBar()
            return
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        self.pageViewController = segue.destination as? SessionScheduleNewPageController
        self.pageViewController?.pageDelegate = self
    }
    
    class func instance()->SessionScheduleNewController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionScheduleNew") as? SessionScheduleNewController
        return controller
    }
}


extension SessionScheduleNewController:SessionScheduleNewPageControllerDelegate{
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?{
        return self.scheduleInfo
    }
    
    func backToRootController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateProgress(){
        paintProgressBar()
    }
}
