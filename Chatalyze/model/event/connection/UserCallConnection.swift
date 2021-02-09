
//
//  UserCallConnection.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import TwilioVideo

class UserCallConnection: NSObject {

    private var _slotId:Int?
    private let TAG = "UserCallConnection"
    
    //temp
    private static var counter = 0
    
    var isConnecting = false
    
    var slotId:Int?{
        get{
            return _slotId
        }
        set{
            
            let value = newValue
            _slotId = value
            initialization()
        }
    }
    
    var isConnectionEstablished:Bool{
        if self.connection == nil{
            return false
        }else{
            return true
        }
    }
    
    
    var isRoomConnected = false
    var isRendered = false
    
    var remoteVideoTrack:RemoteVideoTrack?
    var remoteAudioTrack:RemoteAudioTrack?
    
    var accessToken = ""
    var roomName = ""
            
    var remoteParticipant: RemoteParticipant?
    var remoteView:VideoView?
    var renderer : VideoFrameRenderer?
    
    static private var temp = 0
    var tempIdentifier = 0
    
    var connection : Room?
    
    var eventInfo : EventScheduleInfo?
    var controller : VideoCallController?
    var localMediaPackage : CallMediaTrack?
    
    var connectionStateListener : CallConnectionProtocol?
    
    private var callLogger : CallLogger?
    
    //this variable will be used to speed up the re-connect. This will store last disconnect timestamp and will force to create a new connection after 2 seconds
    //For now, will be used at host's end, but could be used for user in future
    //no need to use synced time here
    
    var lastDisconnect : Date?
    
    //This will tell, if connection is in ACTIVE state. If false, then user is not connected to other user.
    //This is used for re-connect purposes as well
    var isConnected : Bool{
        get{
            return (connection?.state != .disconnected)
        }
    }
    
    //isStreaming is different from isConnected.
    //This is used for tracking, if selfie-screenshot process can be initiated or not. Not used for re-connect purposes.
    var isStreaming : Bool {
        return self.isRendered
    }
    
    //if connection had been released
    var isReleased : Bool = false
    
    //flag to see, if this connection is aborted and replaced by another connection
    var isAborted = false
    
    /*flags*/
    var isLinked = false
    
    private var remoteTrack : CallMediaTrack?
    var socketClient : SocketClient?
    var socketListener : SocketListener?

            
    //overridden
    var targetUserId : String?{
        
        get{
            guard let userId = self.eventInfo?.user?.id
                else{
                    return nil
            }
            return userId
        }
    }
    
    
    var slotInfo:SlotInfo?

    
    override init() {
        super.init()
        
        UserCallConnection.counter = UserCallConnection.counter + 1
        
        Log.echo(key: TAG, text: "init -> counter -> \(UserCallConnection.counter)")
        
    }
    
    
    init(eventInfo : EventScheduleInfo?, localMediaPackage : CallMediaTrack?, controller : VideoCallController?,roomName:String,accessToken:String,remoteVideo:RemoteVideoView){

        super.init()
        
        self.eventInfo = eventInfo
        self.localMediaPackage = localMediaPackage
        self.remoteView = remoteVideo.streamingVideoView
        self.renderer = remoteVideo.getRenderer()
        self.roomName = roomName
        self.accessToken = accessToken
        self.controller = controller
        self.connectToRoom()
        
       
        print("connecting is calling")
    }
    
    var connectionState : Room.State?{
        return connection?.state
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
        print("Current slot id is \(sessionId)")
        return "\(sessionId)"
    }
    
  
    
     func initialization(){
    
        initVariable()
        registerForListeners()
    }
    
    private func initVariable(){
        
        _ = eventInfo?.id ?? 0
        print("Call logger initialization and the event Id is \(eventId) and the target user id is \(targetUserId)")
        
        guard let sessionId = eventId else{
            return
        }
        
        guard let targetUSerId = targetUserId else{
            return
        }
        callLogger = CallLogger(sessionId: sessionId, targetUserId: targetUSerId)
        socketClient = SocketClient.sharedInstance
        socketListener = socketClient?.createListener()
    }
    
    func registerForListeners(){
    }
    
  
    
    func callFailed(){
    }
    
    //prevent screen reset
    //make connection disappear without effecting remote renderer
    func abort(){
        
        isAborted = true
        disconnect()
    }
    
    
    private func reconnect(){
        if isRoomConnected {
            Log.echo(key: self.TAG, text: "@213\(isRoomConnected)")
            return
        }
        logMessage(messageText: "reconnect called")
        if(isReleased){
            return
        }
        
        self.connection?.delegate = nil
        self.connection?.disconnect()
        self.removeRender()
        
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
        self.remoteParticipant = nil
        logMessage(messageText: "processReconnect -> connectCall")
        connectToRoom()
    }
    
