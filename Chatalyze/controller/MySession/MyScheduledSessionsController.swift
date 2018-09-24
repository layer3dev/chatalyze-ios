//
//  MyScheduledSessionsController.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MyScheduledSessionsController: InterfaceExtendedController {

    @IBOutlet var sessionListingTableView:UITableView?
    @IBOutlet var noeventLbl:UILabel?
    var eventArray:[EventInfo] = [EventInfo]()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        
        initializeVariable()
        paintInterface()
    }
    
    func initializeVariable(){        
        
        rootView?.controller = self        
        fetchInfo()
        rootView?.initializeAdapter(table:self.sessionListingTableView)
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "My Sessions")
        paintSettingButton()
        
        
    }
    
    func fetchInfo(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return
        }
        self.showLoader()
        FetchMySessionsProcessor().fetchInfo(id: id) { (success, info) in
         
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
    
    var rootView:MySessionRootView?{
        
        get{
            return self.view as? MySessionRootView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated.
    }
}

extension MyScheduledSessionsController{
    
    class func instance()->MyScheduledSessionsController?{
        
        let storyboard = UIStoryboard(name: "MySessions", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyScheduledSessions") as? MyScheduledSessionsController
        return controller
    }
}

