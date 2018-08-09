//
//  EventController.swift
//  Chatalyze
//
//  Created by Mansa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventController: TabChildLoadController {
    
    @IBOutlet var rootView:EventRootView?
    var eventArray = [EventInfo]()
    @IBOutlet var noeventLbl:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
       
        paintInterface()
        initializeVariable()
    }
    
    override func viewGotLoaded() {
        super.viewGotLoaded()

        fetchEvents()
    }
    
    func paintInterface(){
        
        paintNavigationBar()
    }
    
    func initializeVariable(){
        
        rootView?.controller = self
    }
    
    private func paintNavigationBar(){
        
        paintSettingButton()
        paintNavigationTitle(text: "UPCOMING SESSIONS")      
    }
    
    func fetchEvents(){
        
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        self.showLoader()
        EventProcessor().fetchInfo(id: userId) { (success, info) in
            
            self.stopLoader()
            self.eventArray.removeAll()
            self.noeventLbl?.isHidden = true
            if success{
                if let array  = info{
                    if array.count > 0{
                        self.noeventLbl?.isHidden = true
                        for info in array{
                            self.eventArray.append(info)                        
                            self.rootView?.fillInfo(info: self.eventArray)
                        }
                    }else if array.count <= 0{
                        self.noeventLbl?.isHidden = false
                        self.rootView?.fillInfo(info: self.eventArray)
                    }
                    return
                }
            }
            self.noeventLbl?.isHidden = false
            self.rootView?.fillInfo(info: self.eventArray)
            return
        }
    }

    func fetchEventsForPagination(){
        
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        self.showLoader()
        EventProcessor().fetchInfo(id: userId) { (success, info) in
            
            self.stopLoader()
            self.eventArray.removeAll()
            self.noeventLbl?.isHidden = true
            if success{
                
                if let array  = info{
                    if array.count > 0{
                        
                        for info in array{
                            self.eventArray.append(info)
                        }
                        self.rootView?.fillInfo(info: self.eventArray)
                        self.noeventLbl?.isHidden = true
                        return
                    }else if array.count <= 0{
                        
                        self.noeventLbl?.isHidden = false
                        self.rootView?.fillInfo(info: self.eventArray)
                    }
                    return
                }
            }
            self.noeventLbl?.isHidden = false
            self.rootView?.fillInfo(info: self.eventArray)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EventController{
    
    class func instance()->EventController?{
        
        let storyboard = UIStoryboard(name: "Event", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Event") as? EventController
        return controller
    }
}
