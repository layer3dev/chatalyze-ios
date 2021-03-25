//
//  MySessionTableViewCell.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import EventKit

class MySessionTableViewCell: ExtendedTableCell {
    
    @IBOutlet var mainView:UIView?
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var title:UILabel?
    @IBOutlet var ticketsBooked:UILabel?
    var info:EventInfo?
    var enterSession:((EventInfo?)->())?
    @IBOutlet var sessionEventButton:UIView?
    @IBOutlet var joinButton:UIButton?
    let eventStore = EKEventStore()
    var adapter:MySessionAdapter?
    @IBOutlet var editSessionLbl:UILabel?
    @IBOutlet var viewDetailView:ButtonCorners?
    @IBOutlet var enterSessionLabel:UILabel?
    
    var isPastEvents = false
    
    @IBOutlet var editView:UIView?
    @IBOutlet var addToCalender:UIView?
    
    @IBOutlet var purpleImage:UIImageView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
        roundToMainView()
    }
    
    func paintPastFields(){
        
        if isPastEvents{
            
            self.sessionEventButton?.isHidden = true
            self.editView?.isHidden = true
            self.addToCalender?.isHidden = true
            return
        }
        self.sessionEventButton?.isHidden = false
        self.editView?.isHidden = false
        self.addToCalender?.isHidden = false
        return
    }
    
    func roundToMainView(){
        
        mainView?.layer.cornerRadius = 5
        mainView?.layer.borderWidth = 1
        mainView?.layer.borderColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1).cgColor
    }
    
    @IBAction func editSession(sender:UIButton){
        
        guard let controller = EditSessionFormController.instance() else{
            return
        }
        
        controller.eventInfo = self.info
        self.adapter?.root?.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func viewSessionDetailAction(sender:UIButton){
        
        guard let controller = SessionDetailController.instance() else{
            return
        }
        controller.eventInfo = self.info
        self.adapter?.root?.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func painInterface(){
        
        viewDetailView?.layer.borderWidth = 1
        viewDetailView?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
        
        DispatchQueue.main.async {
            
            var fontSize = 14
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                fontSize = 19
            }
            
            let text = "EDIT PAGE"
            let attrStr = text.toAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#97cefa"), isUnderLine: true)
            self.editSessionLbl?.attributedText = attrStr
        }
        
        self.selectionStyle = .none
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            joinButton?.layer.cornerRadius = 5
            joinButton?.layer.masksToBounds = true
            return
        }
        joinButton?.layer.cornerRadius = 3
        joinButton?.layer.masksToBounds = true
    }
    
    func fillInfo(info:EventInfo?){
        
        guard let info = info  else {
            return
        }
        self.info = info
        paintPastFields()
        if let title = info.title{
            
            self.title?.text = title
        }
        
        if let startDate = info.startDate{
            if let endDate = info.endDate{
                let timeDiffrence = endDate.timeIntervalSince(startDate)
                if let durate  = info.duration{
                    UserDefaults.standard.setValue(durate, forKey: "durate")
                    let totalnumberofslots = Int(timeDiffrence/(durate*60))
                    self.ticketsBooked?.text = "\(info.callBookings.count) of \(totalnumberofslots-(self.checkExactEmptySlots())) booked"
                }
            }
        }
        setDate()
        paintEnterSession()
    }
    
    func paintEnterSession(){
        
        sessionEventButton?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        
        if (self.info?.startDate?.timeIntervalSince(Date()) ?? 0.0) > 1800.0 {
            
            sessionEventButton?.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
            self.purpleImage?.isHidden = true
            enterSessionLabel?.textColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1)
            // Event is not started yet
            return
        }
        sessionEventButton?.backgroundColor = UIColor(red: 150.0/255.0, green: 206.0/255.0, blue: 247.0/255.0, alpha: 1)
        self.purpleImage?.isHidden = false
        enterSessionLabel?.textColor = UIColor.white
        return
    }
    
    func setDate(){
        
        guard let info = self.info else {
            return
        }
        
        if let date = info.startDate {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            self.dateLbl?.text = "\(dateFormatter.string(from: date))"
        }
        
        if let date = info.startDate {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            let requireOne = dateFormatter.string(from: date)
            
            if let date = info.endDate{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.locale = Locale.current
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                self.timeLbl?.text = "\(requireOne) - \(dateFormatter.string(from: date)) \(TimeZone.current.abbreviation() ?? "")"
                Log.echo(key: "yud", text: "Locale abbrvation is ")
            }
        }
    }
    
    func showAlert(sender:UIButton) {
        
        let alertMessage = HandlingAppVersion().getAlertMessage()
        
        let alertActionSheet = UIAlertController(title: AppInfoConfig.appName, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        
        let uploadAction = UIAlertAction(title: "Update App", style: UIAlertAction.Style.default) { (success) in
            HandlingAppVersion.goToAppStoreForUpdate()
        }
        
        let callRoomAction = UIAlertAction(title: "Continue to Session", style: UIAlertAction.Style.default) { (success) in
            self.gotoSession()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) { (success) in
        }
        
        alertActionSheet.addAction(uploadAction)
        alertActionSheet.addAction(callRoomAction)
        alertActionSheet.addAction(cancel)
        
        //alertActionSheet.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        if let presenter = alertActionSheet.popoverPresentationController {
            
            alertActionSheet.popoverPresentationController?.sourceView =                 RootControllerManager().getCurrentController()?.view
            alertActionSheet.popoverPresentationController?.sourceRect = sender.frame
        }
        
        RootControllerManager().getCurrentController()?.present(alertActionSheet, animated: true) {
        }
        //self.root?.controller?.present
    }
    
    
    

    
    private func gotoSession(){
        if (self.info?.startDate?.timeIntervalSince(Date()) ?? 0.0) > 1800.0{
            
            Log.echo(key: "yud", text: "You'll be able to enter your session 30 minutes before it starts")
            RootControllerManager().getCurrentController()?.alert(withTitle: AppInfoConfig.appName, message: "You'll be able to enter your session 30 minutes before it starts", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                
                self.enterSession?(nil)
            })
            return
        }
        
        if let session = enterSession{
            session(self.info)
        }
    }
    
    
    @IBAction func enterSessionAction(sender:UIButton?){
        
        if HandlingAppVersion().getAlertMessage() != "" {
            showAlert(sender: sender ?? UIButton())
            return
        }
        //@abhishek: calling tbe below function, the local stream get stuck if app moved to background
//        guard let controller = InternetSpeedTestController.instance() else {
//            return
//        }
//
//        controller.onlySystemTest = true
//        controller.modalPresentationStyle = .fullScreen
//        controller.onDoneBlock =  {[weak self](success)in
//            DispatchQueue.main.async {
//                self?.gotoSession()
//            }
//
//        }
//
//        RootControllerManager().getCurrentController()?.present(controller, animated: true, completion: nil)
        self.gotoSession()
    }

}

