//
//  DonationSuccessController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import StoreKit

class DonationSuccessController: InterfaceExtendedController {
    
    var price : Double?
    var scheduleInfo : EventScheduleInfo?
    var memoryImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rootView?.fillInfo(price: (price ?? 0.00), scheduleInfo: scheduleInfo)
    }

    var rootView : DonationSuccessRootView?{
        return self.view as? DonationSuccessRootView
    }
    
    @IBAction private func close(){
        
        if self.memoryImage == nil {
            self.showFeedback()
            return
        }
        self.showMemoryScreen()
    }
    
    private func showFeedback(){
        
        guard let controller = ReviewController.instance() else{
            return
        }
        controller.eventInfo = scheduleInfo
        present(controller, animated: false, completion:nil)
    }
    
    
    private func showMemoryScreen(){
        
        guard let controller = MemoryAnimationController.instance() else{
            return
        }
        controller.eventInfo = scheduleInfo
        controller.memoryImage = self.memoryImage
        present(controller, animated: false, completion:nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension DonationSuccessController{
   
    class func instance()->DonationSuccessController? {
        
        let storyboard = UIStoryboard(name: "Tipping", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "donation_success") as? DonationSuccessController
        return controller
    }
}
