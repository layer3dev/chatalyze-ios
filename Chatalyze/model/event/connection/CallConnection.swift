//
//  CallConnection.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit
import TwilioVideo

//This is root class meant to be overriden by Host Connection and User Connection.
//abstract.

class CallConnection: NSObject {
    
    var isFetchingTokenToServer = false

    
    var isConnecting = false

    var isConnectionEstablished:Bool{
        if self.connection == nil{
            return false
        }else{
            return true
        }
    }
        
    var accessToken = ""
    var roomName = ""

    var roomParticipantsList = [HostRoomInfo]()
    var remoteView:VideoView?
    var renderer : VideoFrameRenderer?

    private var TAG = "CallConnection"

    static private var temp = 0
    var tempIdentifier = 0

    var connection : Room?

    var eventInfo : EventScheduleInfo?
    
    var _slotInfo:SlotInfo?
    var slotInfo : SlotInfo?{
        get{
            return self._slotInfo
        }
        set{
         
            let value = newValue
            _slotInfo = value
            initialization()
            self.TAG = "\(self.TAG) \(newValue?.slotNo)"
        }
    }
    var controller : VideoCallController?
    
    private var _localMediaPackage : CallMediaTrack?
    private var bufferTrack : LocalMediaTrackWrapper?
    
    var localMediaPackage : CallMediaTrack?{
        get{
            return _localMediaPackage
        }
        set{
            _localMediaPackage = newValue
            bufferTrack = newValue?.mediaTrack?.bufferTrack
            bufferTrack?.trackTag = "\(bufferTrack?.trackTag) \(slotInfo?.slotNo)"
            bufferTrack?.acquireLock()
        }
    }
    
    

    var connectionStateListener : CallConnectionProtocol?

    private var callLogger : CallLogger?
    
    //this variable will be used to speed up the re-connect. This will store last disconnect timestamp and will force to create a new connection after 2 seconds
    
    //For now, will be used at host's end, but could be used for user in future
    //no need to use synced time here
    var lastDisconnect : Date?
    
    
    /*
     TVIRoomStateConnecting = 0,
        /**
         *  The `TVIRoom` is connected, and ready to interact with other Participants.
         */
        TVIRoomStateConnected,
        /**
         *  The `TVIRoom` has been disconnected, and interaction with other Participants is no longer possible.
         */
        TVIRoomStateDisconnected,
        /**
         *  The `TVIRoom` is attempting to reconnect following a network disruption.
         */
        TVIRoomStateReconnecting,
     */
    
    //This will tell, if connection is in ACTIVE state. If false, then user is not connected to other user.
    //This is used for re-connect purposes as well
    var isConnected : Bool{
        get{
            guard let connection = self.connection
                else{
                    return false
            }
            if(connection.state == .connected){
                return true
            }
            
            return false
        }
    }
    
    
    
    //isStreaming is different from isConnected.
    //This is used for tracking, if selfie-screenshot process can be initiated or not. Not used for re-connect purposes.
    var isStreaming : Bool {
        
        guard let _ = self.eventInfo else{
            return false
        }

        guard let currentSlotHashId  = self.eventInfo?.mergeSlotInfo?.currentSlot?.user?.hashedId else{
            return false
        }
        
        let currentParticipant = self.roomParticipantsList.filter({$0.remoteParticipant?.identity == currentSlotHashId})
        
        if currentParticipant.count > 0 {
            
            if currentParticipant[0].isRendered{
                return true
            }
            return false
        }
        return false
    }
    
    //if connection had been released
    var isReleased : Bool = false
    
    //flag to see, if this connection is aborted and replaced by another connection
    var isAborted = false
    
    var isRendered = false
    
    /*flags*/
    var isLinked = false
    
    private var remoteTrack : CallMediaTrack?
    var socketClient : SocketClient?
    var socketListener : SocketListener?
    
    
    init(eventInfo : EventScheduleInfo?, slotInfo : SlotInfo?, localMediaPackage : CallMediaTrack?, controller : VideoCallController?,roomName:String,accessToken:String,localVideo:VideoView,remoteVideo:VideoView){
        super.init()
        
        CallConnection.temp = CallConnection.temp + 1
        tempIdentifier = CallConnection.temp
        
        self.eventInfo = eventInfo
        self.slotInfo = slotInfo
        self.localMediaPackage = localMediaPackage
        self.remoteView = remoteVideo
        self.roomName = roomName
        self.accessToken = accessToken
        self.controller = controller
        connectCall()
        
        print("connecting is calling")
    }
    
