//
//  AspectHostImageView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 14/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AspectHostImageView: ExtendedView {
    
    var linePath = UIBezierPath()
    var resetCounter = 25
    var isTouchStarted = false
    var isSwiped = false
    
    @IBOutlet private var mainImage:UIImageView?
    
    @IBOutlet var blurImageView:UIView?
    
    var _image:UIImage?
    
    var sigCoordinates = [SignatureCoordinatesInfo](){
        didSet{
            //resetCounter = resetCounter + 1
            print("increasing count \(resetCounter) and s\(self.sigCoordinates.count)")
        }
    }
    
    var sublayers: [CALayer] {
        return self.layer.sublayers ?? [CALayer]()
    }
    
    //Drawing Accessory tools
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 8:6
    var opacity: CGFloat = 1.0
    //End
    
    var broadcastDelegate:broadcastCoordinatesImageDelegate?
    var drawingLayer:CAShapeLayer?
    
    var currentPoint = CGPoint.zero
    var previousPoint = CGPoint.zero
    var previousPreviousPoint = CGPoint.zero
    
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
    
    var image : UIImage?{
        
        get{
            return _image
        }
        set{
            _image = newValue
            mainImage?.image = _image
        }
    }
    
    
    
    override func viewDidLayout() {
        self.isUserInteractionEnabled = true
    }
    
    //MARK:- Resetting the canvas
    
    func reset(){
        
        emptyFlattenedLayers()
        self.linePath = UIBezierPath()
    }
}

//MARK:- Touches Methods

extension AspectHostImageView{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        DispatchQueue.main.async {
            
            print("touch start")
            guard  let touch = touches.first else {
                return
            }
            let point = touch.location(in: self)
            if !self.frame.contains(point){
                print("returning back in the start")
                
                return
            }
            let info = SignatureCoordinatesInfo(point: point, isContinous: false, isReset: false)
            
            self.sigCoordinates.append(info)
            
            let rect = self.calculateRectBetween(lastPoint: point, newPoint: point)
            
            self.broadcastDelegate?.broadcastCoordinate(x: point.x, y: point.y, isContinous: false, reset: false)
            
            self.layer.setNeedsDisplay(rect)
            self.resetCounter = self.resetCounter + 1
        }
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        DispatchQueue.main.async {
            
            guard let touch = touches.first
                else{
                    return
            }
            
            let cp = touch.location(in: self)
            
            let info = SignatureCoordinatesInfo(point: cp, isContinous: true, isReset: false)
            
            let lastTouchPoint = self.sigCoordinates.last
            
            let rect = self.calculateRectBetween(lastPoint: lastTouchPoint?.point ?? CGPoint.zero, newPoint: cp)
            
            //            if !self.frame.contains(cp){
            //                print("returning back in the start")
            //                self.flattenImage()
            //                return
            //            }
            
            self.broadcastDelegate?.broadcastCoordinate(x: cp.x, y: cp.y, isContinous: true, reset: false)
            self.sigCoordinates.append(info)
            self.layer.setNeedsDisplay(rect)
            
            self.resetCounter = self.resetCounter + 1
            
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        DispatchQueue.main.async {
            
            print("touch end")
            
            guard  let touch = touches.first else {
                return
            }
            
            let point = touch.location(in: self)
            
            if !self.frame.contains(point){
                
                print("returning back in the end")
                return
            }
            let lastTouchPoint = self.sigCoordinates.last
            
            let rect = self.calculateRectBetween(lastPoint: lastTouchPoint?.point ?? CGPoint.zero, newPoint: point)
            
            self.layer.setNeedsDisplay(rect)
            
            //self.flattenImage()
            
            let info = SignatureCoordinatesInfo(point: point, isContinous: false, isReset: false)
            
            self.sigCoordinates.append(info)
            
            self.broadcastDelegate?.broadcastCoordinate(x: point.x, y: point.y, isContinous: false, reset: false)
            
            self.resetCounter = self.resetCounter + 1
            
        }
        
        
    }
    
}




extension AspectHostImageView{
    
    private func midPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint{
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
}


extension AspectHostImageView{
    
    func flattenToImage() {
        
        //mainImage?.image = getSnapshot()
        
        updateFlattenedLayer()
        sigCoordinates.removeAll()
    }
    
    func emptyFlattenedLayers() {
        
        for case let layer as CAShapeLayer in sublayers {
            layer.removeFromSuperlayer()
            self.drawingLayer = nil
        }
    }
    
}

//MARK:- finding the small rect && Flattening helper

extension AspectHostImageView{
    
    func calculateRectBetween(lastPoint: CGPoint, newPoint: CGPoint) -> CGRect {
        
        let originX = min(lastPoint.x, newPoint.x) - (brushWidth / 2)
        let originY = min(lastPoint.y, newPoint.y) - (brushWidth / 2)
        
        let maxX = max(lastPoint.x, newPoint.x) + (brushWidth / 2)
        let maxY = max(lastPoint.y, newPoint.y) + (brushWidth / 2)
        
        let width = maxX - originX
        let height = maxY - originY
        
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    
    func checkIfTooManyPoints() {
        
        let maxPoints = 25
        
        if sigCoordinates.count > maxPoints {
            
            print(" i got maximum points ")
            updateFlattenedLayer()
            
            // we leave two points to ensure no gaps or sharp angles
            _ = sigCoordinates.removeFirst(maxPoints - 2)
        }
    }
    
    func flattenImage() {
        
        updateFlattenedLayer()
    }
    
    func updateFlattenedLayer() {
        
        
        //layer.addSublayer(drawingLayer ?? CAShapeLayer())
        
        
        //     1
        
        guard let drawingLayer = drawingLayer,
            // 2
            
            let optionalDrawing = try? NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: drawingLayer)) as? CAShapeLayer  else { return }
        
