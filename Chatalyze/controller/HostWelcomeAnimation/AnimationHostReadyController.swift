//
//  AnimationHostReadyController.swift
//  Chatalyze
//
//  Created by mansa infotech on 27/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AnimationHostReadyController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func letsDoIt(sender:UIButton?){
      
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
        })
        
        RootControllerManager().navigateToScheduleSessionController()
        // Dismiss and then Root to schedule session class.
    }
    
    @IBAction func skipAction(sender:UIButton?){
        
        //Dismiss and then Root to schedule session class.
        //Explore my account instead
        
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    class func instance()->AnimationHostReadyController? {
        
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AnimationHostReady") as? AnimationHostReadyController
        return controller
    }

}
