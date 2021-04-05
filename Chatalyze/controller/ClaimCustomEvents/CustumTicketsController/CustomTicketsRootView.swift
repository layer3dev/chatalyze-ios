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
    
    func fillInfo(info:[MemoriesInfo]?){
            
            guard let info = info else{
                return
            }
            adapter?.controller = self.controller
            adapter?.initailizeAdapter(info:info)
        }
    
    func insertPageData(info:MemoriesInfo?){
            
            guard let info = info else {
                return
            }
            adapter?.insertPageData(info:info)
        }
    
}
