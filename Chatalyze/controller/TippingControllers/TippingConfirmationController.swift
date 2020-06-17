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
    
    var scheduleInfo:EventScheduleInfo?
    var slotId:Int?
    var donateProduct:DonateProduct?
    var appStateManager:ApplicationConfirmForeground?
    var memoryImage:UIImage?
    
    private var isProcessingLastTransaction = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rootView?.controller = self
        rootView?.fillInfo(scheduleInfo: scheduleInfo)
    }
    
    var rootView:TippingRootView?{
       
        return self.view as? TippingRootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func noTipAction(){
        
//        if memoryImage == nil{
           
            guard let controller = ReviewController.instance() else{
                return
            }
            controller.eventInfo = scheduleInfo
            self.navigationController?.pushViewController(controller, animated: true)
            return
//        }
        
//        guard let controller = MemoryAnimationController.instance() else{
//            return
//        }
//        controller.eventInfo = scheduleInfo
//        controller.memoryImage = self.memoryImage
//        self.navigationController?.pushViewController(controller, animated: true)
//        return
        
    }
    
    @IBAction func cardInfoAction(sender:UIButton){
        
        guard let controller = TippingCardDetailInfoController.instance() else{
            return
        }
        controller.modalPresentationStyle = .fullScreen

        self.present(controller, animated: true) {
            
        }
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
        createTransaction(value: value) {[weak self] (transactionId)
            in
            
            guard let transactionId = transactionId
                else{
                   
                    self?.stopLoader()
                    self?.isProcessingLastTransaction = false
                    return
            }
            
            self?.initiatePurchaseProcess(transactionId: transactionId, value: value, completion: {
                
                Log.echo(key: "yud", text: "completion called")
                
                self?.stopLoader()
            })
        }
    }
    
    private func initiatePurchaseProcess(transactionId : String, value : DonateProductInfo.value, completion : @escaping ()->()){
        
        let donateProduct = DonateProduct(controller : self)
        self.donateProduct = donateProduct
        
        donateProduct.buy(value: value, transactionId: transactionId) {[weak self] (success, transaction) in
            
            self?.isProcessingLastTransaction = false
            Log.echo(key: "in_app_purchase", text: "success -> \(success)")
            guard let transaction = transaction
                else{
                    completion()
                    return
            }
            
            SKPaymentQueue.default().finishTransaction(transaction)
            if(!success){
                completion()
                return
            }
            
            
            
            //Completed transaction need to be marked as finished, after confirming with server.
            //todo:need better management.
            
            
            Log.echo(key: "yud", text: "Completion three")
            
            completion()
            self?.showSuccessScreen(value : value)
            return
        }
    }
    
    private func showSuccessScreen(value : DonateProductInfo.value){
       
        let appStateManager = ApplicationConfirmForeground()
        self.appStateManager = appStateManager
        
        //wait for application to be in foreground before presenting next screen.
        //this is needed to prevent issue, where user stays in on tipping screen, if payment is processed while app being in background
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
        controller.memoryImage = self.memoryImage
        self.navigationController?.pushViewController(controller, animated: true)
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



