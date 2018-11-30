//
//  SelfieTimerView.swift
//  Chatalyze
//
//  Created by Mansa on 20/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//



import UIKit
import AudioToolbox


protocol GetisHangedUpDelegate {
    func getHangUpStatus()->Bool
}

class SelfieTimerView:ExtendedView {
    
    var player : AVAudioPlayer?
    var autographTime = 0
    //static var testTimer = Timer()
    var testTimer = CountdownListener()
    var selfieAttribute:[NSAttributedString.Key : Any] = [NSAttributedString.Key : Any]()
    var whiteAttribute:[NSAttributedString.Key : Any] = [NSAttributedString.Key : Any]()
    var screenShotListner:(()->())?
    
    @IBOutlet var selfieTimeLbl:UILabel?
    var isScreenShotTaken = false
    //static var hostTimer = Timer()
    var hostTimer = CountdownListener()
    var requiredDate:Date?
    var delegate:GetisHangedUpDelegate?
    var selfieTimerAnimateFlag = 0
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        graySelfieTime()
        createPlayerObject()
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
        self.invalidateTimerForHost()
        self.runTimer()
    }
    
    func startAnimationForHost(date:Date?){
        
        autographTime = 13
        guard let startDate = date else {
            return
        }
        requiredDate = startDate
        
        
        //        SelfieTimerView.testTimer.invalidate()
        //        SelfieTimerView.hostTimer.invalidate()
        
        self.testTimer.releaseListener()
        self.hostTimer.releaseListener()
        
        
        //SelfieTimerView.hostTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self,    selector:(#selector(self.updateAnlalyst)) , userInfo: nil, repeats: true)
        
        self.testTimer.start()
        self.registerForTimer()
    }
    
    private func registerForTimer(){
        
        self.testTimer.add { [weak self] in
            
            Log.echo(key: "yud", text: "Yes I am running in add")
            self?.updateTimer()
        }
    }
    
    
    func currentDateTimeGMT()->Date{
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: "\(date))") ?? Date()
    }
    
    
    @objc private func updateAnlalyst(){
        
        if let date = requiredDate {
            
            Log.echo(key: "selfie_timer", text: "The current time date is \(currentDateTimeGMT())")
            
            let difference = date.timeIntervalTillNow
            
            //let difference = currentDateTimeGMT().timeIntervalSince(date)
            
            Log.echo(key: "selfie_timer", text: "The diffrence in time date is \(difference)")
            
            if difference <= -3 {
                
                updateTimer()
            }
        }else{
            
            invalidateTimerForHost()
            invalidateTimer()
        }
    }
    
    private func invalidateTimer(){
        
        player?.stop()
        //player = nil
        //SelfieTimerView.testTimer.invalidate()
        self.testTimer.releaseListener()
        autographTime = 0
        self.isScreenShotTaken = false
        self.isHidden = true
    }
    
    private func invalidateTimerForHost(){
        
        player?.stop()
        //player = nil
        //SelfieTimerView.hostTimer.invalidate()
        self.hostTimer.releaseListener()
        autographTime = 0
        self.isScreenShotTaken = false
        self.isHidden = true
    }
    
    
    private func runTimer(){
        
        //to balance the time taken by animation
        
        //        SelfieTimerView.testTimer.invalidate()
        //        SelfieTimerView.hostTimer.invalidate()
        //        SelfieTimerView.testTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        
        self.testTimer.releaseListener()
        self.hostTimer.releaseListener()
        self.testTimer.start()
        self.registerForTimer()
        
    }
    
    
    func showSelfieTimerAnimationGrayandGreen(){
        
        DispatchQueue.main.async {
            
            //Verifying for the Hangup
            if let isHangedUp = self.delegate?.getHangUpStatus(){
                if isHangedUp{
                    self.invalidateTimer()
                    self.invalidateTimerForHost()
                    return
                }
            }
            
            self.isHidden = false
            if self.selfieTimerAnimateFlag%2 == 0 {
                self.greenSelfieTime()
            }else{
                self.graySelfieTime()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                if self.selfieTimerAnimateFlag >= 3{
                    self.playOne()
                    self.selfieTimerAnimateFlag = 0
                }else{
                    self.showSelfieTimerAnimationGrayandGreen()
                }
            })
            self.selfieTimerAnimateFlag = self.selfieTimerAnimateFlag + 1
        }
    }
    
    
    func playOne(){
        
        //Verifying for the Hangup
        if let isHangedUp = self.delegate?.getHangUpStatus(){
            if isHangedUp{
                self.invalidateTimer()
                self.invalidateTimerForHost()
                return
            }
        }
        
        self.playSound()
        self.greenOne()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playTwo()
        }
    }
    
    func playTwo(){
        
        //Verifying for the Hangup
        if let isHangedUp = self.delegate?.getHangUpStatus(){
            if isHangedUp{
                self.invalidateTimer()
                self.invalidateTimerForHost()
                return
            }
        }
        
        self.playSound()
        self.greenTwo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playThree()
        }
        
        //        DispatchQueue.main.async {
        //
        //        UIView.animate(withDuration: 1, animations: {
        //
        //            self.layoutIfNeeded()
        //
        //        }) { (success) in
        //            self.playThree()
        //        }
        //        self.layoutIfNeeded()
        //
        //        }
    }
    
    func playThree(){
        
        //Verifying for the Hangup
        if let isHangedUp = self.delegate?.getHangUpStatus(){
           
            if isHangedUp{
                
                self.invalidateTimer()
                self.invalidateTimerForHost()
                return
            }
        }
        
        self.playSound()
        self.greenThird()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            
            self.mimicFlash()
        }
    }
    
    func mimicFlash(){
        
        DispatchQueue.main.async {
            
            //Verifying for the Hangup
            if let isHangedUp = self.delegate?.getHangUpStatus(){
                if isHangedUp{
                    self.invalidateTimer()
                    self.invalidateTimerForHost()
                    return
                }
            }
            
            if !(self.isScreenShotTaken){
                
                self.isHidden = true
                self.isScreenShotTaken = true
                if let listner = self.screenShotListner{
                    listner()
                }
            }else{
                self.isHidden = true
            }
        }
    }
    
    @objc func updateTimer(){
        
        if let date = requiredDate {
            
            Log.echo(key: "selfie_timer", text: "The current time date is \(currentDateTimeGMT()) and the Required Date is \(requiredDate) and the diffrence is \(date.timeIntervalTillNow)")
            
            let difference = date.timeIntervalTillNow
            
            Log.echo(key: "selfie_timer", text: "The diffrence in time date is \(difference)")
            
            if difference <= -3 {
                
                self.showSelfieTimerAnimationGrayandGreen()
                if let isHangedUp = delegate?.getHangUpStatus(){
                    
                    if isHangedUp{
                        invalidateTimer()
                        invalidateTimerForHost()
                        return
                    }
                }
                self.testTimer.releaseListener()
                self.hostTimer.releaseListener()
            }
        }
    }
}

