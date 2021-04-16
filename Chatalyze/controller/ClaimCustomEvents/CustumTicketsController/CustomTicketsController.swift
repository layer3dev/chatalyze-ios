//
//  CustomTicketsController.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 05/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//


protocol getCustomTicketScrollInsets {
    
    func getCutomtickScrollInset(offset:CGFloat?)
}
import Foundation
import Analytics
import UIKit


class CustomTicketsController: InterfaceExtendedController {
    
    
    var dataLimitReached = false
    var isfetchingPaginationData = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initilization()
        getPaymentInfo()
    }
    
    @IBOutlet weak var rootView:CustomTicketsRootView?
    var customTicketsArray = [CustomTicketsInfo]()
    var delegate : getCustomTicketScrollInsets?
    
    fileprivate func initilization(){
        rootView?.controller = self

    }
    
    
    func getPaymentInfo(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        self.showLoader()
        
        CustomTicketsHandler().fetchInfo(with: id, offset: 0) {[weak self] (success, info) in
            
            self?.stopLoader()
           
            if let allocatedSelf = self {
                allocatedSelf.view.isUserInteractionEnabled = true
                if !success {
                    allocatedSelf.dataLimitReached = true
                    allocatedSelf.rootView?.adapter?.hideFooterSpinner()
                    allocatedSelf.customTicketsArray.removeAll()
                    return
                }
                
                guard let infos = info else {
                    allocatedSelf.dataLimitReached = true
                    allocatedSelf.rootView?.adapter?.hideFooterSpinner()
                    return
                }
                if infos.count == 0 {
                    if allocatedSelf.rootView?.adapter?.customTicketsListingArray.count ?? Int() > 0 {
                        allocatedSelf.rootView?.fillInfo(info: [])
                    }
                    allocatedSelf.dataLimitReached = true
                    allocatedSelf.stopLoader()
                    return
                }
                
                allocatedSelf.rootView?.fillInfo(info: info)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    allocatedSelf.isfetchingPaginationData = false
                }
                if infos.count < 2 {
                    allocatedSelf.dataLimitReached = true
                    return
                }
                return
            }
        }
    }
    
    func fetchDataForPagination(){
        if (self.isfetchingPaginationData == true) {
          return
        }
        self.isfetchingPaginationData = true
        guard let offset = self.rootView?.adapter?.customTicketsListingArray.count else {return}
        
        guard let userId = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        CustomTicketsHandler().fetchInfo(with: userId, offset: offset) {[weak self] (success, info) in
        
            self?.stopLoader()
            if let allocatedSelf = self {
              if !success {
                allocatedSelf.dataLimitReached = true
                allocatedSelf.rootView?.adapter?.hideFooterSpinner()
                return
              }
              guard let infos = info else {
                allocatedSelf.dataLimitReached = true
                allocatedSelf.rootView?.adapter?.hideFooterSpinner()
                return
              }
              if infos.count == 0 {
                allocatedSelf.dataLimitReached = true
                allocatedSelf.rootView?.adapter?.hideFooterSpinner()
                return
              }
                allocatedSelf.rootView?.adapter?.addNewResultsWith(info: info)
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                allocatedSelf.isfetchingPaginationData = false
              }
              if infos.count < 2 {
                allocatedSelf.dataLimitReached = true
                return
              }
              return
            }
        }
    }
}

extension CustomTicketsController {
    
    class func instance()->CustomTicketsController?{
        
        let storyboard = UIStoryboard(name: "ClaimCustomTickets", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CustomTicketsController") as? CustomTicketsController
        return controller
    }
}

extension CustomTicketsController{
    
    func updateTableContentOffset(offset:CGFloat?){
        
        guard let offset = offset  else {
            return
        }
        delegate?.getCutomtickScrollInset(offset: offset)
    }
    
}
