//
//  AutographDigestProcessor.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 23/09/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class AutographDigestProcessor{
    
    var infos = [CGPoint]()
    var isTouchStart = false
    var listener : ((_ point:CGPoint,_ isEnded:Bool)->())?
    var date : Date? = nil
    
    func setDigestListener(listener : ((_ point : CGPoint,_ isEnded:Bool) ->())?){
        self.listener = listener
    }
    
    func reset(point : CGPoint,isEnded:Bool){
        infos.append(point)
        
        let average = getAverage()
        self.date = nil
        self.listener?(average,isEnded)
        return
    }
    
    func digest(point : CGPoint,isContinous:Bool) {
       
        if(date == nil){
            date = Date()
        }
        
        guard let date = self.date
            else{
                return
        }
        
        let dateNow = Date()
        let timespan = dateNow.millisecondsSince1970 - date.millisecondsSince1970
        
        if(timespan < 25){
            
            if isContinous == false && isTouchStart{
                isTouchStart = false
                reset(point: point,isEnded: true)
                return
            }
            isTouchStart = true
            infos.append(point)
            Log.echo(key: "yud", text: "accepted points are \(self.infos.count)")
            return
        }
        reset(point: point, isEnded: false)
    }
    
    private func getAverage() -> CGPoint{
        
        var sumofX:CGFloat = 0
        var sumofY:CGFloat = 0
        
        for (_,point) in infos.enumerated(){
            
            sumofX = sumofX + point.x
            sumofY = sumofY + point.y
        }
        
        let newX = sumofX/CGFloat(infos.count)
        let newY = sumofY/CGFloat(infos.count)
        
        self.infos.removeAll()
        return CGPoint(x: newX, y: newY)
    }
}
