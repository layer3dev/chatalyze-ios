//
//  HostCallController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 27/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class HostCallController: VideoCallController {
        
    @IBOutlet var selfieTimerView:SelfieTimerView?
    var connectionInfo : [String : HostCallConnection] =  [String : HostCallConnection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    
    func checkDateFormat(date:String){

        //Sat, 21 Jul 2018 11:11:19 GMT
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let requiredDate = dateFormatter.date(from: "Sat, 21 Jul 2018 11:11:19 GMT")
        
        Log.echo(key: "yud", text: "Required date is \(requiredDate)")

        let currentDate = Date()
        let difference = currentDate.timeIntervalSince(requiredDate ?? Date())
        
        Log.echo(key: "yud", text: "Time Diffrence of the date is\(difference)")
        
        let newDateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
    }
    
    //public - Need to be access by child
    override var peerConnection : ARDAppClient?{
        get{
            return getActiveConnection()?.connection
        }
    }
    
    private func initialization(){
        initializeVariable()
    }
    
    var hostRootView : HostVideoRootView?{
        return self.view as? HostVideoRootView
    }
    
    private func initializeVariable(){
        self.registerForTimerNotification()
        self.registerForListeners()
    }
    
    private func registerForTimerNotification(){
        
        socketClient?.onEvent("screenshotCountDown", completion: { (response) in
            
            Log.echo(key: "yud", text: "Response in screenshotCountDown is \(response)")
            if let responseDict:[String:JSON] = response?.dictionary{
                if let dateDict:[String:JSON] = responseDict["message"]?.dictionary{
                    if let date = dateDict["timerStartsAt"]?.stringValue{
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                        let requiredDate = dateFormatter.date(from: date)
                        guard let connection = self.getActiveConnection() else{
                            return
                        }
                        if connection.isConnected{
                            
                            self.selfieTimerView?.startAnimationForHost(date: requiredDate)
                            self.selfieTimerView?.screenShotListner = {
                            }
                        }                       
                    }
                }
            }
            
            
        })
    }
    
    override func registerForListeners(){
        super.registerForListeners()
    }
    override func isExpired()->Bool{
        
        if(eventInfo?.isExpired ?? true){
            return true
        }
        return false
    }
    
    override func interval(){
     
        processEvent()
        confirmCallLinked()
        updateCallHeaderInfo()
    }
    
    private func getActiveConnection()->HostCallConnection?{
        
        guard let slot = eventInfo?.currentSlotFromMerge
            else{
                return nil
        }
        guard let connection = getWriteConnection(slotInfo: slot)
            else{
                return nil
        }
        return connection
    }
    
    
    private func confirmCallLinked(){
        
        guard let slot = eventInfo?.currentSlotFromMerge
            else{
                return
        }
        guard let connection = getWriteConnection(slotInfo: slot)
            else{
                return
        }
        if(slot.isLIVE){
            connection.linkCall()
        }
    }
    
    private func updateCallHeaderInfo(){
        
        var slot = self.eventInfo?.currentSlotFromMerge
        if(slot == nil){
            slot = self.eventInfo?.preConnectSlotFromMerge
        }
        guard let slotInfo = slot
            else{
                return
        }
        if(slotInfo.isFuture){
            updateCallHeaderForFuture(slot : slotInfo)
        }else{
            updateCallHeaderForLiveCall(slot: slotInfo)
        }
        hostRootView?.callInfoContainer?.slotUserName?.text = self.eventInfo?.currentSlot?.user?.firstName
    }
    
    private func updateCallHeaderForLiveCall(slot : SlotInfo){
        guard let startDate = slot.endDate
            else{
                return
        }
        
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else{
                return
        }
        
        hostRootView?.callInfoContainer?.timer?.text = "\(counddownInfo.time)"
        
        let slotCount = self.eventInfo?.slotInfos?.count ?? 0
        
        let currentSlot = (self.eventInfo?.currentSlotInfo?.index ?? 0)
        let slotCountFormatted = "Slot : \(currentSlot + 1)/\(slotCount)"
        
        hostRootView?.callInfoContainer?.slotCount?.text = slotCountFormatted
    }
    
    private func updateCallHeaderForFuture(slot : SlotInfo){
        guard let startDate = slot.startDate
            else{
                return
        }
        
        
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else{
                return
        }
        
        
        hostRootView?.callInfoContainer?.timer?.text = "Starts in : \(counddownInfo.time)"
        
        let slotCount = self.eventInfo?.slotInfos?.count ?? 0
        
        
        let currentSlot = (self.eventInfo?.preConnectSlotInfo?.index ?? 0)
        let slotCountFormatted = "Slot : \(currentSlot + 1)/\(slotCount)"
        
        hostRootView?.callInfoContainer?.slotCount?.text = slotCountFormatted
    }
    
    
    private func processEvent(){
    
        if(!(socketClient?.isConnected ?? false)){
//            Log.echo(key: "processEvent", text: "processEvent -> socket not connected")
            return
        }
        else{
//            Log.echo(key: "processEvent", text: "processEvent -> socket connected")
        }
        guard let eventInfo = self.eventInfo
            else{
//                Log.echo(key: "processEvent", text: "processEvent -> eventInfo is nil")
                return
        }
        
        if(eventInfo.started == nil){
//            Log.echo(key: "processEvent", text: "event not activated yet")
            return
        }
    

        preconnectUser()
        connectLiveUser()
        disconnectStaleConnection()
        
    }
    
    private func disconnectStaleConnection(){
        for (key, connection) in connectionInfo {
            
            guard let slotInfo = connection.slotInfo
                else{
                    return
            }
            
            if(slotInfo.isExpired){
                connection.disconnect()
                connectionInfo[key] = nil
            }
        }
    }
    
    
    private func preconnectUser(){
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "processEvent", text: "preConnectUser -> eventInfo is nil")
                return
        }
        
        guard let preConnectSlot = eventInfo.preConnectSlotFromMerge
            else{
                Log.echo(key: "processEvent", text: "preConnectUser -> preconnectSlot is nil")
                return
        }
        
        connectUser(slotInfo: preConnectSlot)
    }
    
    private func connectLiveUser(){
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "processEvent", text: "preConnectUser -> eventInfo is nil")
                return
        }
        
        guard let slot = eventInfo.currentSlotFromMerge
            else{
                Log.echo(key: "processEvent", text: "preConnectUser -> preconnectSlot is nil")
                return
        }
        
        connectUser(slotInfo: slot)
    }
    
    private func connectUser(slotInfo : SlotInfo?){
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "processEvent", text: "connectUser -> eventInfo is nil")
                return
        }
        
        guard let slot = slotInfo
            else{
                Log.echo(key: "processEvent", text: "connectUser -> slot is nil")
                return
        }
        
        guard let connection = getWriteConnection(slotInfo : slot)
            else{
                Log.echo(key: "processEvent", text: "connectUser -> getWriteConnection is nil")
                return
        }
        
        guard let targetHashedId = slot.user?.hashedId
            else{
                Log.echo(key: "processEvent", text: "connectUser -> targetHashedId is nil")
                return
        }
        
        if(!isOnline(hashId: targetHashedId)){
            Log.echo(key: "processEvent", text: "connectUser -> user is offline")
            return
        }
        if(connection.isInitiated){
            return
        }
        Log.echo(key: "processEvent", text: "connectUser -> initateHandshake")
        connection.initateHandshake()
    }
    
    
    private func getWriteConnection(slotInfo : SlotInfo?) ->HostCallConnection?{
     
        guard let slotInfo = slotInfo
            else{
                return nil
        }
        
        guard let targetHashedId = slotInfo.user?.hashedId
            else{
                return nil
        }
        
        var connection = connectionInfo[targetHashedId]
        if(connection == nil){
            connection = HostCallConnection(eventInfo: eventInfo, slotInfo: slotInfo, localMediaPackage : localMediaPackage, controller: self)
        }
        connection?.setDisposeListener(disposeListener: { [weak self] in
            self?.connectionInfo[targetHashedId] = nil
        })
        connectionInfo[targetHashedId] = connection
        connection?.slotInfo = slotInfo
        return connection
        
    }
    
    //{"id":"receiveVideoRequest","data":{"sender":"chedddiicdaibdia","receiver":"jgefjedaafbecahc"}}
    
    
    override func hangup(){
        super.hangup()
        
        for (_, connection) in connectionInfo {
            connection.disconnect()
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
        }
    }
    
}


//instance
extension HostCallController{
    class func instance()->HostCallController?{
        let storyboard = UIStoryboard(name: "call_view", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "host_video_call") as? HostCallController
        
        return controller
    }
}
