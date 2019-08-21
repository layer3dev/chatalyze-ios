//
//  CanvasHostContainer.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 14/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class CanvasHostContainer: ExtendedView {
    
    @IBOutlet var canvas : AutographyHostCanvas?
    @IBOutlet var canvasHeightZeroConstraint : NSLayoutConstraint?
    @IBOutlet var canvasProportionalHeightConstraint : NSLayoutConstraint?
    
    @IBOutlet var topConstraint:NSLayoutConstraint?
    @IBOutlet var trailingConstraint:NSLayoutConstraint?
    var delegate:AutographyCanvasProtocol?

    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    func initialization(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        canvas?.delegate = self
    }
    
    @objc func didRotate() {
        
        self.updateLayoutRotation()
    }
    
    func updateLayoutRotation() {
        
        if UIDevice.current.orientation.isPortrait {
            if UIDevice.current.userInterfaceIdiom == .phone {
                
                topConstraint?.constant = 144
                trailingConstraint?.constant = 0
                
                
            }else{
                
                topConstraint?.constant = 220
                trailingConstraint?.constant = 0
                
            }
            return
        }
        
        if UIDevice.current.orientation.isLandscape{
            if UIDevice.current.userInterfaceIdiom == .pad{
                
                topConstraint?.constant = 15
                trailingConstraint?.constant = 244
                
            }else{
                
                topConstraint?.constant = 15
                trailingConstraint?.constant = 148
            }
            return
        }
        return
    }
    
    
    func show(){
        
        layoutIfNeeded()
        showInPortrait()
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
    }
    
    private func showInPortrait(){
        
        canvasHeightZeroConstraint?.priority = UILayoutPriority(1.0)
        canvasProportionalHeightConstraint?.priority = UILayoutPriority(990.0)
    }
    
    private func hideCanvas(){
        
        canvasHeightZeroConstraint?.priority = UILayoutPriority(990.0)
        canvasProportionalHeightConstraint?.priority = UILayoutPriority(1.0)
    }
    
    func hide(){
        
        layoutIfNeeded()
        hideCanvas()
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Log.echo(key: "yud", text: "Canvas container height width is \(self.frame.size.width) and the canvas height is \(self.frame.size.height)")
        
    }
}

extension CanvasHostContainer : AutographyCanvasProtocol{
    
    func touchesBegan(withPoint point : CGPoint){
        delegate?.touchesBegan(withPoint: point)
//        broadcastCoordinate(withX: point.x, y: point.y, isContinous: false)
    }
    
    func touchesMoved(withPoint point : CGPoint){
        delegate?.touchesMoved(withPoint: point)
//        broadcastCoordinate(withX: point.x, y: point.y, isContinous: true)
    }
    
    func touchesEnded(withPoint point : CGPoint){
        delegate?.touchesEnded(withPoint: point)
//        broadcastCoordinate(withX: point.x, y: point.y, isContinous: false)
    }
    
//    fileprivate func broadcastCoordinate(withX x : CGFloat, y : CGFloat, isContinous : Bool, reset : Bool = false ){
//
//        var params = [String : Any]()
//
//        params["x"] = x
//        params["y"] = y
//
//        params["isContinous"] = isContinous
//        params["counter"] = counter
//        params["pressure"] = 1
//        params["reset"] = reset
//
//        //params["StrokeWidth"] = canvas?.brushWidth ?? 2.0
//
//        params["StrokeWidth"] = 11.0
//        params["StrokeColor"] = canvas?.color.hexString ?? "#000"
//        params["Erase"] = false
//        params["reset"] = reset
//
//        var mainParams  = [String : Any]()
//        mainParams["name"] = info?.userHashedId
//        mainParams["id"] = "broadcastPoints"
//        mainParams["message"] = params
//
//        counter = counter + 1;
//        socket?.emit(withData: mainParams)
//    }
}
