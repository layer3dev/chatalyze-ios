//
//  SelfieTimerView.swift
//  Chatalyze
//
//  Created by Mansa on 20/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import AudioToolbox

class SelfieTimerView:ExtendedView {
    
    var player : AVAudioPlayer?
    var autographTime = 0
    static var testTimer = Timer()
    var selfieAttribute:[NSAttributedStringKey : Any] = [NSAttributedStringKey : Any]()
    var whiteAttribute:[NSAttributedStringKey : Any] = [NSAttributedStringKey : Any]()
    var screenShotListner:(()->())?
    @IBOutlet var selfieTimeLbl:UILabel?
    var isScreenShotTaken = false
    static var hostTimer = Timer()
    var requiredDate:Date?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        graySelfieTime()
    }
    
    func reset(){
        
        invalidateTimer()
        invalidateTimerForHost()
    }
    
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        Log.echo(key: "yud", text: "The selfie view is removing from the subview")
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
        SelfieTimerView.testTimer.invalidate()
        SelfieTimerView.hostTimer.invalidate()
        SelfieTimerView.hostTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self,    selector:(#selector(self.updateAnlalyst)) , userInfo: nil, repeats: true)
    }
    
    func currentDateTimeGMT()->Date{
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: "\(date))") ?? Date()
    }
    
    
    @objc private func updateAnlalyst(){
        
        if let date = requiredDate {
            
            Log.echo(key: "yud", text: "The current time date is \(currentDateTimeGMT())")
            let difference = currentDateTimeGMT().timeIntervalSince(date)
            Log.echo(key: "yud", text: "The diffrence in time date is \(difference)")
            if difference >= 3 {
                updateTimer()
            }
        }else{            
            invalidateTimerForHost()
            invalidateTimer()
        }
    }
    
    private func invalidateTimer(){
        
        SelfieTimerView.testTimer.invalidate()
        autographTime = 0
        self.isScreenShotTaken = false
    }
    
    private func invalidateTimerForHost(){
        
        SelfieTimerView.hostTimer.invalidate()
        autographTime = 0
        self.isScreenShotTaken = false
    }
    
    
    private func runTimer(){
        
        //to balance the time taken by animation
        SelfieTimerView.testTimer.invalidate()
        SelfieTimerView.hostTimer.invalidate()
        SelfieTimerView.testTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
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
            self.playSound()
            self.greenOne()
        }else if autographTime >= 16 && autographTime  < 17{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.30) {
                self.playSound()
            }
            self.greenTwo()
        }else if autographTime >= 17 && autographTime  < 18{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.30) {
                self.playSound()
            }
//            self.playSound()
            self.greenThird()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.88) {
                
                if !(self.isScreenShotTaken){
                    
                    self.isHidden = true
                    self.isScreenShotTaken = true
                    if let listner = self.screenShotListner{
                        listner()
                    }
                }else{
                    self.isHidden = true
                }
                self.invalidateTimer()
                self.invalidateTimerForHost()
            }
        }else if autographTime >= 18 && autographTime  < 19 {
            
//                if !(self.isScreenShotTaken){
            
//                    self.isHidden = true
//                    self.isScreenShotTaken = true
//                    if let listner = self.screenShotListner{
//                        listner()
//                    }
//                }else{
//                    self.isHidden = true
//                }
                self.invalidateTimer()
                self.invalidateTimerForHost()
            //self.smile()
        }else if autographTime >= 19{
            self.invalidateTimer()
            self.invalidateTimerForHost()
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

extension SelfieTimerView{
    
    
    func playSound() {
        
        /*
         NSURL *audioURL = [[NSBundle mainBundle] URLForResource:YourSound.stringByDeletingPathExtension withExtension:YourSound.pathExtension];
         NSData *audioData = [NSData dataWithContentsOfURL:audioURL];
         */
        
        guard let soundUrl = Bundle.main.url(forResource:"countDown_original" , withExtension: "mp3")
            else{
                return
        }
        guard let sound = try? Data(contentsOf: soundUrl)
            else {
                return
        }
        /*guard let sound = NSDataAsset(name: "e-memorabilia_notification") else {
         Log.echo(key: "", text:"asset not found")
         return
         }*/
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let player = try AVAudioPlayer(data: sound, fileTypeHint: AVFileType.mp3.rawValue)
            self.player = player
            
            player.play()
        } catch let error as NSError {
            
            Log.echo(key: "", text:"error: \(error.localizedDescription)")
        }
    }
}
