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

    override func viewDidLoad() {
        super.viewDidLoad()

        roundView()
        // Do any additional setup after loading the view.
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
