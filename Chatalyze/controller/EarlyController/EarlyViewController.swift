//
//  EarlyViewController.swift
//  Chatalyze
//
//  Created by mansa infotech on 26/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EarlyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->EarlyViewController?{
        
        let storyboard = UIStoryboard(name: "call_view", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EarlyView") as? EarlyViewController
        return controller
    }

}