    //follow all protocols of disconnect
    func disconnect(){
        
        logMessage(messageText: "user is disconnected")
        lastDisconnect = nil
        self.isReleased = true
        self.connection?.disconnect()
        self.remoteTrack = nil
        self.socketClient = nil
        self.socketListener?.releaseListener()
        self.socketListener = nil
    }
    
    var targetHashId : String?{
        get{
            guard let senderHash = self.eventInfo?.user?.hashedId
                else{
                    return nil
            }
            return senderHash
        }
    }
}

extension UserCallConnection{
        
    //MARK:- Main Connection
    func connectToRoom()  {
        
        
        if isRoomConnected{
            Log.echo(key: self.TAG, text: "@306\(isRoomConnected)")
            return
        }
        logMessage(messageText: "Connect method is call")
        
        // Configure access token either from server or manually.
        // If the default wasn't changed, try fetching from server.

        // Prepare local media which we will share with Room Participants.
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        
        guard let bufferTrack = self.localMediaPackage?.mediaTrack?.previewTrack
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
        
       
        isRoomConnected = true
        
        
        let connectOptions = ConnectOptions(token: accessToken) { (builder) in
            
            
            // Use the local media that we prepared earlier.
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
//
//            // Use the preferred encoding parameters
//            if let encodingParameters = Settings.shared.getEncodingParameters() {
//                builder.encodingParameters = encodingParameters
//            }
//
//            // Use the preferred signaling region
//            if let signalingRegion = Settings.shared.signalingRegion {
//                builder.region = signalingRegion
//            }
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = self.roomName
        }

        // Connect to the Room using the options we provided.
        self.connection = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
//        logResolution()

        logMessage(messageText: "Attempting to connect to room \(roomName)")
    }
    
    
    
     func logResolution(){
        Log.echo(key: TAG, text: "logResolution")
        guard let videoTrack = self.localMediaPackage?.mediaTrack?.previewTrack.videoTrack
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
        Log.echo(key : "dhimu_FR", text : "User Resolution : \(frameResolution)")
        
        if frameResolution.width > frameResolution.height{
            Log.echo(key: "atul", text: "width is greater")
            callLogger?.logVideoResolution(slotId : slotId, size : CGSize(width: frameResolution.width / 2, height: frameResolution.height / 2))
        }else{
            callLogger?.logVideoResolution(slotId : slotId, size : frameResolution)
        }
    }

    
    func logMessage(messageText: String) {
        NSLog("UserCallConnection -> \(messageText)")
        //messageLabel.text = messageText
    }
        
    @IBAction func disconnect(sender: AnyObject) {
        
        self.connection!.disconnect()
        logMessage(messageText: "Attempting to disconnect from room \(connection!.name)")
    }
    
    private func logStats(room:Room){
        
        DispatchQueue.global(qos: .background).async {[weak self] in
            
            let slotId = self?.slotId ?? 0
            self?.connection?.getStats({[weak self] (infos) in
                
                print("Array of thr TWillio Info is \(infos)")
                self?.callLogger?.logStats(slotId: slotId, stats: infos)
                self?.callLogger?.logConnectionState(slotId : slotId, connectionState: room.state, stats : infos)
            })
            
            
            //trackAction(session.id, user.id, '', { userId: userId, chatId: cbId});
            self?.callLogger?.trackLogs(action: "joinedroom", metaInfo: ["userId":"","chatId":self?.slotId])
        }
        
    }

}


// MARK:- RoomDelegate
extension UserCallConnection : RoomDelegate {
    
    func roomDidConnect(room: Room) {
        
        
        for participants in room.remoteParticipants{
            for audioTracks in participants.remoteAudioTracks{
                audioTracks.remoteTrack?.isPlaybackEnabled = false
            }
//            info.remoteTrack?.isPlaybackEnabled = false
        }
        
        for  info in room.remoteParticipants{
            info.delegate = self
        }
                
        // At the moment, this example only supports rendering one Participant at a time.
        
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "") and computed hashId id \(String(describing: self.eventInfo?.user?.hashedId)) and teh computed self hashId is \(String(describing: self.eventInfo?.mergeSlotInfo?.currentSlot?.user?.hashedId)) amd there remoteparticipanats counts is \(room.remoteParticipants.count)")
        
        guard let hashId = self.eventInfo?.user?.hashedId else { return }
        
        if isConnecting{
            return
        }
        isConnecting = true
        isRoomConnected = true
        
        logStats(room: room)
        self.trackJoinedCallRoomLogs()
        
