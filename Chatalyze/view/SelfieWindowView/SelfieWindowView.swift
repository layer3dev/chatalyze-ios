//
//  SelfieWindowView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 31/05/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class SelfieWindowView:ExtendedView {
    
    @IBOutlet weak var hostStream : UIView?
    @IBOutlet weak var LocalStream : UIView?
    @IBOutlet weak var finalmemoryImg : UIImageView?
    @IBOutlet weak var reTakeSelfieBtn : UIButton?
    @IBOutlet weak var photoboothLbl : UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    
}
