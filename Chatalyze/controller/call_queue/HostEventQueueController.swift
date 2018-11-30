//
//  HostEventQueueController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostEventQueueController: EventQueueController {
    
    let updatedEventScheduleListner = UpdateEventListener()
    var isEventActivated = false
    
    override func viewDidLayout() {
        super.viewDidLayout()

        eventScheduleUpdatedAlert()
    }
    
    func eventScheduleUpdatedAlert(){
        
        updatedEventScheduleListner.setListener {
            self.loadInfoFromServer(showLoader : true)
        }
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
      
        //&& isEventActivated
       
        if((eventInfo.isPreconnectEligible || eventInfo.isLIVE) ){
            
            Log.echo(key: "rotate", text: "Host Call Controllern new instance Host Event Queue Controller")
            
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
            self.viewDidRelease()
            
            
            
            self.navigationController?.present(controller, animated: true, completion: {
                
                self.navigationController?.popViewController(animated: false)
                
               
            })
        }
    }
    
    override func verifyEventActivated(){
      
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        if(eventInfo.started != nil){
            return
        }
        guard let eventId = eventInfo.id
            else{
                return
        }
        
        let eventIdString = "\(eventId)"
        ActivateEvent().activate(eventId: eventIdString) { (success, eventInfo) in
          
            if(!success){
                return
            }
            
            guard let info = eventInfo
                else{
                    return
            }
            self.eventInfo = info
            self.isEventActivated = true
        }
    }
    
    override func viewDidRelease() {
        super.viewDidRelease()
        
        updatedEventScheduleListner.setListener(listener: nil)
    }
}
