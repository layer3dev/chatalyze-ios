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
            return sessionListingArray.count+1
        }
        return sessionListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MySessionTableViewCell", for: indexPath) as? MySessionTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row < self.sessionListingArray.count{
            if root?.controller?.currentEventShowing == .past{
                cell.isPastEvents = true
                if indexPath.row == self.sessionListingArray.count-1 {
                    if !(self.root?.controller?.isFetchingPastEventCompleted ?? false) {
                        
                        guard let loaderCell = tableView.dequeueReusableCell(withIdentifier: "MySessionLoaderCell", for: indexPath) as? MySessionLoaderCell else {
                            return UITableViewCell()
                        }
                        loaderCell.startAnimating()
                        return loaderCell
                    }
                    return UITableViewCell()
                }
            }else{
                 cell.isPastEvents = false 
            }
            cell.fillInfo(info:self.sessionListingArray[indexPath.row])
            cell.enterSession = self.enterSession
            cell.adapter = self
            //cell.controller = self.controller
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.sessionListingArray.count-1{
            if root?.controller?.currentEventShowing == .past {
                
                Log.echo(key: "yud", text: "Fetching the past events from will display indexpath is \(indexPath.row) and the listing array count is               \(self.sessionListingArray.count)")
                root?.controller?.FetchEventsForPastForPagination()
            }
            //ask for more cells
        }
        //
    }
}

extension MySessionAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.root?.controller?.currentEventShowing == .past{
            if (self.root?.controller?.isFetchingPastEventCompleted ?? false){
                if indexPath.row == self.sessionListingArray.count-1{
                    return 0
                }
            }else{
                if indexPath.row == self.sessionListingArray.count-1{
                    return 20
                }
            }
        }
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let controller = SessionDetailController.instance() else{
            return
        }
        
        if indexPath.row > (sessionListingArray.count-1){
            return
        }
        
        controller.eventInfo = self.sessionListingArray[indexPath.row]
        
        self.root?.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}

extension MySessionAdapter:UIScrollViewDelegate{
    
    //we set a variable to hold the contentOffSet before scroll view scrolls
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
        //Begin scrolling
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        //scroling
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            
            self.root?.controller?.handleScrollingHeader(direction:.up)
            // did move up
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            
            self.root?.controller?.handleScrollingHeader(direction:.down)
            // did move down
        } else {
            // didn't move
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.root?.controller?.handleScrollingHeaderOnEndDragging(direction: .up)
        //Verify that header needs to permanent open or close.
    }
}

