//
//  SelfieTimerView.swift
//  Chatalyze
//
//  Created by Mansa on 20/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SelfieTimerView:ExtendedView {
    
    var autographTime = 0
    var testTimer = Timer()
    var selfieAttribute:[NSAttributedStringKey : Any] = [NSAttributedStringKey : Any]()
    var whiteAttribute:[NSAttributedStringKey : Any] = [NSAttributedStringKey : Any]()
    var screenShotListner:(()->())?
    @IBOutlet var selfieTimeLbl:UILabel?
    var isScreenShotTaken = false
    var hostTimer = Timer()
    var requiredDate:Date?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        graySelfieTime()
    }
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        invalidateTimerForHost()
        invalidateTimer()
    }
    
    func startAnimation(){
        
        self.invalidateTimer()
        self.runTimer()
    }
    
    
    func startAnimationForHost(date:Date?){
        
        autographTime = 12
        guard let startDate = date else {
            return
        }
        requiredDate = startDate
        //(#selector(self.updateAnlalyst(requiredDate:startDate)))
        hostTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self,    selector:(#selector(self.updateAnlalyst)) , userInfo: nil, repeats: true)
    }
    
    @objc private func updateAnlalyst(){
        
        if let date = requiredDate {
            let difference = Date().timeIntervalSince(date)
            if difference >= 0 {
                updateTimer()
            }
            if autographTime >= 20{
                invalidateTimerForHost()
            }
        }else{            
            invalidateTimerForHost()
        }
    }
    
    private func invalidateTimer(){
        
        self.testTimer.invalidate()
        autographTime = 0
        self.isScreenShotTaken = false
    }
    
    private func invalidateTimerForHost(){
        
        self.hostTimer.invalidate()
        autographTime = 0
        self.isScreenShotTaken = false
    }
    
    
    private func runTimer(){
        
        testTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        
        if autographTime >= 12 && autographTime  < 15{
            
            DispatchQueue.main.async {
                
                self.isHidden = false
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.845, animations: {
                    
                    if self.autographTime%2 == 0 {
                        self.graySelfieTime()
                    }else{
                        self.greenSelfieTime()
                    }
                })
            }
        }else if autographTime >= 15 && autographTime  < 16{
            self.greenOne()
        }else if autographTime >= 16 && autographTime  < 17{
            self.greenTwo()
        }else if autographTime >= 17 && autographTime  < 18{
            self.greenThird()
        }else if autographTime >= 18 && autographTime  < 19{
            self.smile()
        }else if autographTime >= 19{
            
            if !(self.isScreenShotTaken){
                
                self.isHidden = true
                self.isScreenShotTaken = true
                if let listner = screenShotListner{
                    listner()
                }
            }else{
                self.isHidden = true
            }
            invalidateTimer()
        }
        autographTime = autographTime + 1
    }
}


extension SelfieTimerView{
    
    private func greenOne(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        let oneAttribute =  [NSAttributedStringKey.foregroundColor:UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME:", attributes: self.selfieAttribute)
        let second = NSMutableAttributedString(string: " 3", attributes: oneAttribute)
        let secondStr = NSMutableAttributedString(string: " 2 1", attributes: self.whiteAttribute)
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(second)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.layoutIfNeeded()
    }
    
    private func greenTwo(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        let oneAttribute =  [NSAttributedStringKey.foregroundColor:UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME:", attributes: self.selfieAttribute)
        let second = NSMutableAttributedString(string: " 3", attributes: self.whiteAttribute)
        let secondTwo = NSMutableAttributedString(string: " 2", attributes: oneAttribute)
        let secondStr = NSMutableAttributedString(string: " 1", attributes: self.whiteAttribute)
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(second)
        requiredString.append(secondTwo)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.layoutIfNeeded()
    }
    
    private func greenThird(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        
        let oneAttribute =  [NSAttributedStringKey.foregroundColor:UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME:", attributes: self.selfieAttribute)
        let second = NSMutableAttributedString(string: " 3 2", attributes: self.whiteAttribute)
        let secondStr = NSMutableAttributedString(string: " 1", attributes: oneAttribute)
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(second)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.layoutIfNeeded()
    }
    
    private func smile(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        
        let oneAttribute =  [NSAttributedStringKey.foregroundColor:UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME:", attributes: self.selfieAttribute)
        let second = NSMutableAttributedString(string: " 3 2 1", attributes: self.whiteAttribute)
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: oneAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(second)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.layoutIfNeeded()
    }
    
    private func greenSelfieTime(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME", attributes: self.selfieAttribute)
        let secondStr = NSMutableAttributedString(string: ": 3 2 1", attributes: self.whiteAttribute)
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.layoutIfNeeded()
    }
    
    private func graySelfieTime(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
        
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME", attributes: self.selfieAttribute)
        let secondStr = NSMutableAttributedString(string: ": 3 2 1", attributes: self.whiteAttribute)
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.layoutIfNeeded()
    }
}
