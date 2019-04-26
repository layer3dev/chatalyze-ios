//
//  ProFeatureListController.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class ProFeatureListController: InterfaceExtendedController {

    @IBOutlet var infoAlertView:UIView?
    @IBOutlet var infoLabel:UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backDismiss(sender:UIButton?){
        
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func hideAlert(){
        
        infoLabel?.text = ""
        UIView.animate(withDuration: 0.25) {
        
            self.infoAlertView?.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func serviceFeeAction(){
        
        infoLabel?.text = "Chatalyze will retain 20% of your chat and tip revenue."
        UIView.animate(withDuration: 0.25) {
            
            self.infoAlertView?.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func unlimitedPaidChatTime(){
      
        infoLabel?.text = "Host as many hours of paid chats as you want. The minimum chat price you can set is $3.00 due to relatively high processing fees at lower prices."
        
        UIView.animate(withDuration: 0.25) {
            
            self.infoAlertView?.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func postChatDonation(){
        
        infoLabel?.text = "You can enable post-chat tips so people can show their support after they chat with you. Note: tips made through the iOS app are subject to the App Store's 30% transaction fee."
        
        UIView.animate(withDuration: 0.25) {
            
            self.infoAlertView?.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func maxFreeTimeChat(){
        
        infoLabel?.text = "You have the option to host up to 4 hours of free chats."
        
        UIView.animate(withDuration: 0.25) {
            
            self.infoAlertView?.alpha = 1
            self.view.layoutIfNeeded()
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

    
    class func instance()->ProFeatureListController?{
        
        let storyboard = UIStoryboard(name: "ProFeature", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProFeatureList") as? ProFeatureListController
        return controller
    }
}
