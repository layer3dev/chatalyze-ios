//
//  EventDelayController.swift
//  Chatalyze
//
//  Created by Mansa on 14/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventDelayController: UIViewController {

    enum alertType:Int{
    
        case sessionDelay = 0
        case sessionNotStarted = 1
        case none = 2
    }
    
    var alert:alertType  = .none
    @IBOutlet var alertLbl:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        showalert()
        // Do any additional setup after loading the view.
    }
    
    func showalert(){
        
        if alert == .none{
           return
        }
            
        else if alert == .sessionDelay{
            
            alertLbl?.text = "This session has been delayed. Please stay tuned for an updated start time."
        }
            
        else if alert == .sessionNotStarted{
            
            alertLbl?.text = "Session has not started yet."
        }
    }
    
    @IBAction func exit(sender:UIButton){
        
        Log.echo(key: "yud", text: "PrentestingViewController is \(self.presentingViewController)")
        
        DispatchQueue.main.async {
     
            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: {
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
    
    class func instance()->EventDelayController?{
        
        let storyboard = UIStoryboard(name: "call_view", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EventDelay") as? EventDelayController
        return controller
    }

}


