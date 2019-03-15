//
//  MenuAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 21/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class MenuAdapter: ExtendedView {
    
    @IBOutlet var menuTableView:UITableView?
    var root:MenuRootView?
    var menuListingArray = [MenuInfo]()
    var currentArray = [String]()
    //var analystArray = ["My Sessions","Settings","Contact Us","Chatalyze Pro"]
    var analystArray = ["My Sessions","Settings","Contact Us"]
    var userArray = ["My Tickets","Memories", "Settings","Version \(AppInfoConfig.appversion)"]
    
    var selectedSlideBarTab:((MenuRootView.MenuType?)->())?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        updateSideBarWithList()
        initialize()
    }
    
    func updateSideBarWithList(){
        
        if SignedUserInfo.sharedInstance?.planIdentifier ?? "" == "pro" && SignedUserInfo.sharedInstance?.isTrialPlanActive == false{
            analystArray = ["My Sessions","Settings","Contact Us"]
        }else{
            analystArray = ["My Sessions","Settings","Contact Us","Chatalyze Pro"]
        }
    }
    
    func reloadDataAfterFetchingData(){
  
        Log.echo(key: "MenuAdapter", text: "Reloading my self")
        updateSideBarWithList()
        guard let roleId = SignedUserInfo.sharedInstance?.role else{
            return
        }
        if roleId == .analyst{
            
            currentArray = analystArray
        }else{
            
            currentArray = userArray
        }
        
        menuTableView?.dataSource = self
        menuTableView?.delegate = self
        menuTableView?.reloadData()
    }
    func initialize(){
        
        guard let roleId = SignedUserInfo.sharedInstance?.role else{
            return
        }
        if roleId == .analyst{
            
            currentArray = analystArray
        }else{
            
            currentArray = userArray
        }
        
        menuTableView?.dataSource = self
        menuTableView?.delegate = self
        menuTableView?.reloadData()        
    }
    
    func initailizeAdapter(info:[MenuInfo]?){
        
        guard let info = info else {
            return
        }
        menuListingArray = info
        menuTableView?.dataSource = self
        menuTableView?.delegate = self
        menuTableView?.reloadData()
    }
}

extension MenuAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuCell else {            
            return UITableViewCell()
        }
        cell.selectedSlideBarTab = self.selectedSlideBarTab
        if indexPath.row < currentArray.count{
            cell.optionName?.text = currentArray[indexPath.row]
        }
        return cell
    }
}

extension MenuAdapter:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 145.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
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


