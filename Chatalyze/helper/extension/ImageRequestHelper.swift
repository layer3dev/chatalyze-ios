//
//  ImageRequestHelper.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 30/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit
import ImageLoader

public extension UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func load(withURL url : String?, placeholder : UIImage? = nil){
        guard let url = url
            else{
                return
        }
        
        if(url == ""){
            return
        }
        self.load.request(with: url, placeholder: placeholder) { (image, error, operation) in
            
        }
    }

}
