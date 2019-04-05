//
//  MySessionLoaderCell.swift
//  Chatalyze
//
//  Created by mansa infotech on 03/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class MySessionLoaderCell: ExtendedTableCell {

    @IBOutlet var indicator:UIActivityIndicatorView?
    override func viewDidLayout() {
        super.viewDidLayout()
        startAnimating()
    }
    
    func startAnimating(){
        indicator?.startAnimating()
    }
    
}
