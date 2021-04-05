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
     var analystArray = ["My sessions","Payout details","Get in touch","Settings","Refer friends and earn"]
    
//    var analystArray = ["My Sessions","Settings","Contact Us","Refer friends and earn"]
    
    //var analystArray = ["My Sessions","Settings","Contact Us"]
    
    var userArray = ["My Tickets","Memories","Claim Tickets","Settings"]
    
    var selectedSlideBarTab:((MenuRootView.MenuType?)->())?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        //updateSideBarWithList()
        initialize()
    }
    
//    func updateSideBarWithList(){
//
///Log.echo(key: "yud", text: "Does this plan exists \(SignedUserInfo.sharedInstance?.isSubscriptionPlanExists) Subscription plan identifier is \(SignedUserInfo.sharedInstance?.planIdentifier) and the subscription plan id is \(SignedUserInfo.sharedInstance?.planId) is trial activated  \(SignedUserInfo.sharedInstance?.isTrialPlanActive)")
//
//        //For old user
//        if SignedUserInfo.sharedInstance?.isSubscriptionPlanExists ?? false == false {
//
//            analystArray = ["My Sessions","Settings","Contact Us"]
//            return
//        }
//
//        // For new starter user
//
//        if SignedUserInfo.sharedInstance?.planIdentifier ?? "" == "pro" && SignedUserInfo.sharedInstance?.isTrialPlanActive == true {
//
//            analystArray = ["My Sessions","Settings","Contact Us","Chatalyze Pro"]
//            return
//        }
//
//        //For new pro users
//
//        if SignedUserInfo.sharedInstance?.planIdentifier ?? "" == "pro" && SignedUserInfo.sharedInstance?.isTrialPlanActive == false{
//
//            analystArray = ["My Sessions","Settings","Contact Us"]
//            return
//        }
//
//        //For the users who have any other plan othe than pro.
//
//        if SignedUserInfo.sharedInstance?.planIdentifier ?? "" != "pro" && SignedUserInfo.sharedInstance?.isTrialPlanActive == false{
//
//            analystArray = ["My Sessions","Settings","Contact Us","Chatalyze Pro"]
//            return
//        }
//
//    }
    
//    func reloadDataAfterFetchingData(){
//
//        Log.echo(key: "MenuAdapter", text: "Reloading my self")
//        updateSideBarWithList()
//        guard let roleId = SignedUserInfo.sharedInstance?.role else{
//            return
//        }
//        if roleId == .analyst{
//
//            currentArray = analystArray
//        }else{
//
//            currentArray = userArray
//        }
//
//        menuTableView?.dataSource = self
//        menuTableView?.delegate = self
//        menuTableView?.reloadData()
//    }
    
    
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


