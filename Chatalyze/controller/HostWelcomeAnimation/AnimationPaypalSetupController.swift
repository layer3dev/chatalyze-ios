//
//  AnimationPaypalSetupController.swift
//  Chatalyze
//
//  Created by mansa infotech on 26/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AnimationPaypalSetupController: PaymentSetupPaypalController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchPaymentHistory(){
    }
    override func fetchPaymentHostoryForPagination(){
    }
    override func fetchPaypalInfo(){
    }
    override func fetchBillingInfo(){
    }
    
    @IBAction func skipAction(sender:UIButton?){
        
        UserDefaults.standard.removeObject(forKey: "isHostWelcomeScreenNeedToShow")        
         self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
        })
        
    }
    
    override func submit(){
        
        guard let analystID = SignedUserInfo.sharedInstance?.id else{
            return
        }
        let email = emailField?.textField?.text ?? ""
        
        self.showLoader()
        SubmitPaypalEmailProcessor().save(idOfEmail:self.id,isEmailExists:false,analystId: analystID, email: email) { (success, message, response) in
            self.stopLoader()
            
            DispatchQueue.main.async {
                
                if !success {
                    
                    self.alert(withTitle: AppInfoConfig.appName, message: message, successTitle: "Ok", rejectTitle: "cancel", showCancel: false, completion: { (success) in
                    })
                    return
                }
                
                UserDefaults.standard.removeObject(forKey: "isHostWelcomeScreenNeedToShow")
                
                guard let controller = AnimationHostReadyController.instance() else {
                    return
                }
                
                self.present(controller, animated: true, completion: {
                })
            }
        }
    }
    
    
    
    override class func instance()->AnimationPaypalSetupController? {
        
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AnimationPaypalSetup") as? AnimationPaypalSetupController
        return controller
    }
    
    /*
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
