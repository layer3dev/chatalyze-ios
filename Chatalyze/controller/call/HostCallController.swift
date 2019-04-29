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
    
    //In order to maintain the refrence for the Early Controller.
    var earlyControllerReference:EarlyViewController?
    
    //Outlet for sessioninfo.
    @IBOutlet var sessionHeaderLbl:UILabel?
    @IBOutlet var sessionRemainingTimeLbl:UILabel?
    @IBOutlet var sessionCurrentSlotLbl:UILabel?
    @IBOutlet var sessionTotalSlotNumLbl:UILabel?
    @IBOutlet var sessionSlotView:UIView?
    @IBOutlet var breakView:breakFeatureView?
        
    
    //For animation.
    var isAnimating = false
    
    @IBOutlet var selfieTimerView:SelfieTimerView?
    var connectionInfo : [String : HostCallConnection] =  [String : HostCallConnection]()
    
    override var isVideoCallInProgress : Bool{
        
        guard let activeSlot = eventInfo?.mergeSlotInfo?.upcomingSlot
            else{
                return false
        }
        if(activeSlot.isLIVE && (getActiveConnection()?.isConnected ?? false)){
            return true
        }
        return false
    }
        
    // Using in order to prevent to showing the message "Participant did not join session before the slot start."
    
    override var isSlotRunning : Bool {
        
        guard let activeSlot = eventInfo?.mergeSlotInfo?.upcomingSlot
            else{
                return false
        }
        if(activeSlot.isLIVE){
            return true
        }
        return false
    }
    
    override var roomType : UserInfo.roleType{
        return .analyst
    }
    
    override func initialization(){
        super.initialization()
        
        initializeVariable()
    }
    
    override func onExit(code : exitCode){
        super.onExit(code: code)
        
        
        if(code == .prohibited){
            showErrorScreen()
            return
        }
        
        if(code == .earlyExit){
            showEarningInformationScreen()
            return
        }
        
        guard let eventInfo = eventInfo
            else{
                return
        }
        
        if(!eventInfo.isExpired){
            return
        }
        showEarningInformationScreen()
    }
    
    
    func showEarningInformationScreen(){
        
        if self.eventInfo?.slotInfos?.count ?? 0 == 0 {
            return
        }
        
        if self.eventInfo?.isPrivate ?? false{
            return
        }
        
        if self.eventInfo?.isFree ?? false{
            return
        }
      
        guard let controller = HostFeedbackController.instance() else{
            return
        }
      
        controller.sessionId = self.eventId
       
        guard let presentingController =  self.lastPresentingController
            else{
                return
        }
        
        presentingController.present(controller, animated: true, completion: nil)
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
    
    func chatalyzeIconVisibility(){
    }
    
    var isCallHangedUp:Bool{
        
        if let hangUp = self.eventInfo?.mergeSlotInfo?.currentSlot?.isHangedUp{
            if hangUp{
                return true
            }
            return false
        }
        return true
    }
    
    @IBAction private func hangupAction(){
        
        var isDisableHangup = false
        
        if self.eventInfo?.mergeSlotInfo?.currentSlot == nil{
            isDisableHangup = true
        }
        
        guard let controller = HangupController.instance() else{
            return
        }
        
        controller.exit = {
            
            DispatchQueue.main.async {
                self.processExitAction(code : .userAction)
            }
        }
        
        controller.hangup = {
            
            DispatchQueue.main.async {
                self.toggleHangup()
            }
        }
        
        controller.isDisableHangup = isDisableHangup

        //self.eventInfo?.mergeSlotInfo?.currentSlot?.isHangedUp
        controller.isHungUp = self.eventInfo?.mergeSlotInfo?.currentSlot?.isHangedUp
        self.present(controller, animated: true, completion: {
        })
    }
    
    
    private func toggleHangup(){
        
        guard let slot = self.eventInfo?.mergeSlotInfo?.currentSlot
            else{
                return
        }
        
        let isHangedUp = !slot.isHangedUp
        slot.isHangedUp = isHangedUp
        
        isHangedUp ? hostActionContainer?.hangupView?.deactivate() : hostActionContainer?.activateFromHangup()
        
        if(!isHangedUp){
            resetMuteActions()
        }
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
        
        self.hostRootView?.delegateCutsom = self
        self.registerForTimerNotification()
        self.registerForListeners()
        self.selfieTimerView?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Log.echo(key: "yud", text: "I am resetting the selfieTimer")
        selfieTimerView?.reset()
    }
    
    
    private func registerForTimerNotification(){
        
        socketListener?.onEvent("screenshotCountDown", completion: { (response) in
            
            Log.echo(key: "selfie_timer", text: "Response in screenshotCountDown is \(String(describing: response))")
            
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
                            
                            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss z"
                            requiredDate = dateFormatter.date(from: date)
                        }
                        
                        
                        self.selfieTimerView?.reset()
                        self.selfieTimerView?.startAnimationForHost(date: requiredDate)
                        
                        self.selfieTimerView?.screenShotListner = {
                            
                            self.mimicScreenShotFlash()
                            self.selfieTimerView?.reset()
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
        super.interval()
      
        verifyForEarlyFeature()
        triggerIntervalToChildConnections()
        processEvent()
        confirmCallLinked()
        updateCallHeaderInfo()
        refresh()
        updateLableAnimation()
    }
    
    func verifyForPostSessionEarningScreen() {
    }
    
    func verifyForEarlyFeature(){
    
        //Log.echo(key: "yud", text: "Upcoming slot is \(self.eventInfo?.upcomingSlot)")
        // Log.echo(key: "yud", text: "Event Started to testing and the future event status is \(self.eventInfo?.upcomingSlot) presented controller is \(self.getTopMostPresentedController())")
        
        if self.eventInfo?.isLIVE ?? false == false {
            return
        }
        
        if self.eventInfo?.isBreakSlotAvailableInFuture ?? false == true {
            return
        }
        
        if self.eventInfo?.upcomingSlot != nil {
            
            // As we want to show the Alert again as soon as no future event is present.
            if earlyControllerReference != nil {
                
                // Dismissing as soon as we get to know that we have the upcoming slot.
                self.earlyControllerReference?.dismiss(animated: false, completion: nil)
                self.earlyControllerReference = nil
                return
            }
            self.earlyControllerReference = nil
            return
        }
        if earlyControllerReference != nil {
            return
        }
        guard let controller = EarlyViewController.instance() else {
            return
        }
        earlyControllerReference = controller
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.closeRegistration = {

            //Event's Registration is closed
            //Self.earlyControllerRefrence = nil
            self.makeRegistrationClose()
        }
        controller.keepRegistration = {
        }
        self.getTopMostPresentedController()?.present(controller, animated: true, completion: {
        })
    }
    
    override func updateStatusMessage(){
        super.updateStatusMessage()
        
        guard let eventInfo = eventInfo
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        //Is event strictly in preconnect state - startTime < 30 AND startTime > 0
        //if yes, Just show it as pre-connected
        
        if(eventInfo.isPreconnectEligible){
            setStatusMessage(type: .preConnectedSuccess)
            return
        }
        
        //if event starttime is NOT < 30 seconds
        //we want to keep showing the logo, so do nothing
        if(!eventInfo.isWholeConnectEligible){
            setStatusMessage(type: .ideal)
            return
        }
        
        //Is there any slot booked
        //if no, return
        guard let activeSlot = eventInfo.mergeSlotInfo?.upcomingSlot
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        if(!isSocketConnected){
            setStatusMessage(type: .ideal)
            return
        }
        
        guard let activeUser = activeSlot.user
            else{
                setStatusMessage(type: .ideal)
                return
        }
        
        if(!isAvailableInRoom(hashId: activeUser.hashedId) && isSlotRunning && !activeSlot.isBreak){
            setStatusMessage(type : .userDidNotJoin)
            return;
        }
        
        if(activeSlot.isPreconnectEligible){
            setStatusMessage(type: .preConnectedSuccess)
            return
        }
        
        if(activeSlot.isLIVE && (getActiveConnection()?.isStreaming ?? false)){
            setStatusMessage(type: .connected)
            return
        }
        
        setStatusMessage(type: .ideal)
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
    
    private func getPreConnectConnection()->HostCallConnection?{
        
        guard let slot = eventInfo?.mergeSlotInfo?.preConnectSlot
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
        
        
        guard let startDate = self.eventInfo?.startDate
            else{
                return
        }
        
        guard let countdownInfo = startDate.countdownTimeFromNow()
            else{
                return
        }
        
        if(!countdownInfo.isActive){
            
            //            countdownLabel?.updateText(label: "Your chat is finished ", countdown: "finished")
            
            updateCallHeaderAfterEventStart()
            return
        }
                
        // Below code is responsible befor the event start.
        sessionHeaderLbl?.text = "Session starts in:"
        
        var fontSize = 18
        var remainingTimeFontSize = 20
        if  UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24
            remainingTimeFontSize = 26
        }
        
        //Editing For the remaining time
        let countdownTime = "\(countdownInfo.minutes) : \(countdownInfo.seconds)"
        
        let timeRemaining = countdownTime.toAttributedString(font: "Nunito-ExtraBold", size: remainingTimeFontSize, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        sessionRemainingTimeLbl?.attributedText = timeRemaining
        
        //Editing  for the current Chat

        let slotCount = self.eventInfo?.slotInfos?.count ?? 0
        let currentSlot = (self.eventInfo?.mergeSlotInfo?.upcomingSlotInfo?.index ?? 0)
        
        if slotCount <= 0{
            //This info will only be show if slots are greater than one.
            return
        }
        
        let currentSlotText = "Chat \(currentSlot+1): "
        let currentMutatedSlotText = currentSlotText.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        //new username without last name
        var username = ""
        
        if let array = self.eventInfo?.mergeSlotInfo?.upcomingSlot?.user?.firstName?.components(separatedBy: " "){
            
            if array.count >= 1{
                username = array[0]
            }else{
                
                if let name = self.eventInfo?.mergeSlotInfo?.upcomingSlot?.user?.firstName{
                    
                    username  = name
                }
            }
        }else{
            
            if let name = self.eventInfo?.mergeSlotInfo?.upcomingSlot?.user?.firstName{
                username  = name
            }
        }
        
        let slotUserNameAttrStr = username.toAttributedString(font: "Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        currentMutatedSlotText.append(slotUserNameAttrStr)
        sessionCurrentSlotLbl?.attributedText = currentMutatedSlotText
        
        //Editing for the total Chats
        let totatlNumberOfSlotsText = "Total chats: "
        let totalAttrText = totatlNumberOfSlotsText.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        let totalSlots = "\(slotCount)".toAttributedString(font:"Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        totalAttrText.append(totalSlots)
        
        sessionTotalSlotNumLbl?.attributedText = totalAttrText
    }
    
    private func updateCallHeaderAfterEventStart(){
        
        //Editing For the remaining time
        //Above code is responsible for handling the status if event is not started yet.
        
        guard let slotInfo = self.eventInfo?.mergeSlotInfo?.upcomingSlot
            else{
                updateCallHeaderForEmptySlot()
                return
        }
        
        Log.echo(key: "yud", text: "this event is break event \(self.eventInfo?.mergeSlotInfo?.emptySlotsArray?.count)")
        
        if slotInfo.isBreak{

            updateCallHeaderForBreakSlot()
            return
        }
        
        if let array = slotInfo.user?.firstName?.components(separatedBy: " "){
            if array.count >= 1{
              
                hostRootView?.callInfoContainer?.slotUserName?.text = array[0]
            }else{
              
                hostRootView?.callInfoContainer?.slotUserName?.text = slotInfo.user?.firstName
            }
        }else{
           
            hostRootView?.callInfoContainer?.slotUserName?.text = slotInfo.user?.firstName
        }
        
        //Below method is implemented by Yud
        //updateNewHeaderInfoForSession(slot : slotInfo)
        
        if(slotInfo.isFuture){
   
            //when call is not running but we have the slot in the future
            updateTimeRamaingCallHeaderForUpcomingSlot()
            updateNewHeaderInfoForFutureSession(slot : slotInfo)
        }
        else{
            
            //Updating the info text when the call is live.
            updateFutureCallHeaderForEmptySlot()
            updateCallHeaderForLiveCall(slot: slotInfo)
        }
    }
    
    private func updateCallHeaderForEmptySlot(){
        
        updateForEmptyBreak()
        hostRootView?.callInfoContainer?.slotUserName?.text = ""
        hostRootView?.callInfoContainer?.timer?.text = ""
        hostRootView?.callInfoContainer?.slotCount?.text = ""
        sessionRemainingTimeLbl?.text = ""
        sessionCurrentSlotLbl?.text = ""
        sessionTotalSlotNumLbl?.text = ""
        sessionHeaderLbl?.text = ""        
    }
    
    private func updateForEmptyBreak(){
        
        breakView?.disableBreakFeature()
    }
    
    private func updateCallHeaderForBreakSlot(){
      
        //let countdownTime = "\(slotInfo.endDate?.countdownTimeFromNowAppended())"
      
        hostRootView?.callInfoContainer?.slotUserName?.text = ""
        hostRootView?.callInfoContainer?.timer?.text = ""
        hostRootView?.callInfoContainer?.slotCount?.text = ""
        sessionRemainingTimeLbl?.text = ""
        sessionCurrentSlotLbl?.text = ""
        sessionTotalSlotNumLbl?.text = ""
        sessionHeaderLbl?.text = ""
        breakView?.startBreakShowing(time: "\(String(describing: self.eventInfo?.mergeSlotInfo?.upcomingSlot?.endDate?.countdownTimeFromNowAppended()?.time ?? ""))")
    }
    
    private func updateTimeRamaingCallHeaderForUpcomingSlot(){
        
        updateForEmptyBreak()
        hostRootView?.callInfoContainer?.slotUserName?.text = ""
        hostRootView?.callInfoContainer?.timer?.text = ""
        hostRootView?.callInfoContainer?.slotCount?.text = ""
    }
    
    private func updateFutureCallHeaderForEmptySlot(){
        
        updateForEmptyBreak()
        sessionRemainingTimeLbl?.text = ""
        sessionCurrentSlotLbl?.text = ""
        sessionTotalSlotNumLbl?.text = ""
        sessionHeaderLbl?.text = ""
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
        
        Log.echo(key: "yud", text: "updating the live call")
        //hostRootView?.callInfoContainer?.timer?.text = "Time remaining\(counddownInfo.time)"
        hostRootView?.callInfoContainer?.timer?.text = "\(counddownInfo.time)"
        //don't use merged slot for count
        let slotCount = self.eventInfo?.slotInfos?.count ?? 0
        //don't use merged slot for count
        let currentSlot = (self.eventInfo?.currentSlotInfo?.index ?? 0)
        let slotCountFormatted = "\(currentSlot + 1) of \(slotCount)"
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
        let slotCount = self.eventInfo?.mergeSlotInfo?.slotInfos?.count ?? 0
        let currentSlot = (self.eventInfo?.mergeSlotInfo?.upcomingSlotInfo?.index ?? 0)
        let slotCountFormatted = "\(currentSlot + 1) of \(slotCount)"
        hostRootView?.callInfoContainer?.slotCount?.text = slotCountFormatted
    }
    
    
    func updateLableAnimation(){
        
        guard let currentSlot = self.eventInfo?.mergeSlotInfo?.currentSlot
            else{
                
                //Log.echo(key: "animation", text: "stopAnimation")
                isAnimating = false
                stopLableAnimation()
                return
        }
        
        if let endDate = (currentSlot.endDate?.timeIntervalTillNow) {
            
            if endDate < 16.0 && endDate >= 1.0 && isAnimating == false {
                
                isAnimating = true
                startLableAnimating(label: hostRootView?.callInfoContainer?.timer)
                return
            }
            
            if endDate <= 0.0{
                
                isAnimating = false
                stopLableAnimation()
                return
            }
            
            if endDate > 16.0{
                
                //implemented in order to stop Animation if new slot comes and added so that new time slot becomes (120, 180, 300 ..etc.)//
                isAnimating = false
                stopLableAnimation()
                return
            }
            Log.echo(key: "animation", text: "StartAnimation and the time is \(endDate)")
        }
    }
    
    private func processEvent(){
        Log.echo(key : "delay", text : "processEvent")
        
        if(!(socketClient?.isConnected ?? false)){
            Log.echo(key : "delay", text : "processEvent socket NOT connected")
            return
        }
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "processEvent", text: "processEvent -> eventInfo is nil")
                return
        }
        
        if(eventInfo.started == nil){
            Log.echo(key: "processEvent", text: "event not activated yet")
            return
        }
        
        disconnectStaleConnection()
        preconnectUser()
        connectLiveUser()
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
        
        self.processExitAction(code : .expired)
    }
    
    //only two connections at maximum stay in queue at a time
    private func triggerIntervalToChildConnections(){
        for (_, connection) in connectionInfo {
            connection.interval()
        }
    }
    
    private func disconnectStaleConnection(){
    
        for (key, connection) in connectionInfo {
            //remove connection if aborted
            if(connection.isReleased){
                connectionInfo[key] = nil
                return
            }
            
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
              
                //Log.echo(key: "processEvent", text: "preConnectUser -> preconnectSlot is nil")
                return
        }
        
        connectUser(slotInfo: preConnectSlot)
    }
    
    
    private func connectLiveUser(){
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "handshake", text: "connectLiveUser -> eventInfo is nil")
                return
        }
        
        guard let slot = eventInfo.mergeSlotInfo?.currentSlot
            else{
                Log.echo(key: "handshake", text: "connectLiveUser -> slot is nil")
                return
        }
        
        connectUser(slotInfo: slot)
    }
    
    private func connectUser(slotInfo : SlotInfo?){
        
        guard let eventInfo = self.eventInfo
            else{
                Log.echo(key: "handshake", text: "connectUser -> eventInfo is nil")
                return
        }
        
        guard let slot = slotInfo
            else{
                Log.echo(key: "handshake", text: "connectUser -> slot is nil")
                return
        }
        
        guard let connection = getWriteConnection(slotInfo : slot)
            else{
                Log.echo(key: "handshake", text: "connectUser -> getWriteConnection is nil")
                return
        }
        
        guard let targetHashedId = slot.user?.hashedId
            else{
                Log.echo(key: "handshake", text: "connectUser -> targetHashedId is nil")
                return
        }
        
        if(!isOnline(hashId: targetHashedId)){
            Log.echo(key: "handshake", text: "isOnline NO -> targetHashedId")
            return
        }
        
        if(connection.isInitiated){
            Log.echo(key: "handshake", text: "connectUser -> isInitiated")
            return
        }
        
        
        if(slot.isHangedUp){
            Log.echo(key: "handshake", text: "connectUser -> isHangedUp")
            return
        }
        
        Log.echo(key: "handshake", text: "connectUser -> initateHandshake")
        
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
    
    override func exit(code : exitCode){
        super.exit(code : code)
        
        for (_, connection) in connectionInfo {
            connection.disconnect()
        }
    }
    
    override func verifyEventActivated(info : EventScheduleInfo, completion : @escaping ((_ success : Bool, _ info  : EventScheduleInfo?)->())){
        
        let eventInfo = info
        
        //already activated
        if(eventInfo.started != nil){
            completion(true, eventInfo)
            return
        }
        
        guard let eventId = eventInfo.id
            else{
                completion(false, eventInfo)
                return
        }
        
        let eventIdString = "\(eventId)"
        ActivateEvent().activate(eventId: eventIdString) {[weak self] (success, eventInfo) in
            
            //can't use eventInfo received from ActivateEvent because it lags slots information
            self?.refreshInfo(eventInfo : info, completion: completion)
            
        }
    }
    
    
    private func refreshInfo(eventInfo : EventScheduleInfo, completion : @escaping ((_ success : Bool, _ info  : EventScheduleInfo?)->())){
        
        self.loadInfo(completion: { (success, info) in
            if(!success){
                completion(false, eventInfo)
                return
            }
            
            guard let updateInfo = info
                else{
                    completion(false, eventInfo)
                    return
            }
            
            completion(true, updateInfo)
            
        })
    }
    
    var isCallStreaming: Bool{
        
        return (self.getActiveConnection()?.isStreaming ?? false)
    }
    
    
    override func handleMultipleTabOpening(){
        self.processExitAction(code : .prohibited)
        
    }
    
    override func eventCancelled(){
        self.processExitAction(code: .userAction)
        //Event Cancelled
    }
    
    override func hitEventOnSegmentIO(){
      
        SEGAnalytics.shared().track("Session Enter Host")
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

//not in use at the moment
extension HostCallController : CallConnectionProtocol{
    
    func updateConnectionState(state : RTCIceConnectionState, slotInfo : SlotInfo?){
    }
}

extension HostCallController:GetisHangedUpDelegate{
    
    func restartSelfie() {
    }
    
    func getHangUpStatus() -> Bool {
        return isCallHangedUp || (!isCallStreaming)
    }
}


extension HostCallController {
    
    private func updateNewHeaderInfoForFutureSession(slot : SlotInfo){
        
        guard let startDate = slot.startDate
            else{
                return
        }
        
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else{
                return
        }
        
        sessionHeaderLbl?.text = "Chat starts in:"
        
        let slotCount = self.eventInfo?.mergeSlotInfo?.slotInfos?.count ?? 0
        let currentSlot = (self.eventInfo?.mergeSlotInfo?.upcomingSlotInfo?.index ?? 0)
        
        var fontSize = 18
        var remainingTimeFontSize = 20
        if  UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24
            remainingTimeFontSize = 26
        }
        
        //Editing For the remaining time
        
        let timeRemaining = "\(counddownInfo.time)".toAttributedString(font: "Nunito-ExtraBold", size: remainingTimeFontSize, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        
        sessionRemainingTimeLbl?.attributedText = timeRemaining
        
        //Editing  for the current Chat
        
        let currentSlotText = "Chat \(currentSlot+1): "
        let currentMutatedSlotText = currentSlotText.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        //new username without last name
        
        var username = ""
        
        if let array = slot.user?.firstName?.components(separatedBy: " "){
            
            if array.count >= 1{
                
                username = array[0]
            }else{
                
                if let name = slot.user?.firstName{
                    username  = name
                }
            }
        }else{
            
            if let name = slot.user?.firstName{
                username  = name
            }
        }
        
        //End
        if let slotUserName = slot.user?.firstName{
            username = slotUserName
        }
        
        let slotUserNameAttrStr = username.toAttributedString(font: "Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        currentMutatedSlotText.append(slotUserNameAttrStr)
        sessionCurrentSlotLbl?.attributedText = currentMutatedSlotText
        
        //Editing for the total Chats
        
        let totatlNumberOfSlotsText = "Total chats: "
        let totalAttrText = totatlNumberOfSlotsText.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        let totalSlots = "\(slotCount)".toAttributedString(font:"Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        totalAttrText.append(totalSlots)
        
        sessionTotalSlotNumLbl?.attributedText = totalAttrText
    }
}


extension HostCallController{
    
    func makeRegistrationClose(){
        
        Log.echo(key: "yud", text: "Registration is closing")
        self.showLoader()
        CloseRegistration().close(eventId: self.eventId ?? "") { (success) in
            self.stopLoader()
           
            if success{
                self.processExitAction(code : .earlyExit)                
                return
            }
            return
        }
    }
}



