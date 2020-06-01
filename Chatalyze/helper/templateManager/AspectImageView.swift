//
//  AspectImageView.swift
//  GenGold
//
//  Created by Sumant Handa on 15/03/16.
//  Copyright © 2016 Mansa. All rights reserved.
//

import UIKit

class AspectImageView: ExtendedView {
    
    var sublayers: [CALayer] {
        return self.layer.sublayers ?? [CALayer]()
    }
    
    var cp = CGPoint.zero
    var pp = CGPoint.zero
    var ppp = CGPoint.zero
    
    var linePath = UIBezierPath()
    var resetCounter = 25
    var isTouchStarted = false
    var isSwiped = false
    
    @IBOutlet var mainImage:UIImageView?
    var _image:UIImage?
    
    var sigCoordinates = [BroadcastInfo]()
    var isDrawing = false
    
    var drawingLayer:CAShapeLayer?
    
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
    
    var strokeColor:UIColor?
    
    var drawColor : UIColor?
    var touchStarted = false
    
    var canvasInfo : CanvasInfo?
    
    var image : UIImage?{
        
        get{
            return _image
        }
        set{
            _image = newValue
            self.mainImage?.image = _image
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
            
            let rawInfo = json?["message"]
            Log.echo(key: "yud", text: "I am getting the user points \(String(describing: rawInfo))")
            
            let broadcastInfo = BroadcastInfo(info : rawInfo)
            
            self?.ppp = self?.pp ?? CGPoint.zero
            self?.pp = self?.cp ?? CGPoint.zero
            self?.cp = self?.targetPoint(inputPoint: broadcastInfo.point) ?? CGPoint.zero
            
            let newRect = self?.calculateRectBetween(lastPoint: self?.pp ?? CGPoint.zero, newPoint: self?.cp ?? CGPoint.zero)
            
            self?.sigCoordinates.append(broadcastInfo)
            if(broadcastInfo.reset){
                
                Log.echo(key: "processPoint", text: "asking to reset")
                self?.sigCoordinates.removeAll()
                self?.reset()
                return
            }
            
            Log.echo(key: "yud", text: "I am getting the user points \(String(describing: rawInfo))")
            
            self?.layer.setNeedsDisplay(newRect ?? self?.frame ?? CGRect.zero)
        })
    }
}


//MARK:- Helper Drawing methods

extension AspectImageView{
    
    func reset(){
        
        emptyFlattenedLayers()
        self.linePath = UIBezierPath()
        self.isTouchStarted = false
        self.isSwiped = false
        self.resetCounter = 0
    }
    
    private func midPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint{
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
    
    func emptyFlattenedLayers() {
        
        for case let layer as CAShapeLayer in sublayers {
            layer.removeFromSuperlayer()
            self.drawingLayer = nil
        }
    }
    
    func flattenImage() {
        
        updateFlattenedLayer()
    }
    
    func updateFlattenedLayer() {
        
        guard let drawingLayer = drawingLayer,
            
            let optionalDrawing = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: drawingLayer)) as? CAShapeLayer else { return }
        
        layer.addSublayer(optionalDrawing)
    }
    
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
        
        let drawingLayer = self.drawingLayer ?? CAShapeLayer()
        drawingLayer.contentsScale = UIScreen.main.scale
        
        self.resetCounter = self.resetCounter + 1
        
        for (_, point) in self.sigCoordinates.enumerated() {
            
            if let rawColor = point.strokeColor{
            
                self.strokeColor = UIColor(hexString: rawColor)
            }
            
            let targetPoint = self.targetPoint(inputPoint: point.point)

            if !point.isContinous && !self.isTouchStarted{
                
                self.currentPoint = targetPoint
                self.previousPoint = self.currentPoint
                self.previousPreviousPoint = self.currentPoint
                self.isTouchStarted = true
                self.isSwiped = false
                continue
            }
            
            if point.isContinous{
                
                if !self.isTouchStarted{
                    
                    self.currentPoint = targetPoint
                    self.previousPoint = self.currentPoint
                    self.previousPreviousPoint = self.currentPoint
                    self.isTouchStarted = true
                    self.isSwiped = false
                    continue
                }
                
                self.previousPreviousPoint = self.previousPoint
                self.previousPoint = self.currentPoint
                self.currentPoint = targetPoint
                self.isTouchStarted = true
                
                let mid1 = self.midPoint(self.previousPreviousPoint, p2: self.previousPoint)
                let mid2 = self.midPoint(self.currentPoint, p2: self.previousPoint)
                
                self.isSwiped = true
                
                let newPath = UIBezierPath()
                newPath.move(to: mid1)
                newPath.addQuadCurve(to: mid2, controlPoint: self.previousPoint)
                self.linePath.append(newPath)
                continue
            }
            
            if !point.isContinous{
                
                if !(self.isSwiped){
                
                self.previousPreviousPoint =  self.previousPoint
                self.previousPoint = self.currentPoint
                self.currentPoint = targetPoint
                
                let mid1 = self.midPoint(self.currentPoint, p2: self.currentPoint)
                let mid2 = self.midPoint(self.currentPoint, p2: self.currentPoint)
                
                self.linePath.move(to: mid1)
                self.linePath.addQuadCurve(to: mid2, controlPoint: self.currentPoint)
                drawingLayer.path = self.linePath.cgPath
                drawingLayer.opacity = 1
                drawingLayer.lineWidth = self.brushWidth
                drawingLayer.lineCap = .round
                drawingLayer.lineJoin = .round
                drawingLayer.fillColor = UIColor.clear.cgColor
                drawingLayer.strokeColor = self.strokeColor?.cgColor
                    
                }else{
                    
                    self.previousPreviousPoint =  self.previousPoint
                    self.previousPoint = self.currentPoint
                    self.currentPoint = targetPoint
                    
                    let mid1 = self.midPoint(self.previousPreviousPoint, p2: self.previousPoint)
                    let mid2 = self.midPoint(self.currentPoint, p2: self.previousPoint)
                    
                    self.linePath.move(to: mid1)
                    self.linePath.addQuadCurve(to: mid2, controlPoint: self.previousPoint)
                    drawingLayer.path = self.linePath.cgPath
                    drawingLayer.opacity = 1
                    drawingLayer.lineWidth = self.brushWidth
                    drawingLayer.lineCap = .round
                    drawingLayer.lineJoin = .round
                    drawingLayer.fillColor = UIColor.clear.cgColor
                    drawingLayer.strokeColor = self.strokeColor?.cgColor
                }
            
                self.isTouchStarted = false
                self.isSwiped = false
                self.flattenImage()
                self.linePath = UIBezierPath()
                self.resetCounter = 0
            }
        }
        
        drawingLayer.path = self.linePath.cgPath
        drawingLayer.opacity = 1
        drawingLayer.lineWidth = self.brushWidth
        drawingLayer.lineCap = .round
        drawingLayer.lineJoin = .round
        drawingLayer.fillColor = UIColor.clear.cgColor
        drawingLayer.strokeColor = self.strokeColor?.cgColor

        self.sigCoordinates.removeAll()

        if self.drawingLayer == nil {
            
            self.drawingLayer = drawingLayer
            layer.addSublayer(drawingLayer)
        }
        
        if self.resetCounter > 5{
            
            self.flattenImage()
            self.linePath = UIBezierPath()
            self.resetCounter = 0
        }
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
}


//MARK:- taking the snapshot
extension AspectImageView{
    
    func getSnapshot()->UIImage?{
        
        let bounds = self.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    func modify(){
        
        guard getSnapshot() != nil else{
            return
        }
        self.mainImage?.image = _image
    }

}
