//
//  EventLandingController.swift
//  Chatalyze
//
//  Created by Mansa on 24/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventLandingController: InterfaceExtendedController {
    
    var info:EventInfo?
    @IBOutlet var eventSoldOutView:UIView?
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        initializevariable()
    }
    
    func initializevariable(){
        
        guard let info = self.info else{
            return
        }
        self.rootView?.fillInfo(info:info)
    }
    
    func paintInterface(){
        
        paintBackButton()
        paintNavigationTitle(text: "Purchase Ticket")
    }
    
    var rootView:EventLandingRootView?{
        
        get{
            return self.view as? EventLandingRootView
        }
    }
    
    @IBAction func purchaseTicketAction(sender:UIButton?){
        
        if (true){
            
            UIView.animate(withDuration: 0.3) {
                
                self.eventSoldOutView?.alpha = 1
                self.view.layoutIfNeeded()
            }
            return
        }else{
            
            UIView.animate(withDuration: 0.3) {
                self.eventSoldOutView?.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
        
        
        
        guard let controller = SystemTestController.instance() else {
            return
        }
        controller.info = self.info
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.dismissListner = {
            DispatchQueue.main.async {
                Log.echo(key: "yud", text: "I got dismiss call")
                self.dismiss(animated: false, completion: {
                })
            }
        }
        self.present(controller, animated: true, completion: {
        })
    }
    
    @IBAction func cancelAction(){
        
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //segue.identifier
        let controller = segue.destination as? EventSoldOutController
        controller?.dismissListner = {
            
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {                
                self.eventSoldOutView?.alpha = 0
            }
        }
        controller?.info = self.info
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

extension EventLandingController{
    
    class func instance()->EventLandingController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EventLandingController") as? EventLandingController
        return controller
    }
}

