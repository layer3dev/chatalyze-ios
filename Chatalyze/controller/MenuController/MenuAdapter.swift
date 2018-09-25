//
//  MenuAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 21/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MenuAdapter: ExtendedView {
    
    @IBOutlet var menuTableView:UITableView?
    var root:MenuRootView?
    var menuListingArray = [MenuInfo]()
    var currentArray = [String]()
    var analystArray = ["My Sessions","Payments","Schedule Session","Edit Profile","Contact Us"]
    var userArray = ["My Tickets","Autographs","Payments","Edit Profile","Contact Us"]
    var selectedSlideBarTab:((MenuRootView.MenuType?)->())?
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialize()
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

extension MenuAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 145.0
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