        if (room.remoteParticipants.count > 0) {
        
            let participant = room.remoteParticipants.filter({$0.identity == hashId})
            
            print("filtered remote count ois\(participant.count)")
            
            if participant.count > 0{
                logMessage(messageText: "host identified in the room in room name \(room.name) as \(room.localParticipant?.identity ?? "") and count of the participant is \(participant)")
                logMessage(messageText: "Room delegate called")
                            
                self.remoteParticipant = participant[0]
                participant[0].delegate = self
            }else{
                
//                self.remoteParticipant = roo
//                self.remoteParticipant?.delegate = self
                
            }
        }
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        trackDisconnectSelf()
        isConnecting = false
        reconnect()
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
       
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        isConnecting = false
        reconnect()
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        
        Log.echo(key: TAG, text: "participantDidConnect")
        
        logMessage(messageText: "Participant participantDidConnect \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
                
        for info in participant.remoteAudioTracks{
            info.remoteTrack?.isPlaybackEnabled = false
        }
        
        participant.delegate = self
        
        guard let hashId = self.eventInfo?.user?.hashedId else { return }
        if participant.identity == hashId{
           
            self.remoteParticipant = participant
            self.remoteParticipant?.delegate = self
            trackRemoteUserConnected()
        }
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        
        
        Log.echo(key: TAG, text: "participantDidDisconnect")
        
        print("remote removed particpant identity is \(String(describing: self.remoteView))")
        
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
        
        guard let hashId = self.eventInfo?.user?.hashedId else { return }
        
        if participant.identity != hashId {
            return
        }
        
        if participant.identity == hashId{
            self.remoteParticipant = nil
            trackRemoteUserDisconnected()
        }
        
        guard let remoteView = self.remoteView else {
            return
        }
        
        guard let renderer = self.renderer else{
            return
        }
        
        if self.remoteVideoTrack != nil{
            self.remoteVideoTrack?.removeRenderer(remoteView)
            self.remoteVideoTrack?.removeRenderer(renderer)
            self.remoteAudioTrack?.isPlaybackEnabled = false
        }

        self.isRendered = false
        self.remoteVideoTrack = nil
        self.remoteAudioTrack = nil
        //TODO:- Need to remove the remote video renedering too.
    
    }
}

// MARK:- RemoteParticipantDelegate
extension UserCallConnection : RemoteParticipantDelegate {
    
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        Log.echo(key: TAG, text: "remoteParticipantDidPublishVideoTrack")
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        Log.echo(key: TAG, text: "remoteParticipantDidUnpublishVideoTrack")
        
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
        
        Log.echo(key: TAG, text: "didSubscribeToVideoTrack -> isSwitchedOff \(videoTrack.isSwitchedOff), isEnabled -> \(videoTrack.isEnabled)")
      
        // We are subscribed to the remote Participant's video Track. We will start receiving the
        
        // remote Participant's video frames now.
        
        //MARK:- Handling the video track
        
        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        
        guard let hashId = self.eventInfo?.user?.hashedId else{
            return
        }
        

