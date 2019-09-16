//
//  AutographyHostCanvas.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 13/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import AVFoundation


class AutographyHostCanvas: ExtendedView {
    
    @IBOutlet var testImageView:UIImageView?
    
    var drawingLayer:CALayer?
    var autoGraphInfo:AutographInfo?
    var counter = 0
    var getBeginPoint = false
    //var getEndPoint = true
    
    
    @IBOutlet var blurEffectView: UIView?
    @IBOutlet var mainImageView : AutographyImageView?
    
    @IBOutlet var screenShotAlertView: UIView?
    
    private var socketClient : SocketClient?
    private var socketListener : SocketListener?
    
    //static let kPointMinDistance : Double = 2.0;
    static let kPointMinDistance : Double = 0.1
    static let kPointMinDistanceSquared : Double = kPointMinDistance * kPointMinDistance;
    var currentPoint = CGPoint.zero
    var previousPoint = CGPoint.zero
    var previousPreviousPoint = CGPoint.zero
    fileprivate var _isEnabled = true
    var _image : UIImage?
    
    var newImage = UIImage(named: "testingImage")
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 8:6
    //var brushWidth: CGFloat = 18
    var opacity: CGFloat = 1.0

    var swiped = false
    var delegate : AutographyCanvasProtocol?
    var containerView : UIView?
    var isAllowedHand = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    init(frame : CGRect, delegate : AutographyCanvasProtocol)
    {        
        super.init(frame: frame)
        self.delegate = delegate
        commonInit()
    }
    
