//
//  PaymentListRootView.swift
//  Chatalyze
//
//  Created by Mansa on 17/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class PaymentListRootView:ExtendedView{
    
    var controller:PaymentListingController?
    @IBOutlet fileprivate var adapter:PaymentAdapter?
    override func viewDidLayout(){
        super.viewDidLayout()
        
        adapter?.root = self
    }
    
    func fillInfo(info:[PaymentListingInfo]?){
        
        guard let info = info else{
            return
        }
        adapter?.initailizeAdapter(info:info)
    }
    
    func insertPageData(info:PaymentListingInfo?){
        
        guard let info = info else {
            return
        }
        adapter?.insertPageData(info:info)
    }
    
    func hidePaginationLoader(){
        
        adapter?.hidePaginationLoader()
    }
    func fetchDataForPagination(){
       controller?.fetchDataForPagination()
    }
}