        if participant.identity == hashId{
            
            self.remoteView?.shouldMirror = true
            self.remoteView?.contentMode = .scaleAspectFit
            self.remoteVideoTrack = videoTrack
            isRendered = false
            trackGetRemoteVideoStream()
            Log.echo(key: "yud", text: "Participant identity is confirmed as host")
        }
    }
    
    //todo_gunjot : WRONG
    //CallConnection shouldn't be aware of slot info
    func handleCallConnectionAndStreaming(info:SlotInfo?){
                        
        //This method id responsible for adding the steaming and removing the stream.
        
        print("Handling the call")
        
        guard let _ = info else{
            self.removeRender()
            print("current slot is empty.")
            return
        }
            
        if isRendered{
            print("Already rendered")
            return
        }
        
       
        guard let remotetrack = self.remoteVideoTrack else{
            print("remote track is empty")
            return
        }
        guard let view = self.remoteView else{
            print("remote view is nil")
            return
        }
        
        
        guard let renderer = self.renderer
            else{
                return
                
        }
        
        isRendered = true
        print("Rendered successfully!")
        remotetrack.addRenderer(view)
        remotetrack.addRenderer(renderer)
        trackRemoteScreenDisplayed()
        self.remoteAudioTrack?.isPlaybackEnabled = true
    }
    
    func removeRender(){
        Log.echo(key: TAG, text: "removeRenderer method")
        print("Successfull exiting remote track \(String(describing: self.remoteVideoTrack)) and the remote view is \(String(describing: self.remoteView) )")
        
        if !self.isRendered{
            return
        }
        
        guard let renderer = self.renderer else{
            return
        }
        
        if self.remoteVideoTrack != nil{
            if self.remoteView != nil {
                
                print("successfull unrendered")
                self.remoteAudioTrack?.isPlaybackEnabled = false
                self.remoteVideoTrack?.removeRenderer(self.remoteView!)
                self.remoteVideoTrack?.removeRenderer(renderer)
            }
        }
        self.remoteVideoTrack = nil
        self.remoteAudioTrack = nil
        self.isRendered = false
    }
    
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        
        Log.echo(key: TAG, text: "didUnsubscribeFromVideoTrack")
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        
        guard let hashId = self.eventInfo?.user?.hashedId else{
            return
        }
        
        guard let view = self.remoteView else {
            print("remote view outlet is nil")
            return
        }
        
        guard let renderer = self.renderer else{
            return
        }
        
        if participant.identity == hashId{
            
            videoTrack.removeRenderer(view)
            videoTrack.removeRenderer(renderer)
            self.remoteVideoTrack = nil
            self.isRendered = false
            trackLostRemoteVideoStream()
            Log.echo(key: "yud", text: "Participant identity is confirmed as host for didUnsubscribeFromVideoTrack")
        }
                
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
    
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)and the host hash id is \(self.eventInfo?.user?.hashedId)")
        
        audioTrack.isPlaybackEnabled = false
        publication.remoteTrack?.isPlaybackEnabled = false
        
        guard let hashId = self.eventInfo?.user?.hashedId else{
            return
        }
        
        if participant.identity == hashId{
            
            self.remoteAudioTrack = audioTrack
            self.remoteAudioTrack?.isPlaybackEnabled = false
            Log.echo(key: "yud", text: "Participant identity is confirmed as host for didSubscribeFromAudio track")
            trackGetRemoteAudioStream()
        }
        
        
        // self.remoteAudioTrack = audioTrack
        
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        
        // remote Participant's audio now.
        
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        
        audioTrack.isPlaybackEnabled = false
        
        guard let hashId = self.eventInfo?.user?.hashedId else{
            return
        }
        
        if participant.identity == hashId{
            
            self.remoteAudioTrack?.isPlaybackEnabled = false
            self.remoteAudioTrack = nil
            trackLostRemoteAudioStream()
            Log.echo(key: "yud", text: "Participant identity is confirmed as host for didUnsubscribeFromAudioTrack track")
        }
        
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


extension UserCallConnection{
    
    func trackJoinedCallRoomLogs(){
        
        guard let userId =  self.slotInfo?.userId else {
            print("User id is missing in joinedroom")
            return
        }
        guard let chatId =  self.slotId else {
            print("User id is missing in joinedroom")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId]
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
        
        guard let userId =  self.slotInfo?.userId else {
            print("User id is missing in joinedroom")
            return
        }
        guard let chatId =  self.slotId else {
            print("User id is missing in joinedroom")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId]
        print("Meta info in joinedroom is \(metaInfo)")
        let action = "remoteStreamDisplayed"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    //    4) LogTrackService.trackAction(session.id, user.id, 'chatCompleted', { userId: currentChat.userId, chatId: currentChat.id});
    
    
    //    6) LogTrackService.trackAction(session.id, user.id, 'gotRemoteTrack', { trackType: track.kind, userId: cb.userId, chatId: cb.id});
    
    
    func trackGetRemoteVideoStream(){
        
        guard let userId =  self.eventInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId,"trackType":"video"] as [String : Any]
        print("Meta info in trackGetRemoteVideoStream is \(metaInfo)")
        let action = "gotRemoteTrack"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    func trackGetRemoteAudioStream(){
        
        guard let userId =  self.eventInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId,"trackType":"audio"] as [String : Any]
        print("Meta info in trackGetRemoteVideoStream is \(metaInfo)")
        let action = "gotRemoteTrack"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    func trackLostRemoteVideoStream(){
        
        guard let userId =  self.eventInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        let metaInfo = ["userId":userId,"chatId":chatId,"trackType":"video"] as [String : Any]
        print("Meta info in trackGetRemoteVideoStream is \(metaInfo)")
        let action = "gotRemoteTrack"
        self.callLogger?.trackLogs(action: action, metaInfo: metaInfo)
    }
    
    func trackLostRemoteAudioStream(){
        
        guard let userId =  self.eventInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotId else {
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
        
        guard let userId =  self.eventInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotId else {
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
        
        guard let userId =  self.eventInfo?.userId else {
            print("User id is missing in trackGetRemoteVideoStream")
            return
        }
        guard let chatId =  self.slotId else {
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