    fileprivate func commonInit(){
        
        let viewList  = Bundle.main.loadNibNamed("AutographyHostCanvas", owner: self, options: nil)
        
        let view  = viewList?.first as? UIView
        
        if let viewUnwrapped = view {
            
            containerView = viewUnwrapped
            viewUnwrapped.translatesAutoresizingMaskIntoConstraints = false
            self.translatesAutoresizingMaskIntoConstraints = false
            
            let size = viewUnwrapped.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
            var frame = self.frame;
            frame.size = size;
            
            self.frame = frame
            self.addSubview(viewUnwrapped)
            
            fillConstraints()
            initialization()
        }
    }
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        paintEmptyView()
    }
    
    fileprivate func initialization()
    {
        paintInterface()
        socketClient = SocketClient.sharedInstance
        socketListener = socketClient?.createListener()
    }
    
    fileprivate func paintInterface(){
    }
    
    fileprivate func fillConstraints()
    {
        var customConstraints = [NSLayoutConstraint]()
        
        if(containerView == nil)
        {
            return
        }
        
        guard let view = containerView
            else{
                return
        }
        
        let bindings : [String : AnyObject] = ["view": view]
        
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
        
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
        
        self.addConstraints(customConstraints)
    }
    
    func reset(){
        
        mainImageView?.image = _image
    }
    
    func undo(){
        
        mainImageView?.image = _image
        broadcastCoordinate(withX: 0, y: 0, isContinous: false,reset: true)
    }
    
    
    fileprivate func allowTouch(touches:Set<UITouch>?)->Bool{
       
        if let touch = touches{
            if #available(iOS 9.1, *){
                if touch.first?.type == .stylus{
                    return true
                }
                if isAllowedHand == true{
                    return true
                }
                return false
            }
            //Fallback on earlier versions
            return true
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
      Log.echo(key: "yud", text: "Frame of the self is \(self.frame) and the frame of the mainImageView is \(self.mainImageView?.frame) and the size frame of mainImage is \(self.image?.size) and rext size is \(AVMakeRect(aspectRatio: self.image?.size ?? CGSize.zero, insideRect: self.frame))")
        
        let isallow = allowTouch(touches:touches)
        if !isallow {
            return
        }
        
        guard let touch = touches.first
            else{
                return
        }
        
        self.currentPoint = touch.location(in: self)
        self.previousPoint = touch.previousLocation(in: self)
        self.previousPreviousPoint = touch.previousLocation(in: self)
        
        if(!isEnabled){
            return
        }
        
        swiped = false
        
        let x = AVMakeRect(aspectRatio: self.image?.size ?? CGSize.zero, insideRect: self.frame)
        
        let point = touch.location(in: self)
        if(!(x.contains(point))){
            Log.echo(key: "point", text: "Point is not existing in the mainImageView")
            return
        }
    
        getBeginPoint = true
        Log.echo(key: "point", text: "I am  broadcasting first time with coordinatue \(point.x) and the y is \(point.y)")
        self.touchesBegan(withPoint: currentPoint)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Log.echo(key: "point", text: "Point as touches move \(String(describing: touches.first?.location(in: self))) and this point is under the canvas frame is \(String(describing: mainImageView?.frame)))")
        
        
        let isallow = allowTouch(touches:touches)
        if !isallow {
            return
        }
        
        guard let touch = touches.first
            else{
                return
        }
        
        var previousPoint = touch.previousLocation(in: self)
        
//        if(previousPoint.x < 0){
//            previousPoint.x = 0
//        }
//        if(previousPoint.y < 0){
//            previousPoint.y = 0
//        }
        
        
        
        
        self.previousPreviousPoint = self.previousPoint
        self.previousPoint = previousPoint
        let lastTouchPoint = self.currentPoint
        self.currentPoint = touch.location(in: self)
        if(!isEnabled){
            return
        }
        
        //6
        swiped = true
        let x = AVMakeRect(aspectRatio: self.image?.size ?? CGSize.zero, insideRect: self.frame)
        let point = touch.location(in: self)
        
        
        if(!(x.contains(point))){
            
            Log.echo(key: "point", text: "I am not broadcasting")
            let point = touch.location(in: self)
            self.touchesEnded(withPoint: point)
            return
        }
        if getBeginPoint == false{
            
            let point = touch.location(in: self)
            self.touchesBegan(withPoint: point)
            getBeginPoint = true
            return
        }
        
        let currentpoint = touch.location(in: self)
        self.touchesMoved(withPoint: currentpoint)
        Log.echo(key: "point", text: "I am broadcasting")
        drawBezier(from: self.previousPoint, to: self.currentPoint)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Log.echo(key: "point", text: "Point as touches end \(String(describing: touches.first?.location(in: self))) and this point is under the canvas frame is \(mainImageView?.frame))")
        
        let isallow = allowTouch(touches:touches)
        if !isallow {
            return
        }
        
        if(!isEnabled){
            return
        }
        processTouchEnded(touches)
        guard let touch = touches.first
            else{
                return;
        }
        let mainPoint = touch.location(in: self)
        let x = AVMakeRect(aspectRatio: self.image?.size ?? CGSize.zero, insideRect: self.frame)
        
        if(!(x.contains(mainPoint))){
            Log.echo(key: "point", text: "I am not broadcasting")
            return
        }
        getBeginPoint = false
        //getEndPoint = true
        let point = touch.location(in: self)
        Log.echo(key: "point", text: "I am broadcasting")
        self.touchesEnded(withPoint: point)
        flattenToImage()
    }
    
    func setCanvas(){
    }
    
    func drawLineFrom(_ previousPoint : CGPoint, mid1: CGPoint, mid2: CGPoint) {
        // 1
        let frame = self.mainImageView?.frame ?? CGRect()
        
        Log.echo(key: "drawLineFrom", text: "drawLineFrom ==> \(frame)")
        Log.echo(key: "drawLineFrom", text: "drawLineFrom previousPoint ==> \(previousPoint)")
        Log.echo(key: "drawLineFrom", text: "drawLineFrom mid1 ==> \(mid1)")
        Log.echo(key: "drawLineFrom", text: "drawLineFrom mid2 ==> \(mid2)")
        
    //  UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        mainImageView?.image?.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
      
        //context?.setBlendMode(CGBlendMode.normal)
        // 2
        context?.move(to: CGPoint(x: mid1.x, y: mid1.y))
      
        
        //context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.addQuadCurve(to: mid2, control: previousPoint)
        
        
        //CGContextAddQuadCurveToPoint(canvas.context, current.a.x, current.a.y, currentMid.x, currentMid.y)
        context?.strokePath()
        
        
        mainImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        mainImageView?.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    

    
    private func processMovedTouches(lastTouchPoint : CGPoint, touches: Set<UITouch>, with event: UIEvent?){
        
        
        let isallow = allowTouch(touches:touches)
        if !isallow {
            return
        }
        
        guard let touch = touches.first
            else{
                return;
        }
        
        let point = touch.location(in: mainImageView)
        let dx = point.x - lastTouchPoint.x
        let dy = point.y - lastTouchPoint.y
        
        let total : Double = (Double(dx * dx) + Double(dy * dy))
        
        if (total < AutographyCanvas.kPointMinDistanceSquared) {
            // ... then ignore this movement
            return;
        }
        // update points: previousPrevious -> mid1 -> previous -> mid2 -> current
        Log.echo(key : "currentPoint", text : "currentPoint ==> \(self.currentPoint)")
        Log.echo(key : "previousPreviousPoint", text : "previousPreviousPoint ==> \(self.previousPreviousPoint)")
        let mid1 = midPoint(self.previousPoint, p2: self.previousPreviousPoint);
        let mid2 = midPoint(self.currentPoint, p2: self.previousPoint);
        drawLineFrom(previousPoint, mid1: mid1, mid2: mid2)
        //        drawLineFrom(previousPoint, mid1 : , toPoint: mid2)
    }
    
    //return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
    private func midPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint{
        
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
    
    //func touchesEndedAutography(_ touches: Set<UITouch>, with event: UIEvent?) {

    
    private func processTouchEnded(_ touches: Set<UITouch>){

        let frame = self.mainImageView?.frame ?? CGRect()
        
        Log.echo(key: "frame", text: "touchesEnded ==> \(frame)")
        
        if !swiped {
            
            drawLineFrom(currentPoint, mid1: currentPoint, mid2: currentPoint)
        }
        
        
    }
    
    private func point(insidePoint point : CGPoint, subView : UIView)->Bool{
        
        return subView.frame.contains(point)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Log.echo(key: "point", text: "LAYOUT IS CALLING")
        self.updateFrames()
    }
    
    func updateFrames(){
        
        Log.echo(key: "yud", text: "image size is \(self.image?.size) and the frame is \(self.frame)")
        
        
        if self.image?.size != nil{
            
            Log.echo(key: "yud", text: "providing the frame")

            let x = AVMakeRect(aspectRatio: self.image?.size ?? CGSize.zero, insideRect: self.frame)
        }
    }
}

extension AutographyHostCanvas{
    
    var image : UIImage?{
        
        get{
            return mainImageView?.image
        }
        
        set{
            mainImageView?.image = newValue
            _image = newValue
        }
    }
    
    var size : CGSize{
        get{
            let size =  mainImageView?.frame.size ?? CGSize()
            return size
        }
    }
    
    
    var isEnabled : Bool{
        get{
            return _isEnabled
        }
        set{
            _isEnabled = newValue
        }
    }
    
    
    var color : UIColor{
        get{
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    fileprivate var scale : CGFloat{
        return 0.0
        let scale = UIScreen.main.scale
        Log.echo(key: "token", text: "scale  ==> \(scale)")
        if(scale > 1.0){
            return scale - 0.5
        }
        return scale
    }
}

extension AutographyHostCanvas{
    
    func getSnapshot()->UIImage?{
        
        let bounds = mainImageView?.bounds ?? CGRect()
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        mainImageView?.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


extension AutographyHostCanvas{
    
    fileprivate func paintEmptyView(){
        
        /*let emptyView = AutographyCanvasEmpty()
         self.emptyView = emptyView
         self.addSubview(emptyView)
         self.addConstraints(childView: emptyView)*/
    }
}


extension AutographyHostCanvas{
    
    fileprivate func broadcastCoordinate(withX x : CGFloat, y : CGFloat, isContinous : Bool, reset : Bool = false){

        var params = [String : Any]()
        
        params["x"] = x
        params["y"] = y
        
        params["isContinous"] = isContinous
        params["counter"] = counter
        params["pressure"] = 1
        params["reset"] = reset
        
        //params["StrokeWidth"] = canvas?.brushWidth ?? 2.0
        
        params["StrokeWidth"] = 11.0
        params["StrokeColor"] = self.color.hexString
        params["Erase"] = false
        params["reset"] = reset
        
        var mainParams  = [String : Any]()
        mainParams["name"] = autoGraphInfo?.userHashedId
        mainParams["id"] = "broadcastPoints"
        mainParams["message"] = params
        
        counter = counter + 1;
        socketClient?.emit(mainParams)
    }
}


extension AutographyHostCanvas{
    
    func touchesBegan(withPoint point : CGPoint){
        
        broadcastCoordinate(withX: point.x, y: point.y, isContinous: false)
        Log.echo(key: "point", text: "sending the begining point with the x \(point.x) and the y is \(point.y)")
    }
    
    func touchesMoved(withPoint point : CGPoint){

        broadcastCoordinate(withX: point.x, y: point.y, isContinous: true)
        Log.echo(key: "point", text: "sending the moving point with the x \(point.x) and the y is \(point.y)")

    }
    
    func touchesEnded(withPoint point : CGPoint){

        broadcastCoordinate(withX: point.x, y: point.y, isContinous: false)
        Log.echo(key: "point", text: "sending the end point. with the x \(point.x) and the y is \(point.y)")

    }
    
    func initializeForGetSocketPing(){
        
        socketListener?.onEvent("screenshotLoaded") {data in
            
            Log.echo(key: "yud", text: "I got the screenshot loaded ping")
        }
    }
}

extension AutographyHostCanvas{
    
    func updateColorFromPicker(color:UIColor?){
        
        guard let newSelectedColor = color else{
            return
        }

        var fRed : CGFloat = 1.0
        var fGreen : CGFloat = 0.0
        var fBlue : CGFloat = 0.0
        var fAlpha: CGFloat = 0.0
        
        if (newSelectedColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)) {
            
            Log.echo(key: "", text:"test color if")
            
            if fRed < 0 {
                fRed = -(fRed)
            }
            if fGreen < 0{
                fGreen = -(fGreen)
            }
            if fBlue < 0{
                fBlue = -(fBlue)
            }
            red = fRed
            green = fGreen
            blue = fBlue
            opacity = fAlpha
            //drawPreview()
            //delegate?.toolUpdated(self)
            Log.echo(key: "", text:" In the Button Selection Red color is \(fRed) blue color is\(fBlue) green color is \(fGreen) alpha is \(fAlpha) ")
        }
    }
}


extension AutographyHostCanvas{
    
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
        line.contentsScale = 0.0
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = UIColor.red.cgColor
        line.opacity = 1
        line.lineWidth = 10
        line.lineCap = .round
        line.strokeColor = UIColor.red.cgColor
        drawingLayer?.addSublayer(line)
        
        if let count = drawingLayer?.sublayers?.count, count > 400 {
            flattenToImage()
        }
    }
    
    func flattenToImage() {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size ?? CGSize.zero, false, UIScreen.main.scale)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            // keep old drawings
            if let image = self.mainImageView?.image {
                
                image.draw(in: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
            }
            // add new drawings
            drawingLayer?.render(in: context)
            let output = UIGraphicsGetImageFromCurrentImageContext()
            //self.mainImageView?.image = output
            self.testImageView?.image = output
        }
        clearSublayers()
        UIGraphicsEndImageContext()
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
