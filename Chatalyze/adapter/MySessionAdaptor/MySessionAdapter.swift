//
//  MySessionAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MySessionAdapter: ExtendedView {
    
    var root:MySessionRootView?
    var sessionListingArray = [EventInfo]()
    var spinner = UIActivityIndicatorView(style: .gray)
    var controller:MyScheduledSessionsController?
    var sessionTableView:UITableView?
    
    var enterSession:((EventInfo?)->())?
    var sharedLinkListener:((EventInfo)->())?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.sessionTableView?.separatorStyle = .none
        self.sessionTableView?.tableFooterView?.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
    }
    
    func initializeAdapter(table:UITableView?){
        
        Log.echo(key: "yud", text: "ScheduleSession table is \(table)")
        sessionTableView = table
        self.sessionTableView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        sessionTableView?.dataSource = self
        sessionTableView?.delegate = self
        sessionTableView?.reloadData()
    }
    
    func updatedInfo(info:[EventInfo]?){
       
        guard let info = info else {
            return
        }
        sessionListingArray = info
        sessionTableView?.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        Log.echo(key: "yud", text: "The height of the table is calling in adapter\(sessionTableView?.contentSize.height) ")
        
        sessionTableView?.layer.removeAllAnimations()
        self.root?.controller?.updateScrollViewWithTable(height: sessionTableView?.contentSize.height ?? 0.0)        
//        self.updateConstraints()
//        self.layoutIfNeeded()
    }
}


extension MySessionAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return memoriesListingArray.count
        return sessionListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MySessionTableViewCell", for: indexPath) as? MySessionTableViewCell else {
            
            return UITableViewCell()
        }
        if indexPath.row < self.sessionListingArray.count{
            cell.fillInfo(info:self.sessionListingArray[indexPath.row])
            cell.enterSession = self.enterSession
            cell.adapter = self
            //cell.controller = self.controller
            return cell
        }
        return UITableViewCell()
    }
}

extension MySessionAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
//        if indexPath.row > (sessionListingArray.count-1){
//            return
//        }
//        self.sharedLinkListener?(sessionListingArray[indexPath.row])
        
        
        guard let controller = EditHostSessionController.instance() else{
            return
        }
        
        controller.eventInfo = self.sessionListingArray[indexPath.row]
        self.root?.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension MySessionAdapter:UIScrollViewDelegate{
}

