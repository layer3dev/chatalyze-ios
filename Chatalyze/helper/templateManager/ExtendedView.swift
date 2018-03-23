//
//  ExtendedView.swift

//
//  Created by Sumant Handa on 19/11/16.
//  Copyright © 2016 Mansa. All rights reserved.
//

import UIKit

class ExtendedView: UIView {
    
    private var _isLoaded = false;
    
    var isLoaded : Bool{
        get{
            return _isLoaded
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!_isLoaded){
            _isLoaded = true
            viewDidLayout()
        }
    }
    
    
    func viewDidLayout(){
    }
}

