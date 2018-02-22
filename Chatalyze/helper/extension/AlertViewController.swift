//
//  AlertViewController.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 31/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    
    func alert(withTitle title : String = AppInfoConfig.appName, message : String = "", successTitle : String = "", rejectTitle : String = "", showCancel : Bool = false, completion : ((_ success : Bool)->())? = nil
        ){
        
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        
        var successTitle = successTitle
        
        if(successTitle == ""){
            successTitle = showCancel ? "Yes" : "OK"
        }
        
        var rejectTitle = rejectTitle
        
        if(rejectTitle == ""){
            rejectTitle = "No"
        }
        
        
        
        
        
        let successAction = UIAlertAction(title: successTitle, style: .default) { (action) in
            completion?(true)
            return
        }
        
        
        let rejectAction = UIAlertAction(title: rejectTitle, style: .cancel) { (action) in
            completion?(false)
            return
        }
        
        alertController.addAction(successAction)
        if(showCancel){
            alertController.addAction(rejectAction)
        }
        
        
        present(alertController, animated: true, completion: nil)
        
    }
}
