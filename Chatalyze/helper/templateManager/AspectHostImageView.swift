//
//  AspectHostImageView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 14/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AspectHostImageView: ExtendedImageView {
    
    var cp = CGPoint.zero
    var lp = CGPoint.zero
    var ppp = CGPoint.zero
    
    var sigTimer:Timer?
    var isLoopStarted = false
    
    var sigCoordinates = [SignatureCoordinatesInfo]()
    
    //Drawing Accessory tools
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 8:6
    var opacity: CGFloat = 1.0
    //End
    
    var broadcastDelegate:broadcastCoordinatesImageDelegate?
    var drawingLayer:CALayer?
    
    var currentPoint = CGPoint.zero
    var previousPoint = CGPoint.zero
    var previousPreviousPoint = CGPoint.zero
    
    var swiped = false
    var getBeginPoint = false
    
    var heightConstraint : NSLayoutConstraint?
    var widthConstraint : NSLayoutConstraint?
    
    func updateStrokeColors(r:CGFloat,g:CGFloat,b:CGFloat,opacity:CGFloat){
        
        red = r
        green = g
        blue = b
        self.opacity = opacity
    }
    
    var strokeColor : UIColor{
        
        get{
            return UIColor(red: red, green: green, blue: blue, alpha: opacity)
        }
    }
    
    override var image : UIImage?{
        get{
            return super.image
        }
        set{
            super.image = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.isUserInteractionEnabled = true
    }
    
    func reset(){
        
        self.drawingLayer?.removeFromSuperlayer()
        self.layer.sublayers = nil
        self.drawingLayer?.sublayers = nil
        self.drawingLayer = nil
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        sigTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true)
        sigTimer?.fire()
    }
    
    @objc func timerRun(){
        
        // startSigning()
    }
    
    
}

extension AspectHostImageView{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first
            else{
                return
        }
        
        self.currentPoint = touch.location(in: self)
        self.previousPoint = touch.previousLocation(in: self)
        self.previousPreviousPoint = touch.previousLocation(in: self)
        
        self.swiped = false
        self.getBeginPoint = true
        
        let info = SignatureCoordinatesInfo(currentPoint: self.currentPoint, previousPoint: self.previousPoint, previousPreviousPoint: self.previousPreviousPoint, isSwiped: false, getBeginPoint: true, status: -1)
        
        self.sigCoordinates.append(info)
        
        if !isLoopStarted{
            Log.echo(key: "yud", text: "I called the loop")
            self.startSigning()
        }
        self.broadcastDelegate?.broadcastCoordinate(x: self.currentPoint.x, y: self.currentPoint.y, isContinous: false, reset: false)
        //startSigning()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        guard let touch = touches.first
            else{
                return
        }
        
        let previousPoint = touch.previousLocation(in: self)
        self.previousPreviousPoint = self.previousPoint
        self.previousPoint = previousPoint
        self.currentPoint = touch.location(in: self)
        
        
        self.swiped = true
        
        
        //        if self.getBeginPoint == false{
        //
        //            self.currentPoint = touch.location(in: self)
        //            self.previousPoint = touch.previousLocation(in: self)
        //            self.previousPreviousPoint = touch.previousLocation(in: self)
        //            self.broadcastDelegate?.broadcastCoordinate(x: self.currentPoint.x, y: self.currentPoint.y, isContinous: false, reset: false)
        //            self.getBeginPoint = true
        //            return
        //        }
        
        let currentpoint = touch.location(in: self)
        self.broadcastDelegate?.broadcastCoordinate(x: currentpoint.x, y: currentpoint.y, isContinous: true, reset: false)
        
        
        let info = SignatureCoordinatesInfo(currentPoint: self.currentPoint, previousPoint: self.previousPoint, previousPreviousPoint: self.previousPreviousPoint, isSwiped: false, getBeginPoint: true, status: 0)
        
        self.sigCoordinates.append(info)
        // startSigning()
        
        
        //        let mid1 = self.midPoint(self.previousPoint, p2: self.previousPreviousPoint);
        //        let mid2 = self.midPoint(self.currentPoint, p2: self.previousPoint);
        //
        //        self.drawBezier(from: mid1, to: mid2, previous: self.previousPoint)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first
            else{
                return
        }
        
        
        self.getBeginPoint = false
        let point = touch.location(in: self)
        
        if self.swiped{
            self.broadcastDelegate?.broadcastCoordinate(x: point.x, y: point.y, isContinous: false, reset: false)
            return
        }
        
        let info = SignatureCoordinatesInfo(currentPoint: self.currentPoint, previousPoint: self.previousPoint, previousPreviousPoint: self.previousPreviousPoint, isSwiped: false, getBeginPoint: true, status: 1)
        
        self.sigCoordinates.append(info)
        
        // startSigning()
        // let mid1 = self.midPoint(self.previousPoint, p2: self.previousPreviousPoint)
        // let mid2 = self.midPoint(self.currentPoint, p2: self.previousPoint);
        // self.drawBezier(from: mid1, to: mid2, previous: self.previousPoint)
        
