//
//  AutographDigestProcessor.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 23/09/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class AutographDigestProcessor{
    
    var infos = [SignatureCoordinatesInfo]()
    var listener : ((_ startingPoint:CGPoint,_ endingPoint:CGPoint,_ controlPoint:CGPoint,_ isReset:Bool)->())?
    var date : Date? = nil
    var touchStarted = false
    var currentPoint = CGPoint()
    
    func setDigestListener(listener : ((_ startingPoint:CGPoint,_ endingPoint:CGPoint,_ controlPoint:CGPoint,_ isReset:Bool) ->())?){
        self.listener = listener
    }
    
    func reset(endPoint:CGPoint,isReset:Bool){
        
        let average = getAverage()
        self.date = nil
        self.listener?(currentPoint,endPoint,average,isReset)
    }
    
    func digest(pointInfo : SignatureCoordinatesInfo) {

        if(date == nil){
            date = Date()
        }
        
        guard let date = self.date
            else{
                return
        }
        
        let dateNow = Date()
        let timespan = dateNow.millisecondsSince1970 - date.millisecondsSince1970
        
        if pointInfo.isReset{
        
            self.touchStarted = false
            self.infos.removeAll()
            return
        }
        
        if !pointInfo.isContinuos && !touchStarted{
            
            Log.echo(key: "yud", text: " touch start")

            touchStarted = true
            currentPoint = pointInfo.point
            //self.infos.append(pointInfo)
            return
        }
        
        if pointInfo.isContinuos{
            
            self.infos.append(pointInfo)
        }
        
        if !pointInfo.isContinuos{
            
            Log.echo(key: "yud", text: "touch end")

            touchStarted = false
            //self.infos.append(pointInfo)
            reset(endPoint: pointInfo.point, isReset: false)
            return
        }
        
        if timespan > 1000{
            
            Log.echo(key: "yud", text: "Calling more time span at time \(Date())")
            //self.infos.append(pointInfo)
            reset(endPoint: pointInfo.point, isReset: false)
            currentPoint = pointInfo.point
        }
        return
    }
    
    private func getAverage() -> CGPoint{
        
        var sumofX:CGFloat = 0
        var sumofY:CGFloat = 0
        
        for (_,point) in infos.enumerated(){

            sumofX = sumofX + point.point.x
            sumofY = sumofY + point.point.y
        }
        
        let newX = sumofX/CGFloat(infos.count)
        let newY = sumofY/CGFloat(infos.count)
        
        Log.echo(key: "yud", text: " Recieved points \(self.infos.count)")

        self.infos.removeAll()
        return CGPoint(x: newX, y: newY)
    }
}
