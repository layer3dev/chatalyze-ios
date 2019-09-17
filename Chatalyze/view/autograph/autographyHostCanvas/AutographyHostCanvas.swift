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
    
    @IBOutlet var heightConstraint:NSLayoutConstraint?
    @IBOutlet var widthConstraint:NSLayoutConstraint?
    
    var autoGraphInfo:AutographInfo?
    var counter = 0
    
    @IBOutlet var mainImageView : AutographyImageView?
    
    private var socketClient : SocketClient?
    private var socketListener : SocketListener?
    
    //static let kPointMinDistance : Double = 2.0;
    static let kPointMinDistance : Double = 0.1
    static let kPointMinDistanceSquared : Double = kPointMinDistance * kPointMinDistance
    
    var newImage = UIImage(named: "testingImage")
    
    var delegate : AutographyCanvasProtocol?
  
    
    override func viewDidLayout() {
        super.viewDidLayout()
      
        initialization()
        self.mainImageView?.broadcastDelegate = self
    }
    
    fileprivate func initialization()
    {
        socketClient = SocketClient.sharedInstance
        socketListener = socketClient?.createListener()
    }
    
    
    func undo(){
        
        self.mainImageView?.reset()
        broadcastCoordinate(withX: 0, y: 0, isContinous: false,reset: true)
    }
    


    
    private func point(insidePoint point : CGPoint, subView : UIView)->Bool{
        
        return subView.frame.contains(point)
    }
}

extension AutographyHostCanvas{
    
    var image : UIImage?{
        
        get{
            return mainImageView?.image
        }
        
        set{
            mainImageView?.image = newValue
        }
    }
    
    var size : CGSize{
        
        get{
            let size =  mainImageView?.frame.size ?? CGSize()
            return size
        }
    }
    
    var strokeColor : UIColor{
        
        get{
            return self.mainImageView?.strokeColor ?? UIColor.red
        }
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
    
    var scale:CGFloat{
        return UIScreen.main.scale
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
        params["StrokeColor"] = self.strokeColor.hexString
        params["Erase"] = false
        params["reset"] = reset
        
        var mainParams  = [String : Any]()
        mainParams["name"] = autoGraphInfo?.userHashedId
        mainParams["id"] = "broadcastPoints"
        mainParams["message"] = params
        
        counter = counter + 1
        
        Log.echo(key: "yud", text: "Sending the broadcasting points \(mainParams)")
        socketClient?.emit(mainParams)
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
            self.mainImageView?.updateStrokeColors(r:fRed,g:fGreen,b:fBlue, opacity: 1.0)
           
            Log.echo(key: "", text:" In the Button Selection Red color is \(fRed) blue color is\(fBlue) green color is \(fGreen) alpha is \(fAlpha) ")
        }
    }
}

extension AutographyHostCanvas:broadcastCoordinatesImageDelegate{
    
    func broadcastCoordinate(x : CGFloat, y : CGFloat, isContinous : Bool, reset : Bool){
        broadcastCoordinate(withX: x, y: y, isContinous: isContinous)
    }
}


extension AutographyHostCanvas{
    
    
}

