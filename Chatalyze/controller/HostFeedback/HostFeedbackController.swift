//
//  HostFeedbackController.swift
//  Chatalyze
//
//  Created by mansa infotech on 05/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class HostFeedbackController: InterfaceExtendedController {
    
    @IBOutlet var priceLabel:UILabel?
    weak var lastPresentingController: UIViewController?
    var sessionId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lastPresentingController = self.presentingViewController
        paintInterface()
        earningInfo()
    }
    
    func earningInfo(){
        
        guard let id = sessionId else{
            return
        }
        
        self.showLoader()
        FetchSessionEarningForHostProcessor().fetchInfo(sessionId:id) { (success, response) in
            self.stopLoader()
            Log.echo(key: "yud", text: "RESPONSE IS \(response)")
            if !success {
                return
            }
            let obj = SessionEarningInfoForHost(info: response)
            self.priceLabel?.text = "$\(obj.expHostShare ?? "")"
        }
    }
    
    
    func paintInterface(){
        
        paintNavigationTitle(text: "Host Feedback")
        paintBackButton()
    }
    
    @IBAction func goToMySession(sender:UIButton){
        
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func scheduleSession(sender:UIButton){
        
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                RootControllerManager().getCurrentController()?.setScheduleSession()
            }
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
    
    class func instance()->HostFeedbackController?{
        
        let storyboard = UIStoryboard(name: "HostFeedback", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HostFeedback") as? HostFeedbackController
        return controller
    }
}
