//
//  AutographyCanvas.swift
//  Kibitz
//
//  Created by Sumant Handa on 06/12/16.
//  Copyright © 2016 MansaInfoTech. All rights reserved.
//

import UIKit

class AutographyCanvas: ExtendedView {
    
    @IBOutlet var tempImageView : AspectImageView?
    @IBOutlet var mainImageView : AspectImageView?
    private var socketClient : SocketClient?
    private var socketListener : SocketListener?
    
    static let kPointMinDistance : Double = 0.1
    static let kPointMinDistanceSquared : Double = kPointMinDistance * kPointMinDistance;    
    var currentPoint = CGPoint.zero
    var previousPoint = CGPoint.zero
    var previousPreviousPoint = CGPoint.zero
    
    var _image : UIImage?
    var containerView : UIView?
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0
        
    var drawColor : UIColor?
    
    var touchStarted = false
    var _canvasInfo : CanvasInfo?
    
    var canvasInfo : CanvasInfo?{
        get{
            return _canvasInfo
        }
        set{
            _canvasInfo = newValue
            fillInfo()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }

    private func fillInfo(){
    }
    
    fileprivate func commonInit(){
        
        let viewList  = Bundle.main.loadNibNamed("AutographyCanvas", owner: self, options: nil)
        
        let view  = viewList?.first as? UIView
        
        if let viewUnwrapped = view {
            
            containerView = viewUnwrapped
            viewUnwrapped.translatesAutoresizingMaskIntoConstraints = false
            self.translatesAutoresizingMaskIntoConstraints = false
            
            let size = viewUnwrapped.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
            var frame = self.frame
            frame.size = size
            
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
        socketClient = SocketClient.sharedInstance
        socketListener = socketClient?.createListener()
        paintInterface()
        registerForAutographListener()
    }
    
    fileprivate func paintInterface(){
    }
    
    private func registerForAutographListener(){
        
        socketListener?.onEvent("broadcastPoints", completion: { (json) in
            
            Log.echo(key: "yud", text: "I got the brodcast call")

            let rawInfo = json?["message"]
            let broadcastInfo = BroadcastInfo(info : rawInfo)
            self.processPoint(info: broadcastInfo)
        })
    }
    
    private func targetPoint(inputPoint : CGPoint)->CGPoint{
        
        let selfWidth = size.width
        let selfHeight = size.height
        
        let targetWidth = CGFloat(canvasInfo?.width ?? Double(0))
        let targetHeight = CGFloat(canvasInfo?.height ?? Double(0))
        
        Log.echo(key: "processPoint", text: "selfWidth -> \(selfWidth) selfHeight -> \(selfHeight)")
        
        Log.echo(key: "processPoint", text: "targetWidth -> \(targetWidth) targetHeight -> \(targetHeight)")
        
        let widthRatio = selfWidth/targetWidth
        let heightRatio = selfHeight/targetHeight
        
        let x = widthRatio * inputPoint.x
        let y = heightRatio * inputPoint.y
        
        return CGPoint(x : x, y : y)
        
    }
    
    private func processPoint(info : BroadcastInfo){
        
        let rawColor = info.strokeColor ?? "#000"
        let color = UIColor(hexString : rawColor)
        self.drawColor = color
        if(info.reset){
            Log.echo(key: "processPoint", text: "asking to reset")
            touchStarted = false
            reset()
            return
        }
        
        let rawPoint = info.point
        Log.echo(key: "processPoint", text: "rawPoint -> x \(rawPoint.x) y --> \(rawPoint.y)")
        let point = targetPoint(inputPoint: rawPoint)
        
        Log.echo(key: "processPoint", text: "targetPoint -> x \(point.x) y --> \(point.y)")
        
        if(!info.isContinous && !touchStarted){
            Log.echo(key: "processPoint", text: "start sign")
            touchStarted = true
            touchesStart(point: point)
            return
        }
        
        if(info.isContinous){
            Log.echo(key: "processPoint", text: "move sign")
            touchStarted = true
            touchesMove(point: point)
            return
        }
        
        if(!info.isContinous){
            Log.echo(key: "processPoint", text: "end sign")
            touchStarted = false
            touchesEnd(point: point)
            return
        }
        
        Log.echo(key: "processPoint", text: "Dont know what to do")
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
    
    func touchesStart(point : CGPoint) {
        
        self.currentPoint = point
        self.previousPoint = self.currentPoint
        self.previousPreviousPoint = self.currentPoint
    }
    
    func setCanvas(){
    }
    
    func drawLineFrom(_ previousPoint : CGPoint, mid1: CGPoint, mid2: CGPoint) {

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
        
        let color = (drawColor ?? UIColor.black).cgColor
        context?.setStrokeColor(color)
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
  
    
    func touchesMove(point : CGPoint) {
        
        self.previousPreviousPoint = self.previousPoint;
        self.previousPoint = self.currentPoint;
        self.currentPoint = point
        
        processMovedTouches(currentTouchPoint : self.currentPoint, lastTouchPoint : self.previousPoint)

    }
    
    private func processMovedTouches(currentTouchPoint : CGPoint, lastTouchPoint : CGPoint){
        
        let point = currentTouchPoint
        
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
    
    func touchesEnd(point : CGPoint) {
        
        processTouchEnded(point : point)
    }
    
    private func processTouchEnded(point : CGPoint){
        return;
        
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

extension AutographyCanvas{
    
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

extension AutographyCanvas{
    
    func getSnapshot()->UIImage?{
        
        let bounds = mainImageView?.bounds ?? CGRect()
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        mainImageView?.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}



extension AutographyCanvas{
    fileprivate func paintEmptyView(){
    }
}




