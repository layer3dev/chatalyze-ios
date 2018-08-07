//
//  VideoRootView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class VideoRootView: ExtendedView {
    

    
    @IBOutlet var actionContainer : VideoActionContainer?
    @IBOutlet var localVideoView : LocalVideoView?
    
    @IBOutlet var remoteVideoContainerView :  RemoteVideoContainerView?
    
    var remoteVideoView : RemoteVideoView?{
        get{
            return remoteVideoContainerView?.remoteVideoView
        }
    }
    
    
    private var hangupListener : (()->())?
    
    private var loadListener : (()->())?
    
    
    var callOverlayView : CallOverlayView?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func confirmViewLoad(listener : (()->())?){
        self.loadListener = listener
        if(isLoaded){
            listener?()
            return
        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
        self.loadListener?()
    }
    
    private func initialization(){
        initializeVariable()
        paintInterface()
        addToogleGesture()
    }
    
    private func initializeVariable(){
        callOverlayView = CallOverlayView()
    }
    
    private func paintInterface(){
//        paintOverlay()
//        self.actionContainer?.isHidden = true
    }
    
    private func paintOverlay(){
        guard let callOverlayView = self.callOverlayView
            else{
                return
        }
        self.addSubview(callOverlayView)
        self.addConstraints(childView: callOverlayView)
        callOverlayView.isHidden = true
        callOverlayView.hangupListener {
            self.hangupListener?()
        }
    }
    
    func switchToCallRequest(){
        callOverlayView?.isHidden = false
        actionContainer?.isHidden = true
    }
    
    func switchToCallAccept(){
        callOverlayView?.isHidden = true
        actionContainer?.isHidden = false
    }
    
    func addToogleGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleContainer(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    func hangupListener(listener : (()->())?){
        self.hangupListener = listener
    }
    
    
    @objc func toggleContainer(gesture: UITapGestureRecognizer){
        actionContainer?.toggleContainer()
    }
    
   
    
    

}
