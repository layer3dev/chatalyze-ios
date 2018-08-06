//
//  RootHelper.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class RootHelper{
    
    func getCurrentController()->ContainerController?{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let root = appDelegate?.window?.rootViewController as? ContainerController
        return root
    }
    
    
    
}
