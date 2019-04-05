//
//  SingleSessionPageMoreDetailAlertController.swift
//  Chatalyze
//
//  Created by mansa infotech on 05/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SingleSessionPageMoreDetailAlertController: UIViewController {
    
    @IBOutlet var threeEdgesView:UIView?
    @IBOutlet var titleScroll:UIScrollView?
    @IBOutlet var dateScroll:UIScrollView?
    @IBOutlet var timeScroll:UIScrollView?
    @IBOutlet var sessionLengthScroll:UIScrollView?
    @IBOutlet var singleChatScroll:UIScrollView?
    @IBOutlet var chatPriceScroll:UIScrollView?
    @IBOutlet var donationScroll:UIScrollView?
    @IBOutlet var screenShotScroll:UIScrollView?
    
    enum infoType:Int{
    
        case title = 0
        case date = 1
        case time = 2
        case sessionLength = 3
        case singleChatLength = 4
        case chatPrice = 5
        case donation = 6
        case screenShot = 7
        case none = 8
    }
    
    var currentInfo = infoType.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintInterface()
    }
    
    
    func paintInterface(){
        
        if currentInfo == .none {
            return
        }
        if currentInfo == .title {
            hideAll()
            self.titleScroll?.isHidden = false
            return
        }
        if currentInfo == .date {
            hideAll()
            self.dateScroll?.isHidden = false
            return
        }
        if currentInfo == .time {
            hideAll()
            self.timeScroll?.isHidden = false
            return
        }
        if currentInfo == .sessionLength {
            hideAll()
            self.sessionLengthScroll?.isHidden = false
            return
        }
        if currentInfo == .singleChatLength {
            hideAll()
            self.singleChatScroll?.isHidden = false
            return
        }
        if currentInfo == .chatPrice {
            hideAll()
            self.chatPriceScroll?.isHidden = false
            return
        }
        if currentInfo == .donation {
            hideAll()
            self.donationScroll?.isHidden = false
            return
        }
        if currentInfo == .screenShot {
            hideAll()
            self.screenShotScroll?.isHidden = false
            return
        }
    }
    
    @IBAction func dismissAction(sender:UIButton?){
        
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func showContactUsScreen(sender:UIButton?){
       
        self.dismiss(animated: false) {
            RootControllerManager().getCurrentController()?.showContactUsAnalyst()
        }        
    }
    
    
    func hideAll(){
        
        self.titleScroll?.isHidden = true
        self.dateScroll?.isHidden = true
        self.timeScroll?.isHidden = true
        self.sessionLengthScroll?.isHidden = true
        self.singleChatScroll?.isHidden = true
        self.chatPriceScroll?.isHidden = true
        self.donationScroll?.isHidden = true
        self.screenShotScroll?.isHidden = true
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        self.threeEdgesView?.roundCorners(corners: [.bottomRight,.topLeft,.topRight], radius: 25)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    class func instance()->SingleSessionPageMoreDetailAlertController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSessionSinglePage", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SingleSessionPageMoreDetailAlert") as? SingleSessionPageMoreDetailAlertController
        return controller
    }
}
