//
//  AspectImageView.swift
//  GenGold
//
//  Created by Sumant Handa on 15/03/16.
//  Copyright © 2016 Mansa. All rights reserved.
//

import UIKit

class AspectImageView: ExtendedImageView {
    
    var signatureInfo = [BroadcastInfo]()
    var isDrawing = false
    
    var drawingLayer:CALayer?
    
    private var socketClient : SocketClient?
    private var socketListener : SocketListener?
    
    var currentPoint = CGPoint.zero
    var previousPoint = CGPoint.zero
    var previousPreviousPoint = CGPoint.zero
    
    static let kPointMinDistance : Double = 0.0
    static let kPointMinDistanceSquared : Double = kPointMinDistance * kPointMinDistance
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 7:5
    var opacity: CGFloat = 1.0
    
    var drawColor : UIColor?
    var touchStarted = false
    
    var canvasInfo : CanvasInfo?
    
    override var image : UIImage?{
        get{
            return super.image
        }
        set{
            super.image = newValue
        }
    }
    
    var size : CGSize{
        get{
            let size =  self.frame.size
            return size
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.isUserInteractionEnabled = true
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    fileprivate func initialization()
    {
        socketClient = SocketClient.sharedInstance
        socketListener = socketClient?.createListener()
        registerForAutographListener()
    }
    
    private func registerForAutographListener(){
        
        socketListener?.onEvent("broadcastPoints", completion: { [weak self] (json) in
            
            DispatchQueue.main.async {
                
                let rawInfo = json?["message"]
                Log.echo(key: "yud", text: "I am getting the user points \(String(describing: rawInfo))")
                let broadcastInfo = BroadcastInfo(info : rawInfo)
                self?.signatureInfo.append(broadcastInfo)
                if(broadcastInfo.reset){
                    
                    Log.echo(key: "processPoint", text: "asking to reset")
                    self?.signatureInfo.removeAll()
                    self?.touchStarted = false
                    self?.reset()
                    return
                }
                
                if !(self?.isDrawing ?? true){
                    self?.processPoint()
                }
            }
        })
        
        
        
    }
}

//MARK:- Points Handling from the backend
extension AspectImageView{
    
    private func targetPoint(inputPoint : CGPoint)->CGPoint{
        
        let selfWidth = size.width
        let selfHeight = size.height
        
        let targetWidth = CGFloat(canvasInfo?.width ?? Double(0))
        let targetHeight = CGFloat(canvasInfo?.height ?? Double(0))
        
        let widthRatio = selfWidth/targetWidth
        let heightRatio = selfHeight/targetHeight
        
        let x = widthRatio * inputPoint.x
        let y = heightRatio * inputPoint.y
        
        return CGPoint(x : x, y : y)
    }
    
    private func processPoint(){
        
        if signatureInfo.count == 0 {
            isDrawing = false
            return
        }
        isDrawing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(25)) {
            self.processPoint()
        }
        
        Log.echo(key: "processPoint", text: "Processing the points")
        
        guard let info = self.signatureInfo.first else{
            return
        }
        
        let rawColor = info.strokeColor ?? "#000"
        let color = UIColor(hexString : rawColor)
        self.drawColor = color
        
        
        let rawPoint = info.point
        let point = self.targetPoint(inputPoint: rawPoint)
        
        if(!info.isContinous && !self.touchStarted){
            
            Log.echo(key: "processPoint", text: "touch started")
            self.touchStarted = true
            self.currentPoint = point
            self.previousPoint = point
            self.previousPreviousPoint = point
            //drawBezier(from start: self.previousPoint, to end: self.currentPoint)
            self.signatureInfo.removeFirst()
            return
        }
        
        if(info.isContinous){
            
            Log.echo(key: "processPoint", text: "touch moving")
            self.previousPreviousPoint = self.previousPoint
            self.previousPoint = self.currentPoint
            self.currentPoint = point
            
//            let mid1 = self.midPoint(self.previousPoint, p2: self.previousPreviousPoint)
//            let mid2 = self.midPoint(self.currentPoint, p2: self.previousPoint)
//            self.drawBezier(from: self.previousPreviousPoint, to: self.currentPoint, previous: self.previousPoint)
            
            processMovedTouches(currentTouchPoint : self.currentPoint, lastTouchPoint : self.previousPoint)
            //drawBezier(from: self.previousPoint, to: self.currentPoint)
            self.touchStarted = true
            self.signatureInfo.removeFirst()
            return
        }
        
        if(!info.isContinous){
                        
            Log.echo(key: "processPoint", text: "touch ended")
            self.previousPreviousPoint = self.previousPoint
            self.previousPoint = self.currentPoint
            self.currentPoint = point
            
            self.drawBezier(from: self.previousPreviousPoint, to: self.currentPoint, previous: self.previousPoint)
            self.touchStarted = false
            self.signatureInfo.removeFirst()
            return
        }
    }
        
    private func processMovedTouches(currentTouchPoint : CGPoint, lastTouchPoint : CGPoint){
        
        let point = currentTouchPoint
        
        let dx = point.x - lastTouchPoint.x
        let dy = point.y - lastTouchPoint.y
        
        let total : Double = (Double(dx * dx) + Double(dy * dy))
        
        if (total < AspectImageView.kPointMinDistanceSquared) {
            
            // ... then ignore this movement
            return;
        }
        // update points: previousPrevious -> mid1 -> previous -> mid2 -> current
        Log.echo(key : "currentPoint", text : "currentPoint ==> \(self.currentPoint)")
        Log.echo(key : "previousPreviousPoint", text : "previousPreviousPoint ==> \(self.previousPreviousPoint)")
        
        let mid1 = midPoint(self.previousPoint, p2: self.previousPreviousPoint);
        let mid2 = midPoint(self.currentPoint, p2: self.previousPoint);
        //drawLineFrom(self.previousPoint, mid1: mid1, mid2: mid1)
        
        drawBezier(from: mid1, to: mid2, previous: self.previousPoint)
        //        drawLineFrom(previousPoint, mid1 : , toPoint: mid2)
    }
    
    func reset(){
        
        self.drawingLayer?.removeFromSuperlayer()
        self.layer.sublayers = nil
        self.drawingLayer?.sublayers = nil
        self.drawingLayer = nil
    }
    
    private func midPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint{
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
    
}


//MARK:- Drawing code with Bezier

extension AspectImageView{
    
    func setupDrawingLayerIfNeeded() {
        
        guard drawingLayer == nil else { return }
        let sublayer = CALayer()
        sublayer.contentsScale = 0.0
        layer.addSublayer(sublayer)
        drawingLayer = sublayer
    }
    
    func drawBezier(from start: CGPoint, to end: CGPoint) {
        
        setupDrawingLayerIfNeeded()
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        line.contentsScale = UIScreen.main.scale
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = self.drawColor?.cgColor
        line.opacity = 1
        line.lineWidth = brushWidth
        line.lineCap = .round
        line.strokeColor = self.drawColor?.cgColor
        drawingLayer?.addSublayer(line)
        if let count = drawingLayer?.sublayers?.count, count > 400 {
        }
    }
    
    func drawBezier(from start: CGPoint, to end: CGPoint,previous point:CGPoint) {
        
        setupDrawingLayerIfNeeded()
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        line.contentsScale = UIScreen.main.scale
        linePath.move(to: start)
        linePath.addQuadCurve(to: end, controlPoint: self.previousPoint)
        line.path = linePath.cgPath
        line.fillColor = UIColor.clear.cgColor
        line.opacity = 1
        line.lineWidth = brushWidth
        line.lineCap = .round
        line.strokeColor = self.drawColor?.cgColor
        self.drawingLayer?.addSublayer(line)
        
//        self.setupDrawingLayerIfNeeded()
//        let line = CAShapeLayer()
//        let linePath = UIBezierPath()
//        line.contentsScale = UIScreen.main.scale
//        linePath.move(to: start)
//        linePath.addQuadCurve(to: end, controlPoint: self.previousPoint)
//        line.path = linePath.cgPath
//        line.fillColor = UIColor.clear.cgColor
//        line.opacity = 1
//        line.lineWidth = self.brushWidth
//        line.lineCap = .round
//        line.strokeColor = self.drawColor?.cgColor
//        self.drawingLayer?.addSublayer(line)
//        if let count = self.drawingLayer?.sublayers?.count, count > 400 {
//        }
    }
    
    func clearSublayers() {
        
        drawingLayer?.sublayers = nil
        self.layer.sublayers = nil
        drawingLayer = nil
    }
    
    func clear() {
        
        clearSublayers()
        image = nil
    }
    
}

extension AspectImageView{
    
    func getSnapshot()->UIImage?{
        
        let bounds = self.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
