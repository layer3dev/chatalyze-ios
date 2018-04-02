//
//  CallQueueRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class CallQueueRootView: ExtendedView {
    
    
    @IBOutlet var countdownLabel : UILabel?
    
    
    var eventInfo : EventScheduleInfo?

    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    
    private func initialization(){
        registerForTimer()
    }
    
    
    
    private func registerForTimer(){
        CountdownProcessor.sharedInstance().add { [weak self] in
            self?.refresh()
        }
    }
    
    func refresh(){
        Log.echo(key: "CallQueueRootView", text: "base refresh()")
    }
}