    //overridden
    var targetUserId : String?{
        
        get{
            return nil
        }
    }
    
    var connectionState : Room.State?{
        return connection?.state
    }
    
    //overridden
    var targetHashId : String?{
        
        get{
            return nil
        }
    }
    
    var roomId : String?{
        
        get{
            return self.eventInfo?.roomId
        }
    }
    
    var rootView : VideoRootView?{
        return controller?.rootView
    }
    
    var isCallConnected:(()->())?
    
    var eventId : String?{
        
        let sessionId = eventInfo?.id ?? 0
        return "\(sessionId)"
    }
    
    override init() {
        super.init()
        
        //initialization()
    }
    
    private func initialization(){
       
        initVariable()
        registerForListeners()
    }
    
    private func initVariable(){
        
        _ = eventInfo?.id ?? 0
        
        print("Initiization of the callLogger at the host side \(eventId) and the target user id is \(targetUserId)")
        
        guard let sd = eventId else{
            return
        }
        
        guard let userId = targetUserId else{
            return
        }
        socketClient = SocketClient.sharedInstance
        socketListener = socketClient?.createListener()
        callLogger = CallLogger(sessionId: sd, targetUserId: userId)
    }
    
    func registerForListeners(){
    }
    

    func callFailed(){
    }
    
    //prevent screen reset
    //make connection disappear without effecting remote renderer
    func abort(){
       
        isAborted = true
        //removeLastRenderer()
        disconnect()
    }
    
    //follow all protocols of disconnect
    func disconnect(){
        
        print("Host is disconnected")
        lastDisconnect = nil
        self.isReleased = true
        self.connection?.disconnect()
        self.bufferTrack?.releaseLock()
        self.bufferTrack = nil
        
        self.connection = nil
        self.remoteTrack = nil
        self.socketClient = nil
        self.socketListener?.releaseListener()
        self.socketListener = nil
        
        
        
        //self.removeWholeRenders()
        //resetRemoteFrame()
    }
    
    
   
}

extension CallConnection{

 // MARK:- IBActions
    func connectCall(){
        
        logMessage(messageText: "Connect method is call")
        
        // Configure access token either from server or manually.
        // If the default wasn't changed, try fetching from server.
                
        // Prepare local media which we will share with Room Participants.
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        
        
        if isConnecting{
            return
        }
        isConnecting = true
        
        let connectOptions = ConnectOptions(token: accessToken) { (builder) in
            
            builder.isDominantSpeakerEnabled = true
            builder.networkPrivacyPolicy = .allowAll
            // Use the local media that we prepared earlier.
            
            Log.echo(key: "NewArch", text: "audio track is nil and the is Hangup \(String(describing: self.localMediaPackage?.isDisabled))")

        
            
            guard let bufferTrack = self.bufferTrack
            else{
                return
            }
            
            guard let audioTrack = bufferTrack.audioTrack
            else{
                return
            }
            
            guard let videoTrack = bufferTrack.videoTrack
            else{
                return
            }
            
            builder.audioTracks = [audioTrack]
            builder.videoTracks = [videoTrack]
            
//            // Use the preferred audio codec
//            if let preferredAudioCodec = Settings.shared.audioCodec {
//                builder.preferredAudioCodecs = [preferredAudioCodec]
//            }
//
//            // Use the preferred video codec
//            if let preferredVideoCodec = Settings.shared.videoCodec {
//                builder.preferredVideoCodecs = [preferredVideoCodec]
//            }
            
//            // Use the preferred encoding parameters
//            if let encodingParameters = Settings.shared.getEncodingParameters() {
//                builder.encodingParameters = encodingParameters
//            }
            
//            // Use the preferred signaling region
//            if let signalingRegion = Settings.shared.signalingRegion {
//                builder.region = signalingRegion
//            }
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            
            
//            builder.isAutomaticSubscriptionEnabled = false
            builder.roomName = self.roomName
        }
        
        // Connect to the Room using the options we provided.
        self.connection = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        logResolution()
        
        logMessage(messageText: "Attempting to connect to room ABCD")
    }
    
  
     func logResolution(){
        Log.echo(key: TAG, text: "logResolution")
        guard let videoTrack = bufferTrack?.videoTrack
        else{
            return
        }
        
        let slotId = self.slotInfo?.id ?? 0
        
        Log.echo(key : TAG, text : "logVideoResolution slotId -> \(slotId)")
        
        guard let cameraSource = videoTrack.source as? LocalCameraSource
        else{
            return
        }
        
        Log.echo(key : TAG, text : "logVideoResolution cameraSource received")
        
        guard let frameResolution = cameraSource.frameResolution else { return }
        
        Log.echo(key : TAG, text : "logVideoResolution executed")
        Log.echo(key : "dhimu_FR", text : "Host Resolution : \(frameResolution)")
        
        if frameResolution.width > frameResolution.height{
            Log.echo(key: "atul", text: "width is greater")
            callLogger?.logVideoResolutionHost(size: CGSize(width: frameResolution.width / 2, height: frameResolution.height / 2))
        }else{
            callLogger?.logVideoResolutionHost(size: frameResolution)
        }
       
    }
    
    
    private func reconnect(){
        logMessage(messageText: "reconnect called")
        
        if(isReleased){
            return
        }
        
        self.connection?.delegate = nil
        self.connection?.disconnect()
        self.removeWholeRenders()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.processReconnect()
        }
    }
    
    private func processReconnect(){
        logMessage(messageText: "processReconnect")
        guard let connection = self.connection
            else{
                logMessage(messageText: "processReconnect no connection found")
                return
        }
        if(connection.state != .disconnected){
            logMessage(messageText: "processReconnect connection state is -> \(connection.state)")
            return
        }
        self.connection?.delegate = nil
        self.connection = nil
        
        logMessage(messageText: "processReconnect -> connectCall")
        connectCall()
    }
    
    
    private func clearExistingRenderer(){
        
    }
    
    
    func logMessage(messageText: String) {
        NSLog("CallConnection -> \(messageText)")
        //messageLabel.text = messageText
    }
    
    
    @IBAction func disconnect(sender: AnyObject) {
        
        self.connection!.disconnect()
        logMessage(messageText: "Attempting to disconnect from room \(connection!.name)")
    }
}


