//
//  CustomTicketsRootView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 05/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class CustomTicketsRootView: ExtendedView {
    
   
    
    var controller : CustomTicketsController?
    @IBOutlet weak var adapter: CustomTicketsAdapter?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        adapter?.root = self
        
    }
    
    func fillInfo(info:[CustomTicketsInfo]?){
            
            guard let info = info else{
                return
            }
            adapter!.controller = self.controller
            adapter?.initailizeAdapter(info:info)
        }
    
//    func insertPageData(info:CustomTicketsInfo?){
//
//            guard let info = info else {
//                return
//            }
//            adapter?.insertPageData(info:info)
//        }
    
    func hidePaginationLoader(){
             
        adapter?.hidePaginationLoader()
    }
    
//    func fetchDataForPagination(){
//
//        controller?.fetchDataForPagination()
//    }

    func updateTableContentOffset(offset:CGFloat?){
        
        guard let offset = offset else {
            return
        }
        self.controller?.updateTableContentOffset(offset:offset)
    }

}
