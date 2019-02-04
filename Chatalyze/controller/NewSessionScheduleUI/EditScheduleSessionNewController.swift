//
//  EditScheduleSessionNewController.swift
//  Chatalyze
//
//  Created by mansa infotech on 02/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EditScheduleSessionNewController: UIViewController {
    
    var sessionInfo:ScheduleSessionInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView?.controller = self
        rootView?.fillInfo(info:sessionInfo)
    }
    
    var rootView:EditScheduleSessionNewRootView?{
        get{
            return self.view as? EditScheduleSessionNewRootView
        }
    }
    
    @IBAction func doneEditingAction(sender:UIButton?){
        back()
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootView?.paintImageUploadBorder()
    }
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func fillInfo(){
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    class func instance()->EditScheduleSessionNewController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditScheduleSessionNew") as? EditScheduleSessionNewController
        return controller
    }
}

