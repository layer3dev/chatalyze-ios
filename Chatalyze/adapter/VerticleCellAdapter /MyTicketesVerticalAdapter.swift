//
//  MyTicketesVerticalAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit
import SwiftyJSON
import SendBirdSDK
import SendBirdUIKit

class MyTicketesVerticalAdapter: ExtendedView {
    
    @IBOutlet var myTicketsVerticalTableView:UITableView?
    @IBOutlet var heightOfTableViewContainer:NSLayoutConstraint?
    var ticketsListingArray = [EventSlotInfo]()
    var customTicketsListingArray = [CustomTicketsInfo]()
    var root:MyTicketsVerticalRootView?
    var spinner = UIActivityIndicatorView(style: .gray)
    var strUUID = UUID().uuidString
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        myTicketsVerticalTableView?.register(UINib(nibName: "ClaimTicketCell", bundle: nil), forCellReuseIdentifier: "ClaimTicketCell")
        
        myTicketsVerticalTableView?.register(UINib(nibName: "SessionTicketCell", bundle: nil), forCellReuseIdentifier: "SessionTicketCell")
        
        myTicketsVerticalTableView?.separatorStyle = .none
        myTicketsVerticalTableView?.dataSource = self
        myTicketsVerticalTableView?.delegate = self
        initializeForTableContentHeight()
        myTicketsVerticalTableView?.reloadData()
        
        let requiredHeight = UIScreen.main.bounds.height - (UIDevice.current.userInterfaceIdiom == .pad ? 134:95)
        self.heightOfTableViewContainer?.constant = requiredHeight
    }
    
    
    func initializeForTableContentHeight(){
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.myTicketsVerticalTableView?.layer.removeAllAnimations()
        self.heightOfTableViewContainer?.constant = myTicketsVerticalTableView?.contentSize.height ?? 0.0
        self.updateConstraints()
        self.layoutIfNeeded()
    }
    
    func initailizeAdapter(info:[EventSlotInfo]?){
        
        DispatchQueue.main.async {
            
            guard let info = info else {
                
                self.ticketsListingArray.removeAll()
                self.myTicketsVerticalTableView?.reloadData()
                return
            }
            self.ticketsListingArray = info
            self.myTicketsVerticalTableView?.reloadData()
        }
    }
    
    func initailizeAdapterForCustomTickets(info:[CustomTicketsInfo]?){
        
        DispatchQueue.main.async {
            
            guard let info = info else {
                
                self.ticketsListingArray.removeAll()
                self.myTicketsVerticalTableView?.reloadData()
                return
            }
            self.customTicketsListingArray = info
            self.myTicketsVerticalTableView?.reloadData()
        }
    }
    
}

extension MyTicketesVerticalAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if root?.controller?.currentEventShowing == .custom{
            if self.root?.controller?.isFetchingCustomEventCompleted ?? false || self.customTicketsListingArray.count == 0{
                return customTicketsListingArray.count
            }
            return customTicketsListingArray.count
            
        }
        
        if root?.controller?.currentEventShowing == .past{
            if self.root?.controller?.isFetchingPastEventCompleted ?? false || self.ticketsListingArray.count == 0{
                return ticketsListingArray.count
            }
            return ticketsListingArray.count+1
        }
        return ticketsListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.root?.controller?.currentEventShowing == .custom{
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClaimTicketCell", for: indexPath) as? ClaimTicketCell else{
                return UITableViewCell()
                
            }
            cell.rootAdapter = self
            cell.delegate = self
            cell.controller = self.root
            cell.selectionStyle = .none
            cell.borderView?.layer.borderColor = UIColor(hexString: "#E4E4E4").cgColor
            cell.borderView?.layer.borderWidth = 1
            cell.fillInfo(info: customTicketsListingArray[indexPath.row])
            return cell
            
            
        }
        
        if indexPath.row < self.ticketsListingArray.count{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SessionTicketCell", for: indexPath) as? SessionTicketCell else {
                return UITableViewCell()
            }
            cell.rootAdapter = self
            cell.delegate = self
            if self.root?.controller?.currentEventShowing == .past{
                cell.isJoinDisabel = true
                cell.btnChat.isHidden = false
                cell.btnChat.tag = indexPath.row
                cell.btnChat.addTarget(self, action: #selector(goToChat(_:)), for: .touchUpInside)
            }else{
                cell.isJoinDisabel = false
                cell.btnChat.isHidden = true
            }
            cell.fillInfo(info: ticketsListingArray[indexPath.row])
            return cell
        }
        
        //Log.echo(key: "yud", text: "I am returning empty cell with indexpath \(indexPath.row) and teh session array count is \(self.sessionListingArray.count)")
        
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

        
        if indexPath.row == self.ticketsListingArray.count-1{
            
            if root?.controller?.currentEventShowing == .past {
                root?.controller?.fetchPreviousTicketsInfoForPagination()
            }
            
            if root?.controller?.currentEventShowing == .custom{
                root?.controller?.fetchCustomTicketsInfoForPagination()
            }
        }
        
    }
    
    func createUserId(room_id: String, id: String) -> String {
        return AppConnectionConfig.webServiceURL.contains("dev") ? "dev_\(room_id)_\(id)" : "live_\(room_id)_\(id)"
    }
    
    @objc func goToChat(_ sender: UIButton) {
        guard let users = SignedUserInfo.sharedInstance else {
            return
        }
        let ticket = ticketsListingArray[sender.tag]
        let userId = createUserId(room_id: ticket.room_id ?? "", id: users.id ?? "")
        let channelURL = "chatalyze_\(ticket.room_id ?? "")_\(ticket.hostId ?? 0)_\(users.id ?? "")"
        SBUGlobals.CurrentUser = SBUUser(userId: userId, nickname:users.firstName ?? "", profileUrl:users.profileImage ?? "")
        SBDMain.add(self as SBDChannelDelegate, identifier: userId)
        SBDMain.connect(withUserId: userId) { user, err in
            guard err == nil else {
                return
            }
            SBDGroupChannel.getWithUrl(channelURL) { groupChannel, error in
                guard error == nil else {
                    return
                }
                SBDMain.updateCurrentUserInfo(withNickname: users.firstName, profileUrl: users.profileImage) { error in
                    guard error == nil else {
                        return
                    }
                    groupChannel?.join(completionHandler: { (error) in
                        guard error == nil else {
                            return
                        }
                        let channelVC = SBUChannelViewController(channelUrl: groupChannel?.channelUrl ?? "")
                        channelVC.messageInputView.addButton?.removeFromSuperview()
                        channelVC.useRightBarButtonItem = false
                        channelVC.channelName = "Live Support"
                        let naviVC = UINavigationController(rootViewController: channelVC)
                        self.root?.controller?.present(naviVC, animated: true)
                    })
                }
            }
        }
    }
}

