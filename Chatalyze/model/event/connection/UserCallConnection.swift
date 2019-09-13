
//
//  UserCallConnection.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class UserCallConnection: CallConnection {
    
    func initiateCall(){
        self.connection?.initiateCall()
    }

    override var targetHashId : String?{
        get{
            guard let senderHash = self.eventInfo?.user?.hashedId
                else{
                    return nil
            }
            return senderHash
        }
    }
    
    //overridden
    override var targetUserId : String?{
        
        get{
            guard let userId = self.eventInfo?.user?.id
                else{
                    return nil
            }
            return userId
        }
    }
    
    override func getWriteConnection() ->ARDAppClient?{
        _ = super.getWriteConnection()
        
        guard let slotInfo = slotInfo
            else{
                return nil
        }
        
        guard let targetId = eventInfo?.user?.hashedId
            else{
                return nil
        }
        
        guard let userId = SignedUserInfo.sharedInstance?.hashedId
            else{
                return nil
        }
        
        guard let roomId = self.roomId
            else{
                return nil
        }
       
        connection = ARDAppClient(userId: userId, andReceiverId: targetId, andEventId : eventId, andDelegate:self, andLocalStream:self.localMediaPackage)

        return connection
    }
    
    override func disconnect(){
        super.disconnect()
        
        self.socketClient?.disconnect()
    }
}
