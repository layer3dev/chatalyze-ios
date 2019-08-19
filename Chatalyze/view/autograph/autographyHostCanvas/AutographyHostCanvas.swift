//
//  AutographyHostCanvas.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 13/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AutographyHostCanvas: ExtendedView {

    var autoGraphInfo:AutographInfo?
    var counter = 0
    var getBeginPoint = false
    //var getEndPoint = true
    
    @IBOutlet var blurEffectView: UIView?
    @IBOutlet var tempImageView : AspectHostImageView?
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
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 8.5
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
        //mainImageView?.delegate = self
        //mainImageView?.isUserInteractionEnabled = true
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
        tempImageView?.image = _image
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
        
        let isallow = allowTouch(touches:touches)
        if !isallow {
            return
        }
        
        guard let touch = touches.first
            else{
                return
        }
        
        self.currentPoint = touch.location(in: mainImageView)
        self.previousPoint = touch.previousLocation(in: mainImageView)
        self.previousPreviousPoint = touch.previousLocation(in: mainImageView)
        
        if(!isEnabled){
            return
        }
        
        swiped = false
        let point = touch.location(in: self)
        if(!(mainImageView?.frame.contains(point) ?? false) ){
            return
        }
        
        //        if getEndPoint == false{
        //            self.delegate?.touchesEnded(withPoint: previousPoint)
        //        }
        //getEndPoint = false
        
        getBeginPoint = true
        broadcastCoordinate(withX: point.x, y: point.y, isContinous: false)
        self.touchesBegan(withPoint: currentPoint)
        //self.touchesMoved(touches, with: event)
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
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        tempImageView?.image?.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        //        context?.setBlendMode(CGBlendMode.normal)
        // 2
        context?.move(to: CGPoint(x: mid1.x, y: mid1.y))
        //        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.addQuadCurve(to: mid2, control: previousPoint)
        //        CGContextAddQuadCurveToPoint(canvas.context, current.a.x, current.a.y, currentMid.x, currentMid.y)
        // 4
        context?.strokePath()
        // 5
        tempImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView?.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let isallow = allowTouch(touches:touches)
        if !isallow {
            return
        }
        
        guard let touch = touches.first
            else{
                return;
        }
        
        var previousPoint = touch.previousLocation(in: mainImageView)
        
        if(previousPoint.x < 0){
            previousPoint.x = 0
        }
        if(previousPoint.y < 0){
            previousPoint.y = 0
        }
        
        self.previousPreviousPoint = self.previousPoint;
        self.previousPoint = previousPoint;
        let lastTouchPoint = self.currentPoint;
        self.currentPoint = touch.location(in: mainImageView)
        if(!isEnabled){
            return
        }
        
        //6
        swiped = true
        let mainPoint = touch.location(in: self)
        if(!(mainImageView?.frame.contains(mainPoint) ?? false) ){
            let point = touch.location(in: mainImageView)
            self.touchesEnded(withPoint: point)
            return
        }
        if getBeginPoint == false{
            let point = touch.location(in: mainImageView)
            self.touchesBegan(withPoint: point)
            getBeginPoint = true
            return
        }
        let point = touch.location(in: mainImageView)
        self.touchesMoved(withPoint: point)
        processMovedTouches(lastTouchPoint : lastTouchPoint, touches : touches, with: event)
        
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
        if(!(mainImageView?.frame.contains(mainPoint) ?? false) ){
            return
        }
        getBeginPoint = false
        //getEndPoint = true
        let point = touch.location(in: mainImageView)
        self.touchesEnded(withPoint: point)
    }
    
    private func processTouchEnded(_ touches: Set<UITouch>){
        
        let isallow = allowTouch(touches:touches)
        if !isallow {
            return
        }
        
        let frame = self.mainImageView?.frame ?? CGRect()
        Log.echo(key: "frame", text: "touchesEnded ==> \(frame)")
        if !swiped {
            //draw a single point
            drawLineFrom(currentPoint, mid1: currentPoint, mid2: currentPoint)
            //drawLineFrom(currentPoint, toPoint: currentPoint)
        }
        // Merge tempImageView into mainImageView
        // UIGraphicsBeginImageContext()
        let size = mainImageView?.frame.size ?? CGSize()
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        mainImageView?.image?.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView?.image?.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView?.image = nil
    }
    
    private func point(insidePoint point : CGPoint, subView : UIView)->Bool{
        return subView.frame.contains(point);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Log.echo(key: "yud", text: "Frames of the Autograph canvas height  \(self.frame.size.height) Autograph canvas width is  \(self.frame.size.width) \n")
        
        self.mainImageView?.frame = self.frame
        self.tempImageView?.frame = self.frame
        
        self.mainImageView?.updateFrames()
        self.tempImageView?.updateFrames()
    }
}

extension AutographyHostCanvas{
    
    var image : UIImage?{
        
        get{
            return mainImageView?.image
        }
        
        set{
            tempImageView?.image = newValue
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

extension AutographyHostCanvas : AutographyImageViewProtocol{
    
    func touchesBeganAutography(_ touches: Set<UITouch>, with event: UIEvent?){
    }
    
    func touchesMovedAutography(_ touches: Set<UITouch>, with event: UIEvent?){
    }
    
    func touchesEndedAutography(_ touches: Set<UITouch>, with event: UIEvent?){
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
    }
    
    func touchesMoved(withPoint point : CGPoint){
        broadcastCoordinate(withX: point.x, y: point.y, isContinous: true)
    }
    
    func touchesEnded(withPoint point : CGPoint){
        broadcastCoordinate(withX: point.x, y: point.y, isContinous: false)
    }
    
    func initializeForGetSocketPing(){
      
//        case "screenshot":
//        return .screenshotInfo
//        case "":
//        return .screenshotLoaded
//        case "registerResponse":
//        return .registerResponse
//        case "updatePeerList":
//        return .updatePeerList
//        case "participantLeft":
//        return .participantLeft
        
        
        socketListener?.onEvent("screenshotLoaded") {data in
         
            Log.echo(key: "yud", text: "I got the screenshot loaded ping")
            
        }
            
            
            
        
    }
    
}
