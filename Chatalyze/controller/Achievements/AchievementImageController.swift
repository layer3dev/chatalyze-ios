//
//  AchievementImageController.swift
//  Chatalyze
//
//  Created by mansa infotech on 24/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AchievementImageController: PageScrollerController {

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
    
    override class func instance()->AchievementImageController?{
        
        let storyboard = UIStoryboard(name: "Achievements", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AchievementImage") as? AchievementImageController
        return controller
    }

}
