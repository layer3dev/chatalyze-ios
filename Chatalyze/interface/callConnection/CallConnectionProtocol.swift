//
//  CallConnectionProtocol.swift
//  Chatalyze
//
//  Created by Sumant Handa on 26/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

protocol CallConnectionProtocol {
    func updateConnectionState(state : RTCIceConnectionState, slotInfo : SlotInfo?)
}
