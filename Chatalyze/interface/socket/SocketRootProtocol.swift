//
//  SocketRootProtocol.swift
//  Chatalyze
//
//  Created by Sumant Handa on 03/11/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

protocol SocketRootProtocol {
    var isSocketConnected : Bool{
        get
    }
    
    func release(identifier : Int)
    
}
