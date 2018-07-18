//
//  AnimationTestController.swift
//  Chatalyze
//
//  Created by Mansa on 18/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AnimationTestController: InterfaceExtendedController {

    
    var animationTimer = Timer()
    var autographTime = 0
    @IBOutlet var selfieTimeLbl:UILabel?
    var selfieAttribute:[NSAttributedStringKey : Any] = [NSAttributedStringKey : Any]()
    var whiteAttribute:[NSAttributedStringKey : Any] = [NSAttributedStringKey : Any]()
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
     
        runTimer()
        
//        let selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 28)]
//
//        let selfieGreenAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 24)]
//
//        let timeAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 24)]
//
//        let timeGreenAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 24)]
//
//        let smileGreenAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 24)]
//
//        let smileAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 24)]
//
//        let grayAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 24)]
//
//
//        let firstStr = NSMutableAttributedString(string: "SELFIE TIME", attributes: selfieAttribute)
//
//        let slotNumber = NSMutableAttributedString(string: "Chat \(self.info?.slotNumber ?? "") ", attributes: greenAttribute)
//
//        let secondStr = NSMutableAttributedString(string: "during the event, scheduled from ", attributes: grayAttribute)
//
//        let time = NSMutableAttributedString(string: "\(self.info?.startTime ?? "") - \(self.info?.endTime ?? "") ", attributes: greenAttribute)
//
//        let fourthStr = NSMutableAttributedString(string: "on ", attributes: grayAttribute)
//
//        let fifthStr = NSMutableAttributedString(string: "\(self.info?.startDate ?? "")", attributes: greenAttribute)
//
//        let sixthStr = NSMutableAttributedString(string: ". Your ticket to joint the event is now in the Event Tickets Section of your account", attributes: grayAttribute)
//
//        let requiredString:NSMutableAttributedString = NSMutableAttributedString()
//
//        requiredString.append(firstStr)
//        requiredString.append(slotNumber)
//        requiredString.append(secondStr)
//        requiredString.append(time)
//        requiredString.append(fourthStr)
//        requiredString.append(fifthStr)
//        requiredString.append(sixthStr)
        
      //  chatDetailLbl?.attributedText = requiredString
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.animationTimer.invalidate()
    }
    
    private func runTimer() {
        
        animationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        
        autographTime = autographTime + 1
        Log.echo(key: "yud", text: "The autograpgh time is \(autographTime)")
        print("The autograph time is \(autographTime)")
        
        if autographTime >= 10 && autographTime  <= 13{
            
            DispatchQueue.main.async {
                
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.1, animations: {
                    if self.autographTime%2 == 0 {
                      self.graySelfieTime()
                    }else{
                        self.greenSelfieTime()
                    }
                })
            }
        }else if autographTime >= 14 && autographTime  < 15{
            self.greenOne()
        }else if autographTime >= 16 && autographTime  < 17{
            self.greenTwo()
        }else if autographTime >= 18 && autographTime  < 19{
            self.greenThird()
        }else if autographTime >= 20 && autographTime  < 22{
            self.smile()
        }else{
        }
    }

    func greenOne(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 30)]
        
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 24)]
        
        let oneAttribute =  [NSAttributedStringKey.foregroundColor:UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 32)]
        
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME:", attributes: self.selfieAttribute)
        
        let second = NSMutableAttributedString(string: " 1", attributes: oneAttribute)
        let secondStr = NSMutableAttributedString(string: " 2 3", attributes: self.whiteAttribute)
        
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(second)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.view.layoutIfNeeded()
    }
    
    func greenTwo(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 30)]
        
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 24)]
        
        let oneAttribute =  [NSAttributedStringKey.foregroundColor:UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 32)]
        
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME:", attributes: self.selfieAttribute)
        
        let second = NSMutableAttributedString(string: " 1", attributes: self.whiteAttribute)
        let secondTwo = NSMutableAttributedString(string: " 2", attributes: oneAttribute)
        let secondStr = NSMutableAttributedString(string: " 3", attributes: self.whiteAttribute)
        
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(second)
        requiredString.append(secondTwo)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.view.layoutIfNeeded()
    }
    
    func greenThird(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 30)]
        
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 24)]
        
        let oneAttribute =  [NSAttributedStringKey.foregroundColor:UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 32)]
        
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME:", attributes: self.selfieAttribute)
        
        let second = NSMutableAttributedString(string: " 1 2", attributes: self.whiteAttribute)
       
        let secondStr = NSMutableAttributedString(string: " 3", attributes: oneAttribute)
        
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(second)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.view.layoutIfNeeded()
    }
    
    func smile(){
        
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 30)]
        
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 24)]
        
        let oneAttribute =  [NSAttributedStringKey.foregroundColor:UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 32)]
        
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME:", attributes: self.selfieAttribute)
        
        let second = NSMutableAttributedString(string: " 1 2 3", attributes: self.whiteAttribute)
        
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: oneAttribute)
        
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(second)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.view.layoutIfNeeded()
    }
    
    
    
    func greenSelfieTime(){
     
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 30)]
        
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 24)]
        
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME", attributes: self.selfieAttribute)
        
        let secondStr = NSMutableAttributedString(string: ": 1 2 3", attributes: self.whiteAttribute)
        
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.view.layoutIfNeeded()
    }
    
    func graySelfieTime(){
       
        self.selfieAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 30)]
        
        self.whiteAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 24)]
        
        let firstStr = NSMutableAttributedString(string: "SELFIE TIME", attributes: self.selfieAttribute)
        
        let secondStr = NSMutableAttributedString(string: ": 1 2 3", attributes: self.whiteAttribute)
        
        let thirdStr = NSMutableAttributedString(string: " SMILE", attributes: self.whiteAttribute)
        
        var requiredString:NSMutableAttributedString = NSMutableAttributedString()
        
        requiredString.append(firstStr)
        requiredString.append(secondStr)
        requiredString.append(thirdStr)
        
        self.selfieTimeLbl?.attributedText = requiredString
        self.view.layoutIfNeeded()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension AnimationTestController{
    
    class func instance()->AnimationTestController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AnimationTestController") as? AnimationTestController
        return controller
    }
}
