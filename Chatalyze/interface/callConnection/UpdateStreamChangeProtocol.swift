//
//  UpdateStreamChangeProtocol.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 01/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
protocol UpdateStreamChangeProtocol {
    func updateForStreamPosition(isPortrait:Bool)
    func getContainerSize()->CGSize
}
