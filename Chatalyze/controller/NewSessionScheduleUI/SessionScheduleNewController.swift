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
    }
    
    func updateProfile(){
        
        self.showLoader()
        FetchProfileProcessor().fetch { (suucess, error, response) in
            self.stopLoader()
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
        
        if currentStatus == SessionScheduleNewPageController.CurretController.first || currentStatus == SessionScheduleNewPageController.CurretController.none{
            progressBar?.setProgress(0.11, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.second {
            progressBar?.setProgress(0.22, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.third {
            progressBar?.setProgress(0.33, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fourth {
            progressBar?.setProgress(0.44, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fifth {
            progressBar?.setProgress(0.55, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.sixth {
            progressBar?.setProgress(0.66, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.seventh {
            progressBar?.setProgress(0.77, animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.eighth {
            progressBar?.setProgress(0.88, animated: true)
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
        if currentStatus == SessionScheduleNewPageController.CurretController.first || currentStatus == SessionScheduleNewPageController.CurretController.none{
            
            paintProgressBar()
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.second {
            
            paintProgressBar()
            pageViewController?.setFirstController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.third {
            
            paintProgressBar()
            pageViewController?.setSecondController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fourth {
            
            paintProgressBar()
            pageViewController?.setThirdController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fifth {
            
            paintProgressBar()
            pageViewController?.setFourthController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.sixth {
            
            paintProgressBar()
            pageViewController?.setFifthController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.seventh {
            
            paintProgressBar()
            pageViewController?.setSixthController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.eighth {
            
            pageViewController?.setSeventhController()
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