extension MySessionTableViewCell{
    
    func checkStatusAndGetAllEvents() {
        
        let currentStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch currentStatus {
        case .authorized:
            self.getEvents(startDate:self.info?.startDate, endDate:self.info?.endDate)
        case .notDetermined:
            //print("notDetermined")
            eventStore.requestAccess(to: .event) { accessGranted, error in
                if accessGranted {
                    self.getEvents(startDate:self.info?.startDate, endDate:self.info?.endDate)
                    return
                } else {
                    self.noPermission()
                    return
                    //                    print("Change Settings to Allow Access")
                }
            }
        case .restricted:
            noPermission()
            return
        case .denied:
            noPermission()
            return
        }
    }
    
    
    private func getEvents(startDate:Date?, endDate:Date?) {
        
        guard let start = startDate else{
            return
        }
        
        guard let end = endDate else {
            return
        }
        
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            
            guard calendar.allowsContentModifications else {
                continue
            }
            let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: [calendar])
            let events = eventStore.events(matching: predicate)
            for event in events {
                if  "\(self.info?.id ?? 0 )" == "\(event.notes ?? "")"{
                    self.alreadyExisitingEventError()
                    return
                }
                
                //                print("title: \(event.title!)")
                //                print("startDate: \(event.startDate!)")
                //                print("EndDate: \(event.endDate!)")
                //               print("notes are : \(String(describing: event.notes ?? ""))")
            }
            addEvent()
        }
    }
    
    
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date,id:String? = "", completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if (granted) && (error == nil){
                
                let event = EKEvent(eventStore: self.eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = "\(self.info?.id ?? 0)"
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
        
        let startDate = DateParser.getDateTimeInUTCFromWeb(dateInString: self.info?.start, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date()
        
        let endDate = DateParser.getDateTimeInUTCFromWeb(dateInString: self.info?.end , dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date()
        
        RootControllerManager().getCurrentController()?.showLoader()
        
        addEventToCalendar(title: "Chatalyze Event", description: "Your session is officially scheduled. Now add the session to your calendar.", startDate: startDate, endDate: endDate) { (success, error) in
            
            DispatchQueue.main.async {
                
                RootControllerManager().getCurrentController()?.stopLoader()
                
                if success{
                    
                    let alert = UIAlertController(title: "Chatalyze", message: "Event successfully added to calendar", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (alert) in
                    }))
                    
                    RootControllerManager().getCurrentController()?.present(alert, animated: false, completion: {
                    })
                    return
                }
                self.noPermission()
                return
            }
        }
    }
    
    @IBAction func addToCalendarAction(sender:UIButton){
        
        //sender.isUserInteractionEnabled = false
        checkStatusAndGetAllEvents()
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
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide the permission to access the calender.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (alert) in
            
            if let settingUrl = URL(string:UIApplication.openSettingsURLString){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl)
                } else {
                    //Fallback on earlier versions
                }
            }
        }))
        RootControllerManager().getCurrentController()?.present(alert, animated: false, completion: {
        })
    }
    
    
    func alreadyExisitingEventError(){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Event is already added to the calendar.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (alert) in
        }))
        RootControllerManager().getCurrentController()?.present(alert, animated: false, completion: {
        })
    }
}


extension MySessionTableViewCell{
    
    private func checkExactEmptySlots()->Int{
        
        var emptySlots = 0
        
        for info in self.info?.emptySlotsArray ?? []{
            
            if let dict = info.dictionary{
                
                // Log.echo(key: "yud", text: "json info dict is \(info)")
                //
                // Log.echo(key: "yud", text: "end string is \(info)  end date is \(DateParser.UTCStringToDate(dict["end"]?.stringValue ?? ""))")
                //
                var breakDate:Date? = nil
                
                if let date = DateParser.UTCStringToDate(dict["end"]?.stringValue ?? ""){
                    breakDate = date
                }else{
                    
                    if let newDate = DateParser.getDateTimeInUTCFromWeb(dateInString:(dict["end"]?.stringValue ?? ""), dateFormat: "yyyy-MM-dd HH:mm:ss Z"){
                        breakDate = newDate
                    }
                }
                
                if let requiredBreakEndDate = breakDate{
                    
                    if self.info?.endDate?.timeIntervalSince(requiredBreakEndDate) ?? -1.0 >=  0.0 {
                        emptySlots = emptySlots + 1
                    }
                }
            }
        }
        Log.echo(key: "yud", text: "Exact empty slots are  \(emptySlots)")
        return emptySlots
    }
}