extension SelfieTimerView{
    
    private func greenOne(){
        
        self.selfieAttribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
        self.whiteAttribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
        let oneAttribute =  [NSAttributedString.Key.foregroundColor:UIColor(hexString: AppThemeConfig.themeColor),NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
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
        
        self.selfieAttribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
        self.whiteAttribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
        let oneAttribute =  [NSAttributedString.Key.foregroundColor:UIColor(hexString: AppThemeConfig.themeColor),NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
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
        
        self.selfieAttribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
        self.whiteAttribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
        let oneAttribute =  [NSAttributedString.Key.foregroundColor:UIColor(hexString: AppThemeConfig.themeColor),NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
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
        
        self.selfieAttribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        self.whiteAttribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
        let oneAttribute =  [NSAttributedString.Key.foregroundColor:UIColor(hexString: AppThemeConfig.themeColor),NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
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
        
        self.selfieAttribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString:AppThemeConfig.themeColor),NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
        self.whiteAttribute = [NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
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
        
        self.selfieAttribute = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
        self.whiteAttribute = [NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont(name: "Poppins", size: 28)]
        
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
    
    func createPlayerObject(){
        
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
            try
                AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            //            AVAudioSession.sharedInstance().setCategory(convertFromAVAudioSessionCategory(AVAudioSession.Category.playback), mode: .continuous)
            
            try AVAudioSession.sharedInstance().setActive(true)
            let player = try AVAudioPlayer(data: sound, fileTypeHint: AVFileType.mp3.rawValue)
            self.player = player
            
        } catch let error as NSError {
            Log.echo(key: "", text:"error: \(error.localizedDescription)")
        }
    }
    
    func test(){
    }
    
    func playSound() {
        
        self.player?.play()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
