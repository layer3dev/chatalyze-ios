//
//  TippingConfirmationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 12/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import StoreKit

class TippingConfirmationController: InterfaceExtendedController {
    
    var scheduleInfo : EventScheduleInfo?
    var slotId : Int?
    
    var donateProduct : DonateProduct?
    var appStateManager : ApplicationConfirmForeground?
    
    private var isProcessingLastTransaction = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        
        
        rootView?.fillInfo(scheduleInfo: scheduleInfo)
    }
    
    var rootView:TippingRootView?{
        return self.view as? TippingRootView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func noTipAction(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cardInfoAction(sender:UIButton){
        guard let controller = TippingCardDetailInfoController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //two dollar now
    @IBAction func dollorTwoTipAction(sender:UIButton){
        donate(value : .two)
        
    }
    
    //six dollar now
    @IBAction func dollorSixTipAction(sender:UIButton){
        donate(value : .six)
        
    }
    
    //ten dollar now
    @IBAction func dollorTenTipAction(sender:UIButton){
        donate(value : .ten)
        
    }
    
    private func donate(value : DonateProductInfo.value){
        if(isProcessingLastTransaction){
            return
        }
        
        isProcessingLastTransaction = true
        showLoader()
        createTransaction(value: value) {[weak self] (transactionId) in
            self?.stopLoader()
            guard let transactionId = transactionId
                else{
                    return
            }
            
            self?.initiatePurchaseProcess(transactionId: transactionId, value: value)
        }
    }
    
    private func initiatePurchaseProcess(transactionId : String, value : DonateProductInfo.value){
        
        let donateProduct = DonateProduct(controller : self)
        self.donateProduct = donateProduct
        donateProduct.buy(value: value, transactionId: transactionId) {[weak self] (success) in
            self?.isProcessingLastTransaction = false
            Log.echo(key: "in_app_purchase", text: "success -> \(success) ")
            
            if(!success){
                return
            }
            self?.showSuccessScreen(value : value)
            return
        }
    }
    
    private func showSuccessScreen(value : DonateProductInfo.value){
        let appStateManager = ApplicationConfirmForeground()
        self.appStateManager = appStateManager
        
        appStateManager.confirmIfActive {[weak self] in
            Log.echo(key: "in_app_purchase", text: "confirmIfActive -> active")
            self?.presentSuccess(value : value)
        }
    }
    
    
    
    private func createTransaction(value : DonateProductInfo.value, completion : @escaping (_ transactionId : String?)->()){
        
        guard let sessionId = scheduleInfo?.id
            else{
                completion(nil)
                return
        }
        guard let slotId = slotId
            else{
                completion(nil)
                return
        }
        
        DonateCreateTransaction().createTransaction(value: value, sessionId: sessionId, slotId: slotId) { (success, transactionId) in
            completion(transactionId)
        }
    }
    
    private func presentSuccess(value : DonateProductInfo.value?){
        
        guard let controller = DonationSuccessController.instance()
            else{
                return
        }
        
        controller.scheduleInfo = scheduleInfo
        controller.price = value?.getValue()
        self.present(controller, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->TippingConfirmationController?{
        
        let storyboard = UIStoryboard(name: "Tipping", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TippingConfirmation") as? TippingConfirmationController
        return controller
    }
}



