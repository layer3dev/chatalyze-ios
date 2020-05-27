//
//  HostCallController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 27/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Alamofire
import Toast_Swift
import CRToast

class HostCallController: VideoCallController {
    
    @IBOutlet var signaturAccessoryView:AutographSignatureReponseBottomView?
    
    var localSlotIdToManageAutograph :Int? = nil
    var autoGraphInfo:AutographInfo?
    
    var isSignatureActive = false
    var autographSlotInfo : SlotInfo? = nil
    
    //In order to maintain the refrence for the Early Controller.
    var earlyControllerReference:EarlyViewController?
    
    //Outlet for sessioninfo.
    @IBOutlet var sessionHeaderLbl:UILabel?
    @IBOutlet var sessionRemainingTimeLbl:UILabel?
    @IBOutlet var sessionCurrentSlotLbl:UILabel?
    @IBOutlet var sessionTotalSlotNumLbl:UILabel?
    @IBOutlet var sessionSlotView:UIView?
    @IBOutlet var breakView:breakFeatureView?
    @IBOutlet var earlyEndSessionView:UIView?
    
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
        
        presentingController.modalPresentationStyle = .fullScreen
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
                self.processAutographSelfie()
//                self.toggleHangup()
            }
        }
        
        controller.isDisableHangup = isDisableHangup
        
        //self.eventInfo?.mergeSlotInfo?.currentSlot?.isHangedUp
        controller.isHungUp = self.eventInfo?.mergeSlotInfo?.currentSlot?.isHangedUp
        
        controller.modalPresentationStyle = .fullScreen
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
        self.registerForAutographSignatureCall()
        self.signaturAccessoryView?.delegate = self
    }
    
    


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Log.echo(key: "yud", text: "I am resetting the selfieTimer")
        selfieTimerView?.reset()
        changeOrientationToPortrait()
    }
    
    
    private func registerForTimerNotification(){
        
        socketListener?.onEvent("screenshotCountDown", completion: { (response) in
            
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
                            self.processAutographSelfie()
                        }
                    }
                }
            }
        })
    }
    
    private func processAutographSelfie(){
        Log.echo(key: "HostCallController", text: "processAutographSelfie")
        guard let eventInfo = self.eventInfo
            else{
                return
        }
        
        if(!eventInfo.isAutographEnabled){
            return
        }
        
        Log.echo(key: "HostCallController", text: "getSnapshot")
        autographSlotInfo = myLiveUnMergedSlot
        
        self.hostRootView?.getSnapshot(info: self.eventInfo, completion: {(image) in
            guard let image = image
            else{
                return
            }
            
            Log.echo(key: "HostCallController", text: "call renderCanvas")
            
            self.renderCanvas(image : image)
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
        
        //TODO:- Need to uncomment if the signature feature needs to be enable.
        resetAutographCanvasIfNewCallAndSlotExists()
    }
    
    func verifyForPostSessionEarningScreen() {
    }
    
    func verifyForEarlyFeature(){
        
        if self.eventInfo?.isLIVE ?? false == false {
            return
        }
        
        if self.eventInfo?.isValidSlotAvailable != false {
            
            if earlyControllerReference != nil {
                
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
        
        if(!isAvailableInRoom(hashId: activeUser.hashedId) && isSlotRunning && !(eventInfo.isCurrentSlotIsBreak)){
            setStatusMessage(type : .userDidNotJoin)
            resetCanvas()
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
    
    private func getPreConnectConnection()->HostCallConnection? {
        
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
            
            // countdownLabel?.updateText(label: "Your chat is finished ", countdown: "finished")
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
        
        let slotCount = ((self.eventInfo?.slotInfos?.count ?? 0) - (self.eventInfo?.emptySlotsArray?.count ?? 0))
        let currentSlot = (self.eventInfo?.upcomingSlotInfo?.index ?? 0)
        
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
        
        ///MergeSlotInfo includes both the break slots and the live call.
        
        guard let slotInfo = self.eventInfo?.mergeSlotInfo?.upcomingSlot
            else{
                
                updateCallHeaderForEmptySlot()
                return
        }
        
        if  self.eventInfo?.isCurrentSlotIsEmptySlot ?? false && slotInfo.id == nil {
            
            //this will execute only if we do not have the future tickets and current slot is not the break slot.
            
            updateCallHeaderForEmptySlot()
            return
        }
        
        if self.eventInfo?.isCurrentSlotIsBreak ?? false && !(self.eventInfo?.isValidSlotAvailable ?? false ){
            
            updateCallHeaderForEmptySlot()
            return
        }
        
        if self.eventInfo?.isCurrentSlotIsBreak ?? false{
            
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
        sessionCurrentSlotLbl?.text = ""
        sessionTotalSlotNumLbl?.text = ""
        
        guard let endDate = self.eventInfo?.endDate
            else{
                return
        }
        
        guard let countdownInfo = endDate.countdownTimeFromNow()
            else{
                return
        }
        
        // Below code is responsible befor the event start.
        sessionHeaderLbl?.text = "Session ends in:"
        
        var fontSize = 18
        var remainingTimeFontSize = 20
        if  UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24
            remainingTimeFontSize = 26
        }
        
        
        //Editing For the remaining time
        let countdownTime = "\(countdownInfo.hours) : \(countdownInfo.minutes) : \(countdownInfo.seconds)"
        
        let timeRemaining = countdownTime.toAttributedString(font: "Nunito-ExtraBold", size: remainingTimeFontSize, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
        sessionRemainingTimeLbl?.attributedText = timeRemaining
        self.earlyEndSessionView?.isHidden = false
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
        self.earlyEndSessionView?.isHidden = true
        breakView?.startBreakShowing(time: "\(String(describing: self.eventInfo?.mergeSlotInfo?.currentSlot?.endDate?.countdownTimeFromNowAppended()?.time ?? ""))")
        
    }
    
    private func updateTimeRamaingCallHeaderForUpcomingSlot(){
        
        updateForEmptyBreak()
        hostRootView?.callInfoContainer?.slotUserName?.text = ""
        hostRootView?.callInfoContainer?.timer?.text = ""
        hostRootView?.callInfoContainer?.slotCount?.text = ""
        self.earlyEndSessionView?.isHidden = true
    }
    
    private func updateFutureCallHeaderForEmptySlot(){
        
        updateForEmptyBreak()
        sessionRemainingTimeLbl?.text = ""
        sessionCurrentSlotLbl?.text = ""
        sessionTotalSlotNumLbl?.text = ""
        sessionHeaderLbl?.text = ""
        self.earlyEndSessionView?.isHidden = true
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
        let breakSlots = self.eventInfo?.emptySlotsArray?.count ?? 0
        
        Log.echo(key: "yud", text: " Break slots are \(breakSlots) and the  slots are \(slotCount) and the current slot is \(currentSlot)")
        
        if getTotalNUmberOfSlots() > 0{
            
            let slotCountFormatted = "\(currentSlot + 1) of \(getTotalNUmberOfSlots())"
            hostRootView?.callInfoContainer?.slotCount?.text = slotCountFormatted
        }else{
            
            let slotCountFormatted = "\(currentSlot + 1) of \(slotCount)"
            hostRootView?.callInfoContainer?.slotCount?.text = slotCountFormatted
        }
        
        Log.echo(key: "yud", text: "Total number of slots are \(getTotalNUmberOfSlots())")
    }
    
    private func updateCallHeaderForFuture(slot : SlotInfo) {
        
        guard let startDate = slot.startDate
            else {
                return
        }
        
        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
            else {
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
    
    var myLiveUnMergedSlot : SlotInfo?{
        
        guard let slotInfo = eventInfo?.currentSlotInfo?.slotInfo
            else{
                return nil
        }
        return slotInfo
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
        
        let slotCount = self.eventInfo?.slotInfos?.count
        let currentSlot = (self.eventInfo?.upcomingSlotInfo?.index ?? 0)
        
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
        
        let totalSlots = "\(slotCount ?? 0 )".toAttributedString(font:"Nunito-ExtraBold", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
        
        totalAttrText.append(totalSlots)
        
        sessionTotalSlotNumLbl?.attributedText = totalAttrText
    }
}


extension HostCallController{
    
    func makeRegistrationClose(){
        
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



extension HostCallController{
    
    // End session early button Action
    
    @IBAction func endSessionEarly(sender:UIButton?){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Are you sure you want to end your session?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "End session early", style: .default, handler: { (success) in
            
            self.makeRegistrationClose()
        }))
        
        alert.addAction(UIAlertAction(title: "Keep registration open", style: .cancel, handler: { (success) in
        }))
        
        self.present(alert, animated: true) {
        }
    }
}


extension HostCallController{
    
    func getTotalNUmberOfSlots()->Int{
        
        
        guard let startTime = self.eventInfo?.startDate else {
            return 0
        }
        
        guard let endTime = self.eventInfo?.endDate else {
            return 0
        }
        
        let timeDiffreneceOfSlots = endTime.timeIntervalSince(startTime)
        
        let totalminutes = (timeDiffreneceOfSlots/60)
        
        guard let duration = self.eventInfo?.duration else{
            return 0
        }
        
        let totalSlots = Int(totalminutes/duration)
        
        return totalSlots
    }
}

extension HostCallController{
    
    @IBAction func showCanvas(){
        
    }
}



extension HostCallController{
    
    func registerForAutographSignatureCall(){
        
        UserSocket.sharedInstance?.socket?.on("notification") { data, ack in
            
            let rawInfosString = data.JSONDescription()
            guard let data = rawInfosString.data(using: .utf8)
                else{
                    return
            }
            Log.echo(key: "yud", text: "notification ==> \(rawInfosString)")
            var rawInfos:[JSON]?
            do{
                
                rawInfos = try JSON(data : data).arrayValue
            }catch{
                
            }
            if((rawInfos?.count  ?? 0) <= 0){
                return
            }
            let rawInfo = rawInfos?[0]
            let info = NotificationInfo(info: rawInfo)
            
            if (info.metaInfo?.type == .signRequest)
            {
                //TODO:- Need to uncomment this in order to enable the selfie feature. 
//                self.fetchAutographInfo(screenShotId:info.metaInfo?.activityId)
            }
        }
    }
    
    
    func fetchAutographInfo(screenShotId:String?){
        
        guard let id = screenShotId else{
            return
        }
        
        self.showLoader()
        AutographyFetchInfo().fetchInfo(id: id) { (success, info) in
            self.stopLoader()
            
            if(!success){
                return
            }
            self.autoGraphInfo = info
            
            guard let infoCallBookingId  = info?.callBookingId else {
                return
            }
            
            guard let currentSlotId = self.eventInfo?.currentSlotInfo?.slotInfo?.id else{
                return
            }
            
            if String(infoCallBookingId) != String(currentSlotId){                          
                return
            }
            
            self.hostRootView?.canvas?.slotInfo = self.eventInfo?.currentSlotInfo?.slotInfo
            
            self.downLoadScreenShotImage()
            //Download image and send it to the canvas in order to set the image.
        }
    }
    
    fileprivate func downLoadScreenShotImage(){

        guard let info = self.autoGraphInfo else{
            return
        }
        
        guard let urlString = self.autoGraphInfo?.screenshot
            else{
                return
        }
        
        self.showLoader()
        SDWebImageDownloader().downloadImage(with: URL(string:urlString), options: SDWebImageDownloaderOptions.highPriority, progress: { (totalBytesSent, totalBytesExpectedToSend, url) in
            
            DispatchQueue.main.async(execute: {
                
                let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                let progressPercent = Int(uploadProgress*100)
                ///self.downloadLable?.text = "\(progressPercent) %"
                print(progressPercent)
            })
//            print("recieved Size is")
//            print(totalBytesSent)
//            print("Expected Size is")
//            print(totalBytesExpectedToSend)
            
        }) { (image, imageData, error, success) in
            
            DispatchQueue.main.async(execute: {
                
                self.stopLoader()

                Log.echo(key: "point", text: "Image Down loading is successfull \(String(describing: info)) and its frame is \(String(describing: image?.size.height)) and the width is \(String(describing: image?.size.width))")
                
                
                
                if(image == nil){
                    //oops something went wrong please try again
                    return
                }
                
                
                guard let infoCallBookingId  = self.autoGraphInfo?.callBookingId else {
                    return
                }
                
                guard let currentSlotId = self.eventInfo?.currentSlotInfo?.slotInfo?.id else{
                    return
                }
                
                if String(infoCallBookingId) != String(currentSlotId){
                    return
                }
                
                self.lockDeviceOrientation()
                self.hostRootView?.canvasContainer?.show(with:image)

                self.hostRootView?.remoteVideoContainerView?.isSignatureActive = true
                self.hostRootView?.remoteVideoContainerView?.updateForSignature()
                self.signaturAccessoryView?.isHidden = false
                self.isSignatureActive = true
                
                self.hostRootView?.localVideoView?.isSignatureActive = true
                self.hostRootView?.localVideoView?.updateLayoutRotation()
                self.sendScreenshotConfirmation()
                
            })
        }
    }
    
    
    private func renderCanvas(image : UIImage){
        guard let currentSlot = autographSlotInfo
            else{
                return
        }
        
        self.hostRootView?.canvas?.slotInfo = currentSlot
        self.lockDeviceOrientation()
        self.hostRootView?.canvasContainer?.show(with:image)

        self.hostRootView?.remoteVideoContainerView?.isSignatureActive = true
        self.hostRootView?.remoteVideoContainerView?.updateForSignature()
        self.signaturAccessoryView?.isHidden = false
        self.isSignatureActive = true
        
        self.hostRootView?.localVideoView?.isSignatureActive = true
        self.hostRootView?.localVideoView?.updateLayoutRotation()
        
        Log.echo(key: "HostCallController", text: "send screenshot confirmation")
        
        
        sendScreenshotConfirmation()
        
    }
    
    
    
    /*
     "color": "",
            "id": "0",
            "text": "",
            "userId": "1833",
            "analystId": "1674",
            "signed": false,
            "paid": false,
            "screenshot": ""
     */
     
    private func generateAutographInfo() -> [String : Any?]{
        
        var params = [String : Any?]()
        guard let currentSlot = autographSlotInfo
            else{
                return params
        }
        params["userId"] = currentSlot.userId
        params["analystId"] = eventInfo?.userId
        params["screenshot"] = ""
        params["signed"] = false
        params["id"] = 0
        params["color"] = ""
        params["text"] = ""
        params["paid"] = false
   

        return params
    }
    
    private func sendScreenshotConfirmation(){
        
        
        guard let currentSlot = autographSlotInfo
            else{
                return
        }
        
        self.view.layoutIfNeeded()
        var params = [String : Any]()
        let size = self.hostRootView?.canvas?.frame.size ?? CGSize()
        params["width"] = size.width
        params["height"] = size.height
        params["screenshot"] =  generateAutographInfo()
        
        if let currentSlotId = autographSlotInfo?.id {
            params["forSlotId"] = "\(currentSlotId)"
        }

        var mainParams  = [String : Any]()
        mainParams["id"] = "startedSigning"
        mainParams["name"] = currentSlot.user?.hashedId
        mainParams["message"] = params
        socketClient?.emit(mainParams)
    }
    
    func stopSigning(){
        
        guard let currentSlot = autographSlotInfo
            else{
                return
        }
        
        var mainParams  = [String : Any]()
        mainParams["id"] = "stoppedSigning"
        mainParams["name"] = currentSlot.user?.hashedId
        socketClient?.emit(mainParams)
    }
    
    private func resetCanvas(){
        
        if(!isSignatureActive){
            return
        }
        
        self.releaseDeviceOrientation()
        self.stopSigning()
        self.hostRootView?.canvasContainer?.hide()
        self.signaturAccessoryView?.isHidden = true

        self.hostRootView?.remoteVideoContainerView?.isSignatureActive = false
        self.hostRootView?.remoteVideoContainerView?.updateForCall()
        
        self.hostRootView?.localVideoView?.isSignatureActive = false
        self.hostRootView?.localVideoView?.updateLayoutOnEndOfCall()
        self.isSignatureActive = false
        
    }

    private func resetAutographCanvasIfNewCallAndSlotExists(){
        
        //if current slot id is nil then return
        
        if self.myLiveUnMergedSlot?.id == nil {
            
            
            if self.isSignatureActive{
                Log.echo(key: "point", text: "Resetting the canvase")

                self.resetCanvas()
                self.isSignatureActive = false
            }
            return
        }
        
        if localSlotIdToManageAutograph == nil{
            
            Log.echo(key: "yud", text: "providing id to unmerged slot is nil")
            localSlotIdToManageAutograph = self.myLiveUnMergedSlot?.id
            return
        }
        
        if localSlotIdToManageAutograph != self.myLiveUnMergedSlot?.id {
          
            Log.echo(key: "yud", text: "Providing id is changed for new slot")
            localSlotIdToManageAutograph = self.myLiveUnMergedSlot?.id
            self.resetCanvas()
            //reset the signature
            return
        }
        
    }
    
    
    private func uploadImage(encodedImage:String, autographSlotInfo : SlotInfo?, completion : ((_ success : Bool, _ info : ScreenshotInfo?)->())?){
                
        var params = [String : Any]()
        params["userId"] = autographSlotInfo?.userId
        params["analystId"] = SignedUserInfo.sharedInstance?.id ?? 0
        params["callbookingId"] = autographSlotInfo?.id ?? 0
        params["callScheduleId"] = eventInfo?.id ?? 0
        params["defaultImage"] = false
        params["file"] = encodedImage
        params["isImplemented"] = true
        params["signed"] = true
    
        
//        Log.echo(key: "yudi", text: "Uploaded params are \(params)")
        
        //userRootView?.requestAutographButton?.showLoader()
        SubmitScreenshot().submitScreenshot(params: params) { (success, info) in
            //self?.userRootView?.requestAutographButton?.hideLoader()
            
            DispatchQueue.main.async {
                completion?(success, info)
            }
        }
    }
    
    
    private func uploadAutographImage(){
        

        guard let image = self.hostRootView?.canvas?.getSnapshot()
            else{
                return
        }
        encodeImageToBase64(image: image) {[weak self] (encodedImage) in
            self?.uploadImage(encodedImage: encodedImage, autographSlotInfo: self?.autographSlotInfo) { (success, info) in
                
            }
        }
    }
    
    
    
    
}

extension HostCallController:AutographSignatureBottomResponseInterface{
    
    func doneAction(sender:UIButton?){
        
        print("done is calling")
        
        self.uploadAutographImage()
        
        self.resetCanvas()
        
        self.showToastWithMessage(text: "Saving Autograph..", time: 5.0)
    }
    
    func undoAction(sender:UIButton?){
        self.hostRootView?.canvas?.undo()
    }

    func pickerSelectedColor(color: UIColor?) {
        
        self.hostRootView?.canvas?.updateColorFromPicker(color:color)
        self.signaturAccessoryView?.ColorViewClass?.mainColorView?.isHidden = true
    }
    
    @IBAction func testOrientation(){
        
        self.hostRootView?.canvasContainer?.show(with: UIImage(named:"testingImage"))
        self.hostRootView?.remoteVideoContainerView?.isSignatureActive = true
        self.signaturAccessoryView?.isHidden = false
        self.isSignatureActive = true
        
        self.hostRootView?.localVideoView?.isSignatureActive = true
        self.hostRootView?.localVideoView?.updateLayoutRotation()
        self.hostRootView?.remoteVideoContainerView?.updateForSignature()

    
    }    
    
    
    func lockDeviceOrientation(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if UIApplication.shared.statusBarOrientation.isLandscape{
            
            delegate?.isSignatureInCallisActive = true
            
            Log.echo(key: "HostCallController", text: "lockDeviceOrientation -> \(UIDevice.current.orientation)")
            
            if UIApplication.shared.statusBarOrientation == .landscapeLeft{
                Log.echo(key: "HostCallController", text: "lockDeviceOrientation -> left")
                delegate?.signatureDirection = .landscapeLeft
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                
            }else if UIApplication.shared.statusBarOrientation == .landscapeRight{
                
                Log.echo(key: "HostCallController", text: "lockDeviceOrientation -> right")
                
                delegate?.signatureDirection = .landscapeRight
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
        }else{
            
            delegate?.isSignatureInCallisActive = true
            delegate?.signatureDirection = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    

    
    func releaseDeviceOrientation(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.isSignatureInCallisActive = false
    }
}


