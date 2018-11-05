//
//  CallQueueRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class CallQueueRootView: ExtendedRootView {
    
    @IBOutlet var countdownLabel : EventCountDownLabel?
    var eventInfo : EventScheduleInfo?
    var countdownIdentifier : Int = 0
    var countdownListener = CountdownListener()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    private func initialization(){
        registerForTimer()
    }
    
    private func registerForTimer(){
        countdownListener.add { [weak self] in
            self?.refresh()
        }
    }
    
    func refresh(){
        Log.echo(key: "CallQueueRootView", text: "base refresh()")
    }
    
    override func onRelease(){
        super.onRelease()

        
        Log.echo(key: "CallQueueRootView", text: "onRelease of CallQueueRootView -> \(countdownIdentifier)")
        
        countdownListener.releaseListener()
    }
    
}
