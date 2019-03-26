//
//  EditSessionFormController.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EditSessionFormController: InterfaceExtendedController {
    
    var eventInfo:EventInfo?
    @IBOutlet var scrollViewCustom:FieldManagingScrollView?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showLoader()
        self.rootView?.controller = self
        fetchMinimumPlanPriceToScheuleIfExists()
        paintInterface()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootInitialization()
    }
    
    func rootInitialization() {
        
        DispatchQueue.main.async {
            
            self.rootView?.initializeVariable()
            self.rootView?.fillInfo(info:self.eventInfo)
            self.stopLoader()
        }
    }
    
    func paintInterface(){
        
        rootView?.paintInteface()
        paintBackButton()
        paintNavigationTitle(text: "Edit Session")
    }

    var rootView:EditSessionFormRootView?{
        return self.view as? EditSessionFormRootView
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
            self.rootView?.scheduleInfo?.minimumPlanPriceToSchedule = info.minPrice ?? 0.0
            
            self.rootView?.planInfo = info
           
            Log.echo(key: "Earning Screen", text: "id of plan is \(info.id) name of the plan is \(info.name) min. price is \(info.minPrice) and the plan fee is \(info.chatalyzeFee)")
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
    
    
    class func instance()->EditSessionFormController?{
        
        let storyboard = UIStoryboard(name: "EditScheduleSession", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditSessionForm") as? EditSessionFormController
        return controller
    }
}

