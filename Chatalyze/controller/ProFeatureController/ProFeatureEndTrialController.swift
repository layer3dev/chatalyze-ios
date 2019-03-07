
//
//  ProFeatureEndTrialController.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//


import UIKit

class ProFeatureEndTrialController: InterfaceExtendedController {

    @IBOutlet private var starterPlanView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialize()
    }
    
    func initialize(){
        
        starterPlanView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 32.5: 22.5
        starterPlanView?.layer.masksToBounds = true
    }
    
    @IBAction func continueOnStarterPlan(sender:UIButton?){
        
        saveMetaInfo()
    }
    
    func saveMetaInfo(){
        
        var param = [String:Any]()
        param["meta"] = ["askPlan":false]
        
        Log.echo(key: "yud", text: "params are \(param)")
        
        self.showLoader()
        EditProfileProcessor().edit(params: param) { (success, message, response) in
            
            self.stopLoader()
            if !success{
                
                guard let info = SignedUserInfo.sharedInstance else{
                    return
                }
                info.shouldAskForPlan = false
                info.save()
                self.dismiss(animated: true) {
                }
                return
            }
            self.dismiss(animated: true) {
            }
        }
    }
    
    @IBAction func moreOnPlans(sender:UIButton?){
        
        guard let controller = ProFeatureListController.instance() else{
            return
        }
        self.getTopMostPresentedController()?.present(controller, animated: true, completion: {
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->ProFeatureEndTrialController?{
        
        let storyboard = UIStoryboard(name: "ProFeature", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProFeatureEndTrial") as? ProFeatureEndTrialController
        return controller
    }
}
