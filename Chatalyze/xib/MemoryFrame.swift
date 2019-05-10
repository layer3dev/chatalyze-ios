//
//  MemoryFrame.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit


class MemoryFrame:XibTemplate{
    
    @IBOutlet var screenShotPic:UIImageView?
    @IBOutlet var name:UILabel?
    @IBOutlet var date:UILabel?
    @IBOutlet var userPic:UIImageView?
    
    override func viewDidLayout(){
        super.viewDidLayout()
    }
}
