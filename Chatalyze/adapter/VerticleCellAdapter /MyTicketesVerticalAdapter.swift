//
//  MyTicketesVerticalAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit

class MyTicketesVerticalAdapter: ExtendedView {
    
    @IBOutlet var myTicketsVerticalTableView:UITableView?
    @IBOutlet var heightOfTableViewContainer:NSLayoutConstraint?
    var ticketsListingArray = [EventSlotInfo]()
    var customTicketsListingArray = [CustomTicketsInfo]()
    var root:MyTicketsVerticalRootView?
    var spinner = UIActivityIndicatorView(style: .gray)

    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        myTicketsVerticalTableView?.register(UINib(nibName: "CustomTicketCell", bundle: nil), forCellReuseIdentifier: "CustomTicketCell")
        
        myTicketsVerticalTableView?.separatorStyle = .none
        myTicketsVerticalTableView?.dataSource = self
        myTicketsVerticalTableView?.delegate = self
        initializeForTableContentHeight()
        myTicketsVerticalTableView?.reloadData()
        
        let requiredHeight = UIScreen.main.bounds.height - (UIDevice.current.userInterfaceIdiom == .pad ? 134:95)
        self.heightOfTableViewContainer?.constant = requiredHeight
    }
    
    
    func hidePaginationLoader(){
        
        spinner.stopAnimating()
        self.myTicketsVerticalTableView?.tableFooterView?.isHidden = true
    }
    
    func addNewResultsWith(info: [CustomTicketsInfo]?) {
      guard let info = info else {
        return
      }
      self.customTicketsListingArray.append(contentsOf: info)
      self.myTicketsVerticalTableView?.reloadData()
    }
    
    func hideFooterSpinner() {
      self.myTicketsVerticalTableView?.tableFooterView = nil
      self.myTicketsVerticalTableView?.reloadData()
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
            return 5
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTicketCell", for: indexPath) as? CustomTicketCell

//            if indexPath.row < self.customTicketsListingArray.count{
//
//                cell?.eventNameLbl?.text = "Abhishek"
//                cell?.backgroundColor = .blue
//                return cell ?? CustomTicketCell()
//            }
            
                
                cell?.eventNameLbl?.text = "Abhishek"
                cell?.backgroundColor = .blue
                return cell ?? CustomTicketCell()
         
        }
        
        if indexPath.row < self.ticketsListingArray.count{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTicketsVerticalCell", for: indexPath) as? MyTicketsVerticalCell else {
                return UITableViewCell()
            }
            cell.rootAdapter = self
            cell.delegate = self
            if self.root?.controller?.currentEventShowing == .past{
                cell.isJoinDisabel = true
            }else{
                cell.isJoinDisabel = false
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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        if self.root?.controller?.currentEventShowing == .custom {
//            let lastSectionIndex = tableView.numberOfSections - 1
//            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
//            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && self.root?.controller?.dataLimitReached == false && self.root?.controller?.isfetchingPaginationData == false {
//                let spinner = UIActivityIndicatorView(style: .gray)
//                spinner.startAnimating()
//                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(60))
//                self.myTicketsVerticalTableView?.tableFooterView = spinner
//                self.myTicketsVerticalTableView?.tableFooterView?.isHidden = false
//                self.root?.controller?.fetchDataForPagination()
//            } else {
//                self.myTicketsVerticalTableView?.tableFooterView?.isHidden = true
//                
//            }
//            
//            return
//        }
//        
//        if indexPath.row == self.ticketsListingArray.count-1{
//            if root?.controller?.currentEventShowing == .past {
//                root?.controller?.fetchPreviousTicketsInfoForPagination()
//            }
//        }
//    }
}

extension MyTicketesVerticalAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 550.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.root?.controller?.currentEventShowing == .custom {
            return 320.0
        }
        
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.root?.controller?.currentEventShowing == .custom{
            return
            
        }
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
