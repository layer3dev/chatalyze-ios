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
        
        self.controller?.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func skipAction(sender:UIButton){
                
        guard let controller = EventPaymentController.instance() else{
            return
        }
        self.controller?.present(controller, animated: true, completion: {
        })
    }
}


