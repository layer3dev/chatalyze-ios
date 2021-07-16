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
        SubmitPaypalEmailProcessor().save(idOfEmail:self.id,isEmailExists:isEmailExists,analystId: analystID, email: email) { (success, message, response) in
            self.stopLoader()
            
            DispatchQueue.main.async {
                
                if !success {
                    
                    self.alert(withTitle: AppInfoConfig.appName, message: message, successTitle: "Ok".localized() ?? "", rejectTitle: "Cancel".localized() ?? "", showCancel: false, completion: { (success) in
                    })
                    return
                }
                
                UserDefaults.standard.removeObject(forKey: "isHostWelcomeScreenNeedToShow")
                
                guard let controller = AnimationHostReadyController.instance() else {
                    return
                }
                controller.modalPresentationStyle = .fullScreen

                
                self.present(controller, animated: true, completion: {
                })
            }
        }
    }
    
    override func fetchPaypalInfo(){
        
        self.showLoader()
        FetchPaypalEmailHost().fetchInfo { (success, response) in
            self.stopLoader()
            
            if success{
                
                guard let res = response else{
                    self.isEmailExists = false
                    return
                }
                
                if let dict = res.dictionary{
                    if let email = dict["email"]?.stringValue{
                        
                        //self.emailField?.textField?.text = email
                        self.id = dict["id"]?.stringValue ?? ""
                        Log.echo(key: "yud", text: "Id is \(self.id)")
                    }
                }
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
