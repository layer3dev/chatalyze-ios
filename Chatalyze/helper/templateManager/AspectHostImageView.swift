//
//  AspectHostImageView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 14/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AspectHostImageView: UIImageView {
    
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
        self.drawingLayer = nil
    }
}

extension AspectHostImageView{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Log.echo(key: "point", text: "Touch is begun")
        
        guard let touch = touches.first
            else{
                return
        }
        
        self.currentPoint = touch.location(in: self)
        self.previousPoint = touch.previousLocation(in: self)
        self.previousPreviousPoint = touch.previousLocation(in: self)
        
        swiped = false
        getBeginPoint = true
        
        broadcastDelegate?.broadcastCoordinate(x: self.currentPoint.x, y: self.currentPoint.y, isContinous: false, reset: false)
       // self.touchesBegan(withPoint: currentPoint)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Log.echo(key: "point", text: "Touch is moving")

        guard let touch = touches.first
            else{
                return
        }
        
        let previousPoint = touch.previousLocation(in: self)
        
        self.previousPreviousPoint = self.previousPoint
        self.previousPoint = previousPoint
        self.currentPoint = touch.location(in: self)
        
        swiped = true
        
//        let x = AVMakeRect(aspectRatio: self.image?.size ?? CGSize.zero, insideRect: self.frame)
//        let point = touch.location(in: self)
//
        
//        if(!(x.contains(point))){
//
//            Log.echo(key: "point", text: "I am drawing outside")
//            let point = touch.location(in: self)
//            self.touchesEnded(withPoint: point)
//            return
//        }
        
        if getBeginPoint == false{

            self.currentPoint = touch.location(in: self)
            self.previousPoint = touch.previousLocation(in: self)
            self.previousPreviousPoint = touch.previousLocation(in: self)
            broadcastDelegate?.broadcastCoordinate(x: self.currentPoint.x, y: self.currentPoint.y, isContinous: false, reset: false)
            getBeginPoint = true
            return
        }
        
        let currentpoint = touch.location(in: self)
        broadcastDelegate?.broadcastCoordinate(x: currentpoint.x, y: currentpoint.y, isContinous: true, reset: false)
        
        let mid1 = midPoint(self.previousPoint, p2: self.previousPreviousPoint);
        let mid2 = midPoint(self.currentPoint, p2: self.previousPoint);
        drawBezier(from: mid1, to: mid2, previous: self.previousPoint)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first
            else{
                return
        }
        
//        let mainPoint = touch.location(in: self)
//        let x = AVMakeRect(aspectRatio: self.image?.size ?? CGSize.zero, insideRect: self.frame)
//
//        if(!(x.contains(mainPoint))){
//            Log.echo(key: "point", text: "I am not broadcasting")
//            return
//        }
        
        getBeginPoint = false
        //getEndPoint = true
        let point = touch.location(in: self)
        
        if swiped{
            broadcastDelegate?.broadcastCoordinate(x: point.x, y: point.y, isContinous: false, reset: false)
            return
        }
        
        Log.echo(key: "yud", text: "I draw the bezier path")
        let mid1 = midPoint(self.previousPoint, p2: self.previousPreviousPoint);
        let mid2 = midPoint(self.currentPoint, p2: self.previousPoint);
        drawBezier(from: mid1, to: mid2, previous: self.previousPoint)
        broadcastDelegate?.broadcastCoordinate(x: point.x, y: point.y, isContinous: false, reset: false)
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
        line.fillColor = strokeColor.cgColor
        line.opacity = 1
        line.lineWidth = brushWidth
        line.lineCap = .round
        line.strokeColor = strokeColor.cgColor
        drawingLayer?.addSublayer(line)
        if let count = drawingLayer?.sublayers?.count, count > 400 {
        }
    }
    
    
    func clearSublayers() {
        
        drawingLayer?.removeFromSuperlayer()
        drawingLayer = nil
    }
    
    func clear() {
        
        clearSublayers()
        image = nil
    }
    
   
}

extension AspectHostImageView{
    
    private func midPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint{
        
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
}
