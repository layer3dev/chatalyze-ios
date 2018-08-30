//
//  SessionDoneRootView.swift
//  Chatalyze
//
//  Created by Mansa on 27/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import EventKit

class SessionDoneRootView:ExtendedView{
    
    @IBOutlet var underlineLabel:UILabel?
    var controller:SessionDoneController?
    let eventStore = EKEventStore()
    var param = [String:Any]()
    
    override func viewDidLayout() {
        super.viewDidLayout()
       
        underLineLable()
    }
    
    
    func underLineLable(){
        
        let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "https://dev.chatalyze.com/sessions/Chat-Session/3459", attributes: underlineAttribute as [NSAttributedStringKey : Any])
        underlineLabel?.attributedText = underlineAttributedString
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if (granted) && (error == nil) {
                
                let event = EKEvent(eventStore: self.eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    func addEvent(){
        
        let startDate = DateParser.getDateTimeInUTCFromWeb(dateInString: self.param["start"] as? String, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date()
        
        let endDate = DateParser.getDateTimeInUTCFromWeb(dateInString: self.param["end"] as? String , dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date()
        
        self.controller?.showLoader()
        
        addEventToCalendar(title: "Chatalyze Event", description: "Your session is officially scheduled. Now add the session to your calendar.", startDate: startDate, endDate: endDate) { (success, error) in
            
            self.controller?.stopLoader()
            if success{
                
                let alert = UIAlertController(title: "Chatalyze", message: "Event successfully added to calendar", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert) in
                }))
                self.controller?.present(alert, animated: false, completion: {
                })
                return
            }
            self.noPermission()
            return
        }
    }
    
    @IBAction func addToCalendarAction(sender:UIButton){
        
        sender.isUserInteractionEnabled = false
        generateEvent()
    }
    func generateEvent() {
        
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch (status)
        {
        case EKAuthorizationStatus.notDetermined:
            addEvent()
            break
        case EKAuthorizationStatus.authorized:
            addEvent()
            break
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            noPermission()
            break
        }
    }
    
    
    func noPermission(){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide the permission to access the calender.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert) in
            
            if let settingUrl = URL(string:UIApplicationOpenSettingsURLString){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl)
                } else {
                    //Fallback on earlier versions
                }
            }
        }))
        self.controller?.present(alert, animated: false, completion: {
        })
    }
    
}




