//
//  MySessionAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MySessionAdapter: ExtendedView {

    enum scrollDirection:Int{
        
        case up = 0
        case down = 1
    }
    
    var lastContentOffset: CGFloat = 0
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
        //self.sessionTableView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
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
        
        Log.echo(key: "yud", text: "The height of the table is calling in adapter\(String(describing: sessionTableView?.contentSize.height))")
        
//        sessionTableView?.layer.removeAllAnimations()
//        if self.root?.controller?.currentEventShowing == .past{
//            if sessionTableView?.contentSize.height ?? CGFloat(0.0) > CGFloat(400.0){
//                return
//            }
//        }
//        self.root?.controller?.updateScrollViewWithTable(height: sessionTableView?.contentSize.height ?? 0.0)
        
    }
}


extension MySessionAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if root?.controller?.currentEventShowing == .past{
            if self.root?.controller?.isFetchingPastEventCompleted ?? false || self.sessionListingArray.count == 0{
                return sessionListingArray.count
            }
            return sessionListingArray.count+1
        }
        return sessionListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < self.sessionListingArray.count{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MySessionTableViewCell", for: indexPath) as? MySessionTableViewCell else {
                return UITableViewCell()
            }
            if self.root?.controller?.currentEventShowing == .past{
                cell.isPastEvents = true
            }else{
                cell.isPastEvents = false
            }
            cell.fillInfo(info:self.sessionListingArray[indexPath.row])
            cell.enterSession = self.enterSession
            cell.adapter = self
            return cell
        }
        
        Log.echo(key: "yud", text: "I am returning empty cell with indexpath \(indexPath.row) and teh session array count is \(self.sessionListingArray.count)")
        
        if self.root?.controller?.currentEventShowing == .past{
          
            guard let loaderCell = tableView.dequeueReusableCell(withIdentifier: "MySessionLoaderCell", for: indexPath) as? MySessionLoaderCell else {
                return UITableViewCell()
            }
            loaderCell.startAnimating()
            return loaderCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.sessionListingArray.count-1{
            if root?.controller?.currentEventShowing == .past {
                
                Log.echo(key: "yud", text: "Fetching the past events from will display indexpath is \(indexPath.row) and the listing array count is               \(self.sessionListingArray.count)")
                // FetchEventsForPastForPagination automatically denied if the events are fetched completely
                root?.controller?.FetchEventsForPastForPagination()
            }
            //ask for more cells
        }
        //
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
    }
}