        //            let optionalDrawing = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
        //                NSKeyedArchiver.archivedData(withRootObject: drawingLayer))
        //                as? CAShapeLayer  else { return }
        
        guard let drawlayer = optionalDrawing else{
            return
        }
        // NSKeyedArchiver.archivedData(withRootObject: <#T##Any#>)
        
        layer.addSublayer(drawlayer)
        
        
    }
    
    //MARK:- overriding draw layer
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
        
        print("incoming coordinates are \(self.sigCoordinates.count)")
        
        DispatchQueue.main.async {
            
            let drawingLayer = self.drawingLayer ?? CAShapeLayer()
            drawingLayer.contentsScale = UIScreen.main.scale
            
            for (index, point) in self.sigCoordinates.enumerated() {
                
                if !self.frame.contains(point.point){
                    
                    self.currentPoint = point.point
                    self.previousPoint = self.currentPoint
                    self.previousPreviousPoint = self.currentPoint
                    self.isTouchStarted = false
                    let mid = self.midPoint(self.previousPreviousPoint, p2: self.previousPoint)
                    self.linePath.move(to: mid)
                    continue
                }
                
                if !point.isContinuos && !self.isTouchStarted{
                    
                    print("point start")
                    
                    self.currentPoint = point.point
                    self.previousPoint = self.currentPoint
                    self.previousPreviousPoint = self.currentPoint
                    self.isTouchStarted = true
                    let mid = self.midPoint(self.previousPreviousPoint, p2: self.previousPoint)
                    
                    self.linePath.move(to: mid)
                    continue
                }
                
                if point.isContinuos{
                    
                    if !self.isTouchStarted{
                        
                        self.currentPoint = point.point
                        self.previousPoint = self.currentPoint
                        self.previousPreviousPoint = self.currentPoint
                        self.isTouchStarted = true
                        let mid = self.midPoint(self.previousPreviousPoint, p2: self.previousPoint)
                        
                        self.linePath.move(to: mid)
                        continue
                        
                        //coming from outside to inside continuos
                    }
                    
                    
                    print("point continuos")
                    
                    self.currentPoint = point.point
                    self.previousPoint = self.currentPoint
                    self.previousPreviousPoint = self.currentPoint
                    self.isTouchStarted = true
                    let mid = self.midPoint(self.currentPoint, p2: self.previousPoint)
                    self.isSwiped = true
                    
                    self.linePath.addQuadCurve(to: self.currentPoint, controlPoint: mid)
                    continue
                }
                
                if !point.isContinuos{
                    
                    print("point end")
                    self.isTouchStarted = false
                    self.isSwiped = false
                    
                    if !(self.isSwiped){
                        
                        
                        self.currentPoint = point.point
                        self.previousPoint = self.currentPoint
                        self.previousPreviousPoint = self.currentPoint
                        let mid = self.midPoint(self.currentPoint, p2: self.previousPoint)
                        self.linePath.addQuadCurve(to: self.currentPoint, controlPoint: mid)
                        self.isTouchStarted = false
                    }
                    
                    
                    self.flattenImage()
                    self.linePath = UIBezierPath()
                    self.resetCounter = 0
                    
                }
                
                
                //            if index == 0 {
                //
                //                self.currentPoint = point.point
                //                self.previousPoint = self.currentPoint
                //                self.previousPreviousPoint = self.currentPoint
                //
                //                self.linePath.move(to: self.currentPoint)
                //
                //            } else {
                //
                //
                //                self.previousPreviousPoint = self.previousPoint
                //                self.previousPoint = self.currentPoint
                //                self.currentPoint = point.point
                //
                //                let mid2 = self.midPoint(self.previousPoint, p2: self.currentPoint)
                //
                //                self.linePath.addQuadCurve(to: self.currentPoint, controlPoint: mid2)
                //            }
                
            }
            
            drawingLayer.path = self.linePath.cgPath
            drawingLayer.opacity = 1
            drawingLayer.lineWidth = self.brushWidth
            drawingLayer.lineCap = .round
            drawingLayer.lineJoin = .round
            drawingLayer.fillColor = UIColor.clear.cgColor
            drawingLayer.strokeColor = self.strokeColor.cgColor
            
            self.sigCoordinates.removeAll()
            
            if self.drawingLayer == nil {
                self.drawingLayer = drawingLayer
                layer.addSublayer(drawingLayer)
            }
            
            if self.resetCounter > 10{
                
                self.flattenImage()
                self.linePath = UIBezierPath()
                self.resetCounter = 0
                let mid = self.midPoint(self.currentPoint, p2: self.previousPoint)
                
                self.linePath.move(to: mid)
                
            }
        }
    }
}


//MARK:- Draw methods

extension AspectImageView{
    
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

//extension AspectHostImageView{
//
//    func getSnapshot()->UIImage?{
//
//        let bounds = self.bounds
//        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
//        self.drawHierarchy(in: bounds, afterScreenUpdates: true)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//
//    var scale:CGFloat{
//        return UIScreen.main.scale
//    }
//}
