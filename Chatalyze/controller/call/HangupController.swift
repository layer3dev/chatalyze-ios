//
//  HangupController.swift
//  Chatalyze
//
//  Created by Mansa on 22/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HangupController: InterfaceExtendedController {

    var exit:(()->())?
    var hangup:(()->())?
    @IBOutlet var exitBtn:UIButton?
    @IBOutlet var hangupBtn:UIButton?
    var isHungUp:Bool?
    var isDisableHangup:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        roundView()
        paintDisbleHangup()
        paintHangupButton()
        // Do any additional setup after loading the view.
    }
    
    func paintDisbleHangup(){
        
        guard let isDisable = isDisableHangup else {
            return
        }
        if isDisable{
            
            self.hangupBtn?.isEnabled = false
            self.hangupBtn?.alpha = 0.5
            return
        }
        self.hangupBtn?.isEnabled = true
        self.hangupBtn?.alpha = 1
    }
    
    
    func paintHangupButton(){
        
        guard let isHanged = isHungUp else {
            return
        }
        
        if isHanged{
            
            hangupBtn?.setTitle("RESUME CURRENT CHAT", for: .normal)
            return
        }
        hangupBtn?.setTitle("HANG UP CURRENT CHAT", for: .normal)
    }
    
    
    func roundView(){
       
        exitBtn?.layer.cornerRadius = 3
        exitBtn?.layer.masksToBounds = true
        
        hangupBtn?.layer.cornerRadius = 3
        hangupBtn?.layer.masksToBounds = true
    }
    
    @IBAction func HangUpCall(sender:UIButton){
       
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
                if let hangup = self.hangup{
                    hangup()
                }
            })
        }
    }
    
    @IBAction func exitCall(sender:UIButton){
        
        DispatchQueue.main.async{
            self.dismiss(animated: false, completion: {
                if let exit = self.exit{
                    exit()
                }
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    class func instance()->HangupController?{
        
        let storyboard = UIStoryboard(name: "call_view", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Hangup") as? HangupController
        return controller
    }
    
}