extension MyTicketesVerticalAdapter:SBDChannelDelegate{
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        print(message.message)
    }
}

extension MyTicketesVerticalAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 550.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        Log.echo(key: "yud", text: "scroll content offset is \(scrollView.contentOffset.y)")
        
        if scrollView.contentOffset.y <= (UIDevice.current.userInterfaceIdiom == .pad ? 90:75) {
            
            if scrollView.contentOffset.y < 0.0{
                self.root?.controller?.topOfHeaderConstraint?.constant = 0
                return
            }
            self.root?.controller?.topOfHeaderConstraint?.constant = -scrollView.contentOffset.y
            return
        }
        if scrollView.contentOffset.y > (UIDevice.current.userInterfaceIdiom == .pad ? 90:75){
            self.root?.controller?.topOfHeaderConstraint?.constant = -(UIDevice.current.userInterfaceIdiom == .pad ? 90:75)
        }
    }
}


extension MyTicketesVerticalAdapter:MyTicketCellDelegate{
    
    func claimTicket(info: PurchaseTicketRequest?) {
        Log.echo(key: "dhi", text: "claim ticket")
        
        guard let info = info else {
            return
        }
       
        PurchaseTicketManager().fethcInfo(userId: info.userId ?? Int(), sessionId: info.sessionid ?? Int(), date: "\(Date())") { (success, message) in
            RootControllerManager().getCurrentController()?.showLoader()
            
            guard let myTicketsController = MyTicketsVerticalController.instance()
                else{
                return
            }
            
            if success{
                RootControllerManager().getCurrentController()?.stopLoader()
                let alert = UIAlertController(title: AppInfoConfig.appName, message: "You have successfully claimed the ticket!".localized(), preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok".localized(), style: .default) { (success) in
                    //
                    Log.echo(key: "MyTicketesVerticalAdapter", text: "successfully claimed!")
                    
                    
                    RootControllerManager().getCurrentController()?.navController?.navigationItem.leftBarButtonItems = []
                    RootControllerManager().getCurrentController()?.navController?.navigationItem.hidesBackButton = true
                    RootControllerManager().getCurrentController()?.navController?.navigationItem.setHidesBackButton(true, animated: true)

                    RootControllerManager().getCurrentController()?.navController?.pushViewController(myTicketsController, animated: true)
                }
                alert.addAction(action)
                RootControllerManager().getCurrentController()?.present(alert, animated: true, completion: nil)
            }else{
                RootControllerManager().getCurrentController()?.stopLoader()
                RootControllerManager().getCurrentController()?.alert(withTitle: AppInfoConfig.appName, message: message ?? "", successTitle: "Ok".localized() ?? "", showCancel: false) { _ in
                    RootControllerManager().getCurrentController()?.navController?.navigationItem.leftBarButtonItems = []
                    RootControllerManager().getCurrentController()?.navController?.navigationItem.hidesBackButton = true
                    RootControllerManager().getCurrentController()?.navController?.navigationItem.setHidesBackButton(true, animated: true)

                    RootControllerManager().getCurrentController()?.navController?.pushViewController(myTicketsController, animated: true)
                }
                
            }
            
        }
    }
    
    
    func jointEvent(info:SlotInfo?){
        validateVPN {[weak self] in
            self?.launchSession(info: info)
        }
        
    }
    
    private func validateVPN(completion : (()->())?){
        ValidateVPN().showVPNWarningAlert {
            completion?()
        }
    }
    
    private func launchSession(info : SlotInfo?){
        guard let slotInfo = info
            else{
                return
        }
        guard let eventId = slotInfo.callscheduleId
            else{
                return
        }
        guard let controller = UserCallController.instance()
            else{
                return
        }
        controller.eventId = String(eventId)
        controller.modalPresentationStyle = .fullScreen
        self.root?.controller?.present(controller, animated: false, completion: nil)
    }
    
    func systemTest(){
        
        guard let controller = InternetSpeedTestController.instance() else{
            return
        }
        controller.onlySystemTest = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
        })
    }
    
    func refreshData() {
    }
}