// MARK:- RoomDelegate
extension CallConnection : RoomDelegate {
    
    
    private func logStats(room:Room){
        
        DispatchQueue.global(qos: .background).async {[weak self] in
            let slotId = self?.slotInfo?.id ?? 0

            print("slot id during sending the logs at host side after room connection \(slotId) and the call logger is \(String(describing: self?.callLogger))")
            self?.connection?.getStats({[weak self] (infos) in
                
                
                print("Array of thr TWillio Info is \(infos)")
                
                self?.callLogger?.logStats(slotId: slotId, stats: infos)
                self?.callLogger?.logConnectionState(slotId : slotId, connectionState: room.state, stats : infos)
            })
        }
        
    }

    
    private func updateTrack(){
        Log.echo(key: self.TAG, text: "updateTrack")
        if(slotInfo?.isReadyToGoLive ?? false){
            Log.echo(key: self.TAG, text: "activate")
            self.bufferTrack?.activate()
            return
        }
        
        Log.echo(key: self.TAG, text: "deactivate")
        self.bufferTrack?.mute()
    }
    
    func roomDidStartRecording(room: Room) {
        Log.echo(key: TAG, text: "roomDidStartRecording")
    }
    
    func roomDidStopRecording(room: Room) {
        Log.echo(key: TAG, text: "roomDidStartRecording")
    }
    
    
    func roomDidConnect(room: Room) {
        
        Log.echo(key: TAG, text: "roomDidConnect -> \(room.isRecording)")
        
        
        self.updateTrack()
        
                        
        // At the moment, this example only supports rendering one Participant at a time.
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "") and computed hashId id \(String(describing: self.eventInfo?.user?.hashedId)) and teh computed self hashId is \(String(describing: self.eventInfo?.mergeSlotInfo?.currentSlot?.user?.hashedId)) amd there remoteparticipanats counts is \(room.remoteParticipants.count)")
        self.isConnecting = false
        self.remoteView?.shouldMirror = false
        logStats(room: room)
        self.trackJoinedCallRoomLogs()
        self.connection?.getStats({ (associatedTracks) in
            
        })
        if (room.remoteParticipants.count > 0) {
            
            for info in room.remoteParticipants {
                
                let roomInfo = HostRoomInfo()
                roomInfo.remoteParticipant = info
                info.delegate = self
                self.roomParticipantsList.append(roomInfo)
            }
        }
    }
    
    

    func roomDidDisconnect(room: Room, error: Error?) {
        
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        self.isConnecting = false
        reconnect()
        trackDisconnectSelf()


        // Connect(sender: nil)
    }

    func roomDidFailToConnect(room: Room, error: Error) {
        
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.isConnecting = false
        reconnect()
//        self.connection = nil
        //connect(sender: nil)
       // self.showRoomUI(inRoom: false)
    }

    func roomIsReconnecting(room: Room, error: Error) {
       logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }

    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }

    func participantDidConnect(room: Room, participant: RemoteParticipant) {

//        self.connection?.subs
        print("Connected particpanta are \(participant)")
        
        let isPartcipantExists = self.roomParticipantsList.filter({$0.remoteParticipant == participant})
        
        if isPartcipantExists.count > 0{
            Log.echo(key: "NewArch", text: "Participants already exits")
            return
        }
        
        participant.delegate = self
        let roomInfo = HostRoomInfo()
        roomInfo.remoteParticipant = participant
        self.roomParticipantsList.append(roomInfo)
        trackRemoteUserConnected()

        
        
       logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }

    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        
        let isPartcipantExists = self.roomParticipantsList.filter({$0.remoteParticipant == participant})
        
        if isPartcipantExists.count > 0{
            
            let updatedArray = self.roomParticipantsList.filter({$0.remoteParticipant != participant})
            
            self.roomParticipantsList = updatedArray
            trackRemoteUserDisconnected()

            Log.echo(key: "NewArch", text: "Participants already exits is disconnected")
            return
        }
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
    }
}

