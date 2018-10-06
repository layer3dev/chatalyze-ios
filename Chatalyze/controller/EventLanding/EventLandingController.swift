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
    var dismissListener:((Bool)->())?
    
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "PURCHASE TICKET")
    }
    
    
    var rootView:EventLandingRootView?{
        
        get{
            return self.view as? EventLandingRootView
        }
    }
    
    @IBAction func share(sender:UIButton){
        
        Log.echo(key: "yud", text: "info are \(self.info?.id) and the url is \(self.info?.title)")
        
        
        
        guard let id = self.info?.id else{
            return
        }
        
        var str = "https://dev.chatalyze.com/"
        str = str + "sessions/"
        str = str + (self.info?.title ?? "")
        str = str + "/"
        str = str + "\(id)"
        Log.echo(key: "yud", text: "url id is \(str)")
        str  = str.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: str) {
            
            Log.echo(key: "yud", text: "Successfully converted url \(str)")
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                
                let shareText = "Chatalyze"
                let shareItems: [Any] = [url,shareText]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = sender.frame
                self.present(activityVC, animated: false, completion: nil)
                
            }else{
                
                let shareText = "Chatalyze"
                let shareItems: [Any] = [url, shareText]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                self.present(activityVC, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func purchaseTicketAction(sender:UIButton?){
        
        if  rootView?.iseventsold ?? false{
            
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
//        controller.dismissListner = {(success) in
//            DispatchQueue.main.async {
//
//                Log.echo(key: "yud", text: "I got dismiss call in the Event Landing Page \(success)")
//                self.navigationController?.popToRootViewController(animated: false)
//                if let listener = self.dismissListener{
//                    listener(success)
//                }
//            }
//        }
        
        
        controller.dismissListner = self.dismissListener
        
        RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
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
}

extension EventLandingController{
    
    class func instance()->EventLandingController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EventLandingController") as? EventLandingController
        return controller
    }
}
