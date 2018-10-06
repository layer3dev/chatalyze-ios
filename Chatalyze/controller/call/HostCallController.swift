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
    
    //For animation
    var isAnimating = false
    
    @IBOutlet var selfieTimerView:SelfieTimerView?
    var connectionInfo : [String : HostCallConnection] =  [String : HostCallConnection]()
        
    
    
    override func initialization(){
        super.initialization()
        
        initializeVariable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerForTimerNotification()
    }
    
    var hostActionContainer : HostVideoActionContainer?{
        get{
            return actionContainer as? HostVideoActionContainer
        }
    }
    
    @IBAction private func hangupAction(){
        toggleHangup()
    }
    
    private func toggleHangup(){
        
        guard let slot = self.eventInfo?.mergeSlotInfo?.currentSlot
            else{
                return
        }
        
        let isHangedUp = !slot.isHangedUp
        slot.isHangedUp = isHangedUp
        
        isHangedUp ? hostActionContainer?.hangupView?.deactivate() : hostActionContainer?.hangupView?.activate()
        
        refreshStreamLock()
        
        let hashedUserId = slot.user?.hashedId ?? ""
        updateUserOfHangup(hashedUserId : hashedUserId, hangup : isHangedUp)
    }
    
    private func refreshStreamLock(){
        
        guard let slot = self.eventInfo?.mergeSlotInfo?.currentSlot
            else{
                localMediaPackage?.isDisabled = false
                return
        }
        localMediaPackage?.isDisabled = slot.isHangedUp
    }
    
    private func updateUserOfHangup(hashedUserId : String, hangup : Bool){
        
        //{"id":"hangUp","value":true,"name":"chedddiicdaibdia"}
        var param = [String : Any]()
        param["id"] = "hangUp"
        param["value"] = hangup
        param["name"] = hashedUserId
        socketClient?.emit(param)
    }
    
    
    
    //public - Need to be access by child
    override var peerConnection : ARDAppClient?{
        get{
            return getActiveConnection()?.connection
        }
    }
    
    var hostRootView : HostVideoRootView?{
        return self.view as? HostVideoRootView
    }
    
    private func initializeVariable(){
        
        self.registerForTimerNotification()
        self.registerForListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Log.echo(key: "yud", text: "I am resetting the selfieTimer")
        selfieTimerView?.reset()
    }
    
    
    private func registerForTimerNotification(){
        
        socketClient?.onEvent("screenshotCountDown", completion: { (response) in
            
            Log.echo(key: "yud", text: "Response in screenshotCountDown is \(String(describing: response))")
            if let responseDict:[String:JSON] = response?.dictionary{
                if let dateDict:[String:JSON] = responseDict["message"]?.dictionary{
                    if let date = dateDict["timerStartsAt"]?.stringValue{
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                       
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        var requiredDate:Date?
                        
                        if let newdate = dateFormatter.date(from: date){
                            
                            requiredDate = newdate
                        }else{
                            
                            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                            requiredDate = dateFormatter.date(from: date)
                        }
                        
                        Log.echo(key: "yud", text: "Date of the CountDown is \(requiredDate)")
                        
                        Log.echo(key: "yud", text: "connection status and the \(requiredDate)")
                        
                        guard let connection = self.getActiveConnection() else{
                            return
                        }
                        if connection.isConnected{
                            
                            self.selfieTimerView?.reset()
                            self.selfieTimerView?.startAnimationForHost(date: requiredDate)
                            
                            self.selfieTimerView?.screenShotListner = {
                                self.mimicScreenShotFlash()
                                self.selfieTimerView?.reset()
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
        refresh()
        updateLableAnimation()
    }
    
    private func refresh(){
       
        refreshStreamLock()
    }
    
    private func getActiveConnection()->HostCallConnection?{
        
        guard let slot = eventInfo?.mergeSlotInfo?.currentSlot
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
        
        guard let slot = eventInfo?.mergeSlotInfo?.currentSlot
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
        
        guard let slotInfo = self.eventInfo?.mergeSlotInfo?.upcomingSlot
            else{
                updateCallHeaderForEmptySlot()
                return
        }
        hostRootView?.callInfoContainer?.slotUserName?.text = slotInfo.user?.firstName
        if(slotInfo.isFuture){
            updateCallHeaderForFuture(slot : slotInfo)
        }else{
            updateCallHeaderForLiveCall(slot: slotInfo)
        }
    }
    
    private func updateCallHeaderForEmptySlot(){
        
        hostRootView?.callInfoContainer?.slotUserName?.text = ""
        hostRootView?.callInfoContainer?.timer?.text = ""
        hostRootView?.callInfoContainer?.slotCount?.text = ""
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
        let currentSlot = (self.eventInfo?.upcomingSlotInfo?.index ?? 0)
        let slotCountFormatted = "Slot : \(currentSlot + 1)/\(slotCount)"
        hostRootView?.callInfoContainer?.slotCount?.text = slotCountFormatted
    }
    
    
    func updateLableAnimation(){
        
        guard let currentSlot = self.eventInfo?.mergeSlotInfo?.currentSlot
            else{
                
                Log.echo(key: "animation", text: "stopAnimation")
                isAnimating = false
                stopLableAnimation()
                return
        }
        
        if let endDate = (currentSlot.endDate?.timeIntervalSinceNow) {
            
            if endDate < 15.0 && endDate >= 1.0 && isAnimating == false {
                
                isAnimating = true
                startLableAnimating(label: hostRootView?.callInfoContainer?.timer)
                return
            }
            if endDate <= 0.0{
                
                isAnimating = false
                stopLableAnimation()
                return
            }
            if endDate > 50.0{
                
                isAnimating = false
                stopLableAnimation()
                return
            }
            Log.echo(key: "animation", text: "StartAnimation and the time is \(endDate)")
        }
    }
    
//    func animateUIlabel(){
//
//        var bounds = (hostRootView?.callInfoContainer?.timer?.bounds) ?? CGRect()
//        bounds.size = (hostRootView?.callInfoContainer?.timer?.intrinsicContentSize) ?? CGSize()
//        let scaleX = bounds.size.width / ((hostRootView?.callInfoContainer?.timer?.frame.size.width) ?? 0.0)
//        let scaleY = bounds.size.height / ((hostRootView?.callInfoContainer?.timer?.frame.size.height) ?? 0.0)
//        UIView.animate(withDuration: 1.0, animations: {
//            self.hostRootView?.callInfoContainer?.timer?.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
//        }, completion: { done in
//            self.hostRootView?.callInfoContainer?.timer?.font = labelCopy.font
//            self.hostRootView?.callInfoContainer?.timer?.transform = .identity
//            self.hostRootView?.callInfoContainer?.timer?.bounds = bounds
//        })
//    }
    
    
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
        verifyIfExpired()
    }
    
    private func verifyIfExpired(){
        
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        if(!eventInfo.isExpired){
            return
        }
        
        self.processExitAction()
        eventCompleted()
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
        
        guard let preConnectSlot = eventInfo.mergeSlotInfo?.preConnectSlot
            else{
//                Log.echo(key: "processEvent", text: "preConnectUser -> preconnectSlot is nil")
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
        
        guard let slot = eventInfo.mergeSlotInfo?.currentSlot
            else{
//                Log.echo(key: "processEvent", text: "preConnectUser -> preconnectSlot is nil")
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
//            Log.echo(key: "processEvent", text: "connectUser -> user is offline")
            return
        }
        if(connection.isInitiated){
            return
        }
        Log.echo(key: "processEvent", text: "connectUser -> initateHandshake")
        if(slot.isHangedUp){
            return
        }
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
    
    override func exit(){
        super.exit()
        
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
            Log.echo(key: "yud", text: "First activates startDate is \(self.eventInfo?.started)")
            self.fetchInfoAfterActivatIngEvent()
        }
    }
   
    
    override func handleMultipleTabOpening(){
     
        DispatchQueue.main.async {
            
            guard let controller = OpenCallAlertController.instance() else{
                return
            }
            controller.dismissHandler = {
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: {
                    })
                }
            }
            self.present(controller, animated: false, completion: {
            })
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