// MARK:- RemoteParticipantDelegate
extension CallConnection : RemoteParticipantDelegate {

    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        
        // Remote Participant has offered to share the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }

    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        
        // Remote Participant has stopped sharing the video Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }

    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        
        // Remote Participant has offered to share the audio Track.

        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        
        // Remote Participant has stopped sharing the audio Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }

    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
     
        // We are subscribed to the remote Participant's video Track. We will start receiving the
        // remote Participant's video frames now.
    

        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        let isPartcipantExists = self.roomParticipantsList.filter({$0.remoteParticipant == participant})
        if isPartcipantExists.count > 0{
           
            print("subscribing already existing participant")
            isPartcipantExists[0].remoteVideoTrack = videoTrack
            
            //isPartcipantExists[0].isRendered = true
            self.remoteView?.shouldMirror = false
            self.remoteView?.contentMode = .scaleAspectFit
            trackGetRemoteVideoStream()
            return
        }
        
        print("subscribing new participant")

        let info = HostRoomInfo()
        info.remoteVideoTrack = videoTrack
        info.remoteParticipant = participant
        self.roomParticipantsList.append(info)
    }
    
    
    func removeWholeRenders(){
        
        
        guard let renderer = self.renderer else{
            return
        }
        
        // Removing all the reneders tracks
        let isPartcipantExists = self.roomParticipantsList.filter({$0.isRendered == true})
        if isPartcipantExists.count > 0{
            
            isPartcipantExists[0].remoteVideoTrack?.removeRenderer(self.remoteView!)
            isPartcipantExists[0].remoteVideoTrack?.removeRenderer(renderer)
            
            isPartcipantExists[0].remoteAudioTrack?.isPlaybackEnabled = false
            self.roomParticipantsList.removeAll()
            return
        }
    }
    
    func removeConnectedRender(){
        
        let isPartcipantExists = self.roomParticipantsList.filter({$0.isRendered == true})
        if isPartcipantExists.count > 0{
            
            guard let renderer = self.renderer else{
                return
            }
            
            isPartcipantExists[0].remoteAudioTrack?.isPlaybackEnabled = false
            isPartcipantExists[0].remoteVideoTrack?.removeRenderer(self.remoteView!)
            isPartcipantExists[0].remoteVideoTrack?.removeRenderer(renderer)
            isPartcipantExists[0].isRendered = false
            return
        }

        //Removing whole remote Audio
//        for info in self.roomParticipantsList{
//            //info.remoteAudioTrack?.isPlaybackEnabled = false
//        }

    }
    
    
    private func activateStream(){
        let isReadyToGoLive = slotInfo?.isReadyToGoLive ?? false
        if(!isReadyToGoLive){
            return
        }
        
        if(bufferTrack?.isActivated ?? false){
            return
        }
        
        Log.echo(key: TAG, text: "activateStream")
        
        bufferTrack?.activate()
    }
        
    func switchStream(info : EventScheduleInfo?){
        
        
        activateStream()

        guard let data = info else{
            print("removing the whole setream")
            self.removeWholeRenders()
            return
        }

        self.eventInfo = data
        guard let currentSlotHashId  = self.eventInfo?.mergeSlotInfo?.currentSlot?.user?.hashedId else{
            print("removing the current stream")
            self.removeConnectedRender()
            return
        }
        

        print("Get the merge slot Info")
        let currentParticipant = self.roomParticipantsList.filter({$0.remoteParticipant?.identity == currentSlotHashId})

        if currentParticipant.count > 0{

            print("remote participant hash Id is \(String(describing: currentParticipant.first?.remoteParticipant?.identity)) and the current user identity is \(currentSlotHashId)")
            
            print("Got the existing particpant having the count \(currentParticipant.count) with the rendered info is \(currentParticipant[0].isRendered)")

            if !currentParticipant[0].isRendered{
                
                if let track = currentParticipant[0].remoteVideoTrack {
                    
                    guard let renderer = self.renderer else{
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.removeInvalidRenderer(info : info)

                        if !(self.eventInfo?.mergeSlotInfo?.currentSlot?.isHangedUp ?? false){

                            track.addRenderer(self.remoteView!)
                            track.addRenderer(renderer)
                            
                            Log.echo(key: self.TAG, text: "addRenderer")
                                                        
                            currentParticipant[0].remoteAudioTrack?.isPlaybackEnabled = true
                            currentParticipant[0].isRendered = true
                            self.trackRemoteScreenDisplayed()
                        }
                    }
                    print("Making render true and remote view is \(String(describing: self.remoteView)) and the remote render is \(track)")
                }
            }
        }else{

            //TODO:- create a global function that will check for each existing connected remote participants and will remove all the connection that are expired.
            print("Removin last connected render")
            self.removePreviousRenderer()
        }
    }
    
    func removePreviousRenderer(){
        
        let connectedParticipant = self.roomParticipantsList.filter({$0.isRendered == true})
        
        guard let renderer = self.renderer else{
            return
        }
    
        for info in connectedParticipant{
            if let track = info.remoteVideoTrack{
                
                info.remoteAudioTrack?.isPlaybackEnabled = false
                track.removeRenderer(self.remoteView!)
                track.removeRenderer(renderer)
            }
        }
    }
    
    
    private func removeInvalidRenderer(info : EventScheduleInfo?){
        guard let info = info
            else{
                return
        }
        let currentSlotUserHash = info.mergeSlotInfo?.currentSlot?.user?.hashedId
        let preConnectSlotUserHash = info.mergeSlotInfo?.preConnectSlot?.user?.hashedId
        
        guard let renderer = self.renderer else{
            return
        }
        
        for info in self.roomParticipantsList{
            if(info.remoteParticipant?.identity == currentSlotUserHash){
                continue
            }
//            if(info.remoteParticipant?.identity == preConnectSlotUserHash){
//                continue
//            }
            
            info.remoteAudioTrack?.isPlaybackEnabled = false
            if let remoteView = self.remoteView{
                info.remoteVideoTrack?.removeRenderer(remoteView)
                info.remoteVideoTrack?.removeRenderer(renderer)
            }
        }
    }
    
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        
        // remote Participant's video.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        
        guard let renderer = self.renderer else{
            return
        }
        
        let isPartcipantExists = self.roomParticipantsList.filter({$0.remoteParticipant == participant})
        if isPartcipantExists.count > 0{

            print("Adding the video track at the participant having the identity of \(isPartcipantExists)")
            isPartcipantExists[0].remoteVideoTrack?.removeRenderer(self.remoteView!)
            isPartcipantExists[0].remoteVideoTrack?.removeRenderer(renderer)
            self.roomParticipantsList = self.roomParticipantsList.filter({$0.remoteParticipant != participant})
            trackLostRemoteVideoStream()
            return
        }
    }

    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
              
       
        audioTrack.isPlaybackEnabled = false
        
        let isPartcipantExists = self.roomParticipantsList.filter({$0.remoteParticipant?.identity == participant.identity})
        
    
        Log.echo(key: "NewArch", text: "didSubscribeToAudioTrack and the isParticipants \(isPartcipantExists.count)")
        
        if isPartcipantExists.count > 0{
            
            isPartcipantExists[0].remoteAudioTrack = audioTrack
            isPartcipantExists[0].remoteAudioTrack?.isPlaybackEnabled = false
            trackGetRemoteAudioStream()
        }

        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
       
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        
        audioTrack.isPlaybackEnabled = false
        
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        
        // remote Participant's audio.
        trackLostRemoteAudioStream()

        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }

    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }

    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }

    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }

    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }

    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {

        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}



