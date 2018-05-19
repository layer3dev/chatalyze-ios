//
//  MemoriesRootView.swift
//  Chatalyze
//
//  Created by Mansa on 19/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MemoriesRootView: ExtendedView {
    
    var controller:MemoriesController?
    @IBOutlet var adapter:MemoriesAdapter?
    override func viewDidLayout() {
        super.viewDidLayout()

        adapter?.root = self
    }

    func fillInfo(info:[MemoriesInfo]?){
        
        guard let info = info else{
            return
        }
        adapter?.initailizeAdapter(info:info)
    }
    
    func insertPageData(info:MemoriesInfo?){
        
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

    func updateTableContentOffset(offset:CGFloat?){
        
        guard let offset = offset else {
            return
        }
        self.controller?.updateTableContentOffset(offset:offset)
    }
}
