//
//  MySessionAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class MySessionAdapter: ExtendedView {
    
    var root:MemoriesRootView?
    var memoriesListingArray = [MemoriesInfo]()
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var controller:MemoriesController?
    
    var sessionTableView:UITableView?
    override func viewDidLayout() {
        super.viewDidLayout()
        
//        self.memoriesListingTableView?.separatorStyle = .none
//        self.memoriesListingTableView?.tableFooterView?.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
    }
    
    
    func initializeAdapter(table:UITableView?){
        
        sessionTableView = table
        sessionTableView?.dataSource = self
        sessionTableView?.delegate = self
        sessionTableView?.reloadData()
    }
    
    
//    func initailizeAdapter(info:[MemoriesInfo]?){
//
//        guard let info = info else {
//            return
//        }
//        memoriesListingArray = info
//        memoriesListingTableView?.dataSource = self
//        memoriesListingTableView?.delegate = self
//        memoriesListingTableView?.reloadData()
//    }
}


extension MySessionAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return memoriesListingArray.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MySessionTableViewCell", for: indexPath) as? MySessionTableViewCell else {
            
            return UITableViewCell()
        }
//        if indexPath.row < self.memoriesListingArray.count{
//
//            cell.fillInfo(info:self.memoriesListingArray[indexPath.row])
//            cell.controller = self.controller
//            return cell
//        }
        return cell
    }
}

extension MySessionAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 181.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        guard let controller = GreetingInfoController.instance() else {
    //            return
    //        }
    //        if indexPath.row < self.PaymentListingArray.count {
    //
    //            controller.info = self.PaymentListingArray[indexPath.row]
    //        }
    //        self.root?.controller?.navigationController?.pushViewController(controller, animated: true)
    //    }
}

extension MySessionAdapter:UIScrollViewDelegate{
    
   
}

