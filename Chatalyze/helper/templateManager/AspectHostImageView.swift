//
//  AspectHostImageView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 14/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AspectHostImageView: ExtendedImageView {
    
    var pointsProcessor = AutographDigestProcessor()
    
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
        
        let info = SignatureCoordinatesInfo(point: CGPoint.zero, isContinous: false, isReset: true)
    
        pointsProcessor.digest(pointInfo: info)
        self.drawingLayer?.removeFromSuperlayer()
        self.layer.sublayers = nil
        self.drawingLayer?.sublayers = nil
        self.drawingLayer = nil
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        pointsProcessor.setDigestListener { (startingPoint, endPoint,controlPoint, isReset) in
            
            self.drawBezier(from: startingPoint, to: endPoint, previous: controlPoint)
        }
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
    
        
//        let info = SignatureCoordinatesInfo(point: self.currentPoint, isContinous: false, isReset: false)
//
//        pointsProcessor.digest(pointInfo: info)
      
        
        self.broadcastDelegate?.broadcastCoordinate(x: self.currentPoint.x, y: self.currentPoint.y, isContinous: false, reset: false)
        
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
        
        let currentpoint = touch.location(in: self)
        self.broadcastDelegate?.broadcastCoordinate(x: currentpoint.x, y: currentpoint.y, isContinous: true, reset: false)
        
//        let info = SignatureCoordinatesInfo(point: self.currentPoint, isContinous: true, isReset: false)
//        pointsProcessor.digest(pointInfo: info)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first
            else{
                return
        }
        
        self.getBeginPoint = false
        let point = touch.location(in: self)
        
        if self.swiped{
            
//             let info = SignatureCoordinatesInfo(point: self.currentPoint, isContinous: false, isReset: false)
//            pointsProcessor.digest(pointInfo: info)


            self.broadcastDelegate?.broadcastCoordinate(x: point.x, y: point.y, isContinous: false, reset: false)
            return
        }
        
//        let info = SignatureCoordinatesInfo(point: self.currentPoint, isContinous: false, isReset: false)
//
//        pointsProcessor.digest(pointInfo: info)

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

//MARK:- Draw methods

extension AspectImageView{
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    func calculateRectBetween(lastPoint: CGPoint, newPoint: CGPoint) -> CGRect {
        
        let originX = min(lastPoint.x, newPoint.x) - (brushWidth / 2)
        let originY = min(lastPoint.y, newPoint.y) - (brushWidth / 2)
        
        let maxX = max(lastPoint.x, newPoint.x) + (brushWidth / 2)
        let maxY = max(lastPoint.y, newPoint.y) + (brushWidth / 2)
        
        let width = maxX - originX
        let height = maxY - originY
        
        return CGRect(x: originX, y: originY, width: width, height: height)
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
        
//        let renderer = UIGraphicsImageRenderer(size: bounds.size)
//
//        image = renderer.image { ctx in
//            image?.draw(in: bounds)
//
//            ctx.cgContext.setLineCap(.round)
//            ctx.cgContext.setLineWidth(brushWidth)
//            ctx.cgContext.move(to: CGPoint(x: start.x, y: start.y))
//            ctx.cgContext.addQuadCurve(to: end, control: self.previousPoint)
//            ctx.cgContext.strokePath()
//        }
        
        
        setupDrawingLayerIfNeeded()
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        line.contentsScale = 0.0
        linePath.move(to: CGPoint(x: start.x, y: start.y))
        linePath.addQuadCurve(to: end, controlPoint: point)
        line.path = linePath.cgPath
        line.fillColor = UIColor.clear.cgColor
        line.opacity = 1
        line.lineWidth = brushWidth
        line.lineCap = .round
        line.strokeColor = strokeColor.cgColor

        self.drawingLayer?.addSublayer(line)
        if let count = self.drawingLayer?.sublayers?.count, count > 400 {
        }
        
    }
}

extension AspectHostImageView{
    
    private func midPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint{
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
}


extension AspectHostImageView{
    
    func drawBezier(from start: CGPoint, to end: CGPoint) {
        
//        let renderer = UIGraphicsImageRenderer(size: bounds.size)
//
//        image = renderer.image { ctx in
//            image?.draw(in: bounds)
//
//            ctx.cgContext.setLineCap(.round)
//            ctx.cgContext.setLineWidth(brushWidth)
//            ctx.cgContext.move(to: start)
//            ctx.cgContext.addQuadCurve(to: end, control: start)
//            ctx.cgContext.strokePath()
//        }
        
        setupDrawingLayerIfNeeded()
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        line.contentsScale = UIScreen.main.scale
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = UIColor.red.cgColor
        line.opacity = 1
        line.lineWidth = brushWidth
        line.lineCap = .round
        line.strokeColor = UIColor.red.cgColor
        drawingLayer?.addSublayer(line)
        if let count = drawingLayer?.sublayers?.count, count > 400 {
        }
    }
    
}