        self.broadcastDelegate?.broadcastCoordinate(x: point.x, y: point.y, isContinous: false, reset: false)
        
    }
    
    private func processMovedTouches(currentTouchPoint : CGPoint, lastTouchPoint : CGPoint){
        
        let point = currentTouchPoint
        
        let dx = point.x - lastTouchPoint.x
        let dy = point.y - lastTouchPoint.y
        
        let total : Double = (Double(dx * dx) + Double(dy * dy))
        
        if (total < AspectImageView.kPointMinDistanceSquared) {
            
            return;
        }
        Log.echo(key : "currentPoint", text : "currentPoint ==> \(self.currentPoint)")
        Log.echo(key : "previousPreviousPoint", text : "previousPreviousPoint ==> \(self.previousPreviousPoint)")
        
        let mid1 = midPoint(self.previousPoint, p2: self.previousPreviousPoint);
        let mid2 = midPoint(self.currentPoint, p2: self.previousPoint);
        
        drawBezier(from: mid1, to: mid2, previous: self.currentPoint)
    }
    
}


extension AspectHostImageView{
    
    func setupDrawingLayerIfNeeded() {
        
        guard drawingLayer == nil else { return }
        let sublayer = CALayer()
        sublayer.contentsScale = 0.0
        layer.addSublayer(sublayer)
        drawingLayer = sublayer
    }
    
    func drawBezier(from start: CGPoint, to end: CGPoint,previous point:CGPoint) {
        
        
        
        setupDrawingLayerIfNeeded()
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        line.contentsScale = 0.0
        linePath.move(to: CGPoint(x: start.x, y: start.y))
        linePath.addQuadCurve(to: end, controlPoint: self.previousPoint)
        line.path = linePath.cgPath
        line.fillColor = UIColor.clear.cgColor
        line.opacity = 1
        line.lineWidth = brushWidth
        line.lineCap = .round
        line.strokeColor = strokeColor.cgColor
        
        DispatchQueue.main.async {
            self.drawingLayer?.addSublayer(line)
            if let count = self.drawingLayer?.sublayers?.count, count > 400 {
            }
        }
        
    }    
}

extension AspectHostImageView{
    
    private func midPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint{
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
}


extension AspectHostImageView{
    
    @IBAction func startSigning(){
        
        Log.echo(key: "yud", text: "count is \(self.sigCoordinates.count)")
        
        let accumulatedPoints = [SignatureCoordinatesInfo]()
        
        if self.sigCoordinates.count == 0 {
            Log.echo(key: "yud", text: "I am in returning function")
            isLoopStarted = false
            return
        }
        
        isLoopStarted = true
        
        let firstCoord = self.sigCoordinates.first
        
        if firstCoord?.status == -1{
            
            Log.echo(key: "yud", text: "I am in first function")
            
            cp = firstCoord?.currentPoint ?? CGPoint.zero
            self.sigCoordinates.removeFirst()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(25)) {
                self.startSigning()
            }
            return
        }
        
        if firstCoord?.status == 0 {
            
            let mid1 = self.midPoint(firstCoord?.previousPoint ?? CGPoint.zero, p2: firstCoord?.previousPreviousPoint ?? CGPoint.zero)
            let mid2 = self.midPoint(firstCoord?.currentPoint ?? CGPoint.zero, p2: firstCoord?.previousPoint ?? CGPoint.zero);
            
            lp = cp
            cp = firstCoord?.currentPoint ?? CGPoint.zero
            
            //self.drawBezier(from: mid1, to: mid2, previous: firstCoord?.previousPoint ?? CGPoint.zero)
            
            self.drawBezier(from: lp, to: cp)
            Log.echo(key: "yud", text: "signing")
            Log.echo(key: "yud", text: "I am in second function")
            
            self.sigCoordinates.removeFirst()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(25)) {
                self.startSigning()
            }
            return
        }
        
        if firstCoord?.status == 1{
            
            if firstCoord?.isSwiped == false{
                
                let mid1 = self.midPoint(firstCoord?.previousPoint ?? CGPoint.zero, p2: firstCoord?.previousPreviousPoint ?? CGPoint.zero)
                let mid2 = self.midPoint(firstCoord?.currentPoint ?? CGPoint.zero, p2: firstCoord?.previousPoint ?? CGPoint.zero)
                
                lp = cp
                cp = firstCoord?.currentPoint ?? CGPoint.zero
                self.drawBezier(from: lp, to: cp)
            }
            self.sigCoordinates.removeFirst()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(25)) {
                self.startSigning()
            }
            return
        }
    }
    
    func drawBezier(from start: CGPoint, to end: CGPoint) {
        
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        
        image = renderer.image { ctx in
            image?.draw(in: bounds)
            
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setLineWidth(brushWidth)
            ctx.cgContext.move(to: start)
            ctx.cgContext.addQuadCurve(to: end, control: start)
            ctx.cgContext.strokePath()
        }
        
//        setupDrawingLayerIfNeeded()
//        let line = CAShapeLayer()
//        let linePath = UIBezierPath()
//        line.contentsScale = UIScreen.main.scale
//        linePath.move(to: start)
//        linePath.addLine(to: end)
//        line.path = linePath.cgPath
//        line.fillColor = UIColor.red.cgColor
//        line.opacity = 1
//        line.lineWidth = brushWidth
//        line.lineCap = .round
//        line.strokeColor = UIColor.red.cgColor
//        drawingLayer?.addSublayer(line)
//        if let count = drawingLayer?.sublayers?.count, count > 400 {
//        }
    }
    
}
