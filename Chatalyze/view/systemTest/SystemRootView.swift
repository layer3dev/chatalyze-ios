//
//  SystemRootView.swift
//  Chatalyze
//
//  Created by Mansa on 29/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class SystemRootView: ExtendedView {
    
    var controller:SystemTestController?
    @IBOutlet var cancelView:UIView?
    @IBOutlet var dataView:UIView?
    @IBOutlet var beginView:UIView?
    var info:EventInfo?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        //implementTapGesture()
    }
    
    func implementTapGesture(){
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        cancelView?.addGestureRecognizer(tap)
    }
    
    func paintInterface(){
        
        dataView?.layer.cornerRadius = 3
        dataView?.layer.masksToBounds = true
        beginView?.layer.cornerRadius = 3
        beginView?.layer.masksToBounds = true
    }
}

extension SystemRootView:UIGestureRecognizerDelegate{
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
      
        self.controller?.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func cancelAction(){
        
        DispatchQueue.main.async {
            self.controller?.dismiss(animated: false, completion: {
                if let listner = self.controller?.dismissListner{
                    listner()
                }
            })
        }
    }   
    
    @IBAction func skipAction(sender:UIButton?){
        
        guard let controller = EventPaymentController.instance() else{
            return
        }
        controller.info = self.info
//        if self.info?.isFree ?? false{
//            return
//        }
        controller.dismissListner = {
            self.controller?.dismiss(animated: false, completion: {
                DispatchQueue.main.async {
                    if let listner = self.controller?.dismissListner{
                        listner()
                    }
                }
            })
        }
        controller.presentingControllerObj = self.controller?.presentingControllerObj
        self.controller?.present(controller, animated: false, completion: {
        })
    }
    
    @IBAction func beginTesteAction(sender:UIButton){
    
        guard let controller = InternetSpeedTestController.instance() else{
            return
        }
        controller.rootController = self.controller?.presentingControllerObj
        controller.onSuccessTest = {(success) in
            self.skipAction(sender: nil)
        }
        controller.dismissListner = {
            self.controller?.dismiss(animated: false, completion: {
                DispatchQueue.main.async {
                    if let listner = self.controller?.dismissListner{
                        listner()
                    }
                }
            })
        }
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.controller?.present(controller, animated: true, completion: {
        })        
    }
}
