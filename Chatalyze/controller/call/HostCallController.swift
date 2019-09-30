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
    
    
    func showToastWithMessage(text:String,time:Double){
        
        let options = [kCRToastNotificationTypeKey : CRToastType.navigationBar,kCRToastUnderStatusBarKey:false,kCRToastTextKey : text,kCRToastNotificationPreferredHeightKey:4.0,kCRToastTextAlignmentKey:NSTextAlignment.center,kCRToastBackgroundColorKey:UIColor(hexString: "#FAA579"),kCRToastAnimationInTypeKey:kCRToastAnimationGravityMagnitudeKey,kCRToastAnimationOutTypeKey:kCRToastAnimationGravityMagnitudeKey,kCRToastAnimationInDirectionKey:CRToastAnimationDirection.left,kCRToastAnimationOutDirectionKey:CRToastAnimationDirection.right,kCRToastTimeIntervalKey:time] as [String : Any]
        
        CRToastManager.showNotification(options: options) {
        }
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
        
        socketListener?.onEvent("screenshotLoaded", completion: { (response) in
            
            Log.echo(key: "yud", text: "I got screenshot loaded in hostCall controller")

         })
        
        
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
        DispatchQueue.main.async {
            self.updateCallHeaderInfo()
        }
        refresh()
        DispatchQueue.main.async {
            self.updateLableAnimation()
        }
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
                self.fetchAutographInfo(screenShotId:info.metaInfo?.activityId)
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
            
            self.hostRootView?.canvas?.autoGraphInfo = self.autoGraphInfo
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
                self.hostRootView?.localVideoView?.updateForPortrait()
                self.sendScreenshotConfirmation(info)
                
            })
        }
    }
    
    private func sendScreenshotConfirmation(_ info : AutographInfo){
        
        self.view.layoutIfNeeded()
        var params = [String : Any]()
        let size = self.hostRootView?.canvas?.frame.size ?? CGSize()
        params["width"] = size.width
        params["height"] = size.height
        params["screenshot"] = info.dictValue()
        
        var mainParams  = [String : Any]()
        mainParams["id"] = "startedSigning"
        mainParams["name"] = info.userHashedId
        mainParams["message"] = params
        socketClient?.emit(mainParams)
    }
    
    func stopSigning(){
        
        var mainParams  = [String : Any]()
        mainParams["id"] = "stoppedSigning"
        mainParams["name"] = self.autoGraphInfo?.userHashedId
        socketClient?.emit(mainParams)
    }
    
    private func resetCanvas(){
        
        self.releaseDeviceOrientation()
        self.stopSigning()
        self.hostRootView?.canvasContainer?.hide()
        self.signaturAccessoryView?.isHidden = true

        self.hostRootView?.remoteVideoContainerView?.isSignatureActive = false
        self.hostRootView?.remoteVideoContainerView?.updateForCall()
        
        self.hostRootView?.localVideoView?.isSignatureActive = false
        self.hostRootView?.localVideoView?.updateLayoutOnEndOfCall()
        
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
    
    private func uploadAutographImage(){
        

        guard let image = self.hostRootView?.canvas?.getSnapshot()
            else{
                return
        }
        
        // id,int userId,int analystId,boolean signed
        
        var params = [String : String]()
        params["id"] = self.autoGraphInfo?.id ?? ""
        params["userId"] = self.autoGraphInfo?.userId ?? ""
        params["analystId"] = self.autoGraphInfo?.analystId ?? ""
        params["signed"] = "true"
        
        Log.echo(key: "yud", text: "Params are \(params) and image is nil = \(image == nil  ? true : false ) and the access token is \(String(describing: SignedUserInfo.sharedInstance?.accessToken))")
        
        let url = AppConnectionConfig.webServiceURL + "/screenshots"
        
        uploadImage(urlString: url, image: image, includeToken: false,params: params, progress: { (data) in
            
        }) { (success) in
            
            if success{
               
                self.showToastWithMessage(text:"Autograph saved successfully!",time:2.0)

                Log.echo(key: "yud", text: "image is uploaded done")
                return
            }
            Log.echo(key: "yud", text: "image uploading is unsuccessfull")
        }
    }
    
    
    func uploadImage(urlString : String, image : UIImage, includeToken : Bool,  params : [String : String] = [String : String](), progress : @escaping (Double)->(), completion : @escaping (Bool)->()){
        
        Log.echo(key: "", text:"UploadImage --> urlString --> \(urlString)")
        
        guard let imageData = image.pngData()
            else{
                completion(false)
                return
        }
        
        Alamofire.upload(multipartFormData : { multipartFormData in
            multipartFormData.append(imageData, withName: "file",
                                     fileName: "blob", mimeType: "image/png")
            for (key, value) in params {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
        },
                         usingThreshold : 0, to : urlString,
                         method : .put,
                         headers :  ["Authorization" : ("Bearer " + (SignedUserInfo.sharedInstance?.accessToken ?? ""))],
                         encodingCompletion : { encodingResult in
                            
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                upload.uploadProgress(closure: { (progressInfo) in
                                    DispatchQueue.main.async {
                                        let percent =  progressInfo.fractionCompleted
                                        progress(Double(percent))
                                    }
                                })
                                
                                upload.validate()
                                upload.responseJSON { response in
                                    Log.echo(key: "", text:"jsonResponse  => \(response)")
                                    completion(true)
                                }
                            case .failure(let encodingError):
                                Log.echo(key: "", text:encodingError)
                                completion(false)
                            }
        })
    }
}

extension HostCallController:AutographSignatureBottomResponseInterface{
    
    func doneAction(sender:UIButton?){
        
        self.uploadAutographImage()
        
        self.hostRootView?.canvasContainer?.hide()
        self.stopSigning()
        
        self.hostRootView?.remoteVideoContainerView?.isSignatureActive = false
        self.hostRootView?.remoteVideoContainerView?.updateForCall()
        self.signaturAccessoryView?.isHidden = true
        
        self.hostRootView?.localVideoView?.isSignatureActive = false
        self.hostRootView?.localVideoView?.updateLayoutOnEndOfCall()
        
        self.isSignatureActive = false
        
        self.releaseDeviceOrientation()
        self.showToastWithMessage(text: "Autograph saving....", time: 5.0)
        
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
        self.hostRootView?.remoteVideoContainerView?.updateForSignature()
        self.signaturAccessoryView?.isHidden = false
        self.isSignatureActive = true
        
        self.hostRootView?.localVideoView?.isSignatureActive = true
        self.hostRootView?.localVideoView?.updateForPortrait()
    
    }    
    
    func lockDeviceOrientation(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if UIApplication.shared.statusBarOrientation.isLandscape{
            
            delegate?.isSignatureInCallisActive = true
            
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
                
                delegate?.signatureDirection = .landscapeLeft
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                
            }else{
                
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


