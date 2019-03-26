//
//  FreeEventPaymentController.swift
//  Chatalyze
//
//  Created by Mansa on 07/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class FreeEventPaymentController: InterfaceExtendedController {
    
    var info:EventInfo?
    @IBOutlet var errorLable:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    @IBAction func confirmAction(sender:UIButton?){
        
        errorLable?.text = ""
        confirmFreePayment()
    }
    
    @IBAction func close(sender:UIButton?){
        
        self.dismiss(animated: false) {
        }
    }
    
    func confirmFreePayment(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            Log.echo(key: "yud", text: "I am returning as ID did not found")
            return
        }
        
        guard let info = self.info else{
            Log.echo(key: "yud", text: "I am returning as info did not found")
            return
        }
        
        guard let callScheduleId = info.id else{
            Log.echo(key: "yud", text: "I am returning as info did not found")
            return
        }
        
        var param = [String:Any]()
        //param["token"] = token
        
        if let isFree = info.isFree{
            if isFree{
                
                param["userId"] = Int(id)
                param["callscheduleId"] = Int(callScheduleId)
                param["browserDate"] = "\(DateParser.getCurrentDateInUTC())"
                param["freeEvent"] = true
            }else{
                
                Log.echo(key: "yud", text: "This event is not a free event")
                return
                //                param["card"] = false
                //                param["amount"] = String(amount)
                //                param["serviceFee"] = String(serviceFee)
                //                param["userId"] = Int(id)
                //                param["callscheduleId"] = Int(callScheduleId)
                //                param["remember"] = isCardSave
                //                param["browserDate"] = "\(DateParser.getCurrentDateInUTC())"
                //                param["freeEvent"] = self.info?.isFree ?? false
                //                param["creditCard"] = accountNumber
                //                param["expiryDate"] = expMonth+expiryYear
                //                param["cvv"] = cvc
            }
        }
        
        self.showLoader()
        EventPaymentProcessor().pay(param: param) { (success, message, response) in
            
            self.stopLoader()
            if !success{
                
                self.errorLable?.text = message
                return
            }
            
            guard let response = response else{
                return
            }
            
            self.dismiss(animated: false, completion: {
                
                guard let controller = PaymentSuccessController.instance() else{
                    return
                }
                controller.info = response
                
                //controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                
                //                controller.dismissListner = {(success) in
                //                    DispatchQueue.main.async {
                //                        self.dismiss(animated: false, completion: {
                //                            if let listner = self.dismissListner{
                //                                listner(success)
                //                            }
                //                        })
                //                    }
                //                }
                
                
                RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
                })
                
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instance()->FreeEventPaymentController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FreeEventPayment") as? FreeEventPaymentController
        return controller
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