extension CallConnection{
    
    func trackJoinedCallRoomLogs(){
        
        guard let userId = SignedUserInfo.sharedInstance?.id else {
            print("User id is missing in joinedroom")
            return
        }
        guard let chatId =  self.slotInfo?.id else {
            print("User id is missing in joinedroom")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId] as [String : Any]
        print("Meta info in joinedroom is \(metaInfo)")
        let action = "joinedroom"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    //trackAction(session.id, user.id, );
    
    func trackDisconnectSelf(){
        
        let action = "disconnected"
        self.callLogger?.trackLogs(action: action, metaInfo: [String:Any]())
    }
    
    func trackRemoteScreenDisplayed(){
        
        //    3) LogTrackService.trackAction(session.id, user.id, 'remoteStreamDisplayed', { chatId: currentChat.id, userId: currentChat.userId });
        
        guard let userId =  SignedUserInfo.sharedInstance?.id else {
            print("User id is missing in joinedroom")
            return
        }
        guard let chatId =  self.slotInfo?.id else {
            print("User id is missing in joinedroom")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId] as [String : Any]
        print("Meta info in joinedroom is \(metaInfo)")
        let action = "remoteStreamDisplayed"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    //    4) LogTrackService.trackAction(session.id, user.id, 'chatCompleted', { userId: currentChat.userId, chatId: currentChat.id});
    
    
    //    6) LogTrackService.trackAction(session.id, user.id, 'gotRemoteTrack', { trackType: track.kind, userId: cb.userId, chatId: cb.id});
    
    
    func trackGetRemoteVideoStream(){
        
        guard let userId =  self.slotInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotInfo?.id else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId,"trackType":"video"] as [String : Any]
        print("Meta info in trackGetRemoteVideoStream is \(metaInfo)")
        let action = "gotRemoteTrack"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    func trackGetRemoteAudioStream(){
        
        guard let userId =  self.slotInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotInfo?.id else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId,"trackType":"audio"] as [String : Any]
        print("Meta info in trackGetRemoteVideoStream is \(metaInfo)")
        let action = "gotRemoteTrack"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    func trackLostRemoteVideoStream(){
        
        guard let userId =  self.slotInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotInfo?.id else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId,"trackType":"video"] as [String : Any]
        print("Meta info in trackGetRemoteVideoStream is \(metaInfo)")
        let action = "gotRemoteTrack"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    func trackLostRemoteAudioStream(){
        
        guard let userId =  self.slotInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotInfo?.id else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId,"trackType":"audio"] as [String : Any]
        print("Meta info in trackGetRemoteVideoStream is \(metaInfo)")
        let action = "lostRemoteTrack"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    //    7 )LogTrackService.trackAction(session.id, user.id, 'userConnected', {userId: cb.userId, chatId: cb.id});
    
    
    func trackRemoteUserConnected(){
        
        guard let userId =  self.slotInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotInfo?.id else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId] as [String : Any]
        print("Meta info in trackGetRemoteVideoStream is \(metaInfo)")
        let action = "userConnected"
        //    7 )LogTrackService.trackAction(session.id, user.id, 'userConnected', {userId: cb.userId, chatId: cb.id});
        
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
        
    }
    
    //    9) LogTrackService.trackAction(session.id, user.id, 'userDisconnected', {userId:cb.userId, chatId: cb.id});
    
    func trackRemoteUserDisconnected(){
        
        guard let userId =  self.slotInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotInfo?.id else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId] as [String : Any]
        print("Meta info in trackGetRemoteVideoStream is \(metaInfo)")
        let action = "userDisconnected"
        //    7 )LogTrackService.trackAction(session.id, user.id, 'userConnected', {userId: cb.userId, chatId: cb.id});
        
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
        
    }
}





