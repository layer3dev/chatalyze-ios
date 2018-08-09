//
//  EventPaymentController.swift
//  Chatalyze
//
//  Created by Mansa on 29/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit
import Stripe

class EventPaymentController: InterfaceExtendedController {
    
    @IBOutlet var rootView:EventPaymentRootView?
    var info:EventInfo?
    var presentingControllerObj:EventController?
    var dismissListner:((Bool)->())?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        rootView?.controller = self
        rootView?.info = self.info
        fetchCardDetails()
    }
    
    func fetchCardDetails(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        self.showLoader()
        FetchSavedCardDetails().fetchInfo(id: id) { (success, cardInfo) in
            self.stopLoader()
            if success{
                
                if let cardinfo = cardInfo{
                    
                    self.rootView?.cardInfoArray = cardinfo
                    var count = 0
                    for _ in cardinfo{
                        count = count + 1
                    }
                    if count == 1{
                        
                        self.rootView?.numberOfSaveCards = 1
                        self.rootView?.paintInterfaceForSavedCard()
                    }
                    if count >= 2{
                        
                        self.rootView?.numberOfSaveCards = 2
                        self.rootView?.paintInterfaceForSavedCard()
                    }
                }
            }
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        Log.echo(key: "yud", text: "Touch is \(touch.view)")
        
        if touch.view == self.rootView?.selectDateMonthBtn{
            Log.echo(key: "yud", text: "Button is called")

            self.rootView?.dateAction(sender: nil)
            return false
        }
        return true
    }
    
    //    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    //        return false
    //    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
}

extension EventPaymentController{
    
    class func instance()->EventPaymentController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EventPayment") as? EventPaymentController
        return controller
    }
}

