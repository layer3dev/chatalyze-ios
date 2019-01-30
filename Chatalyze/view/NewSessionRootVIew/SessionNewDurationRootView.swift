//
//  SessionNewDurationRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 30/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol SessionNewDurationRootViewDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
}

class SessionNewDurationRootView:ExtendedRootView {
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
}
