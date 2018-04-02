//
//  HostEventQueueController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostEventQueueController: EventQueueController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialization(){
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func refresh(){
        super.refresh()
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        if(eventInfo.isPreconnectEligible || eventInfo.isLIVE){
            guard let controller = HostCallController.instance()
                else{
                    return
            }
            
            guard let eventId = self.eventInfo?.id
                else{
                    return
            }
            controller.eventInfo = eventInfo
            controller.eventId = "\(eventId)"
            
            timer.pauseTimer()
            
            self.navigationController?.present(controller, animated: true, completion: { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            })
        }
    }


}