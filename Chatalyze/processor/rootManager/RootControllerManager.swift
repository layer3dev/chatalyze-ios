//
//  RootControllerManager.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 27/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import UIKit

class RootControllerManager{

    func setRoot(){

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        _ = appDelegate?.window
        

        delayLaunchScreen { 
            self.showRelevantScreen()
        }
    }
    
    func updateRoot(){
        self.showRelevantScreen()
    }
    
    private func showRelevantScreen(){
  
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = AppThemeConfig.navigationBarColor
        UINavigationBar.appearance().tintColor = AppThemeConfig.navigationBarColor
        UINavigationBar.appearance().barStyle = .black        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        
        //Log.echo(key: "yud", text: "Api info in root Controller\(apiInfo)")
        
       
        
        /*guard let controller = ContainerController.instance()
            else{
                return
        }
        Log.echo(key: "yud", text: "Root is active")
        //let navigationController = UINavigationController(rootViewController: controller)
        //navigationController.navigationBar.backgroundColor = UIColor.white
        let transition = CATransition()
        transition.type = kCATransitionFade
        window?.set(rootViewController: controller, withTransition: transition)
        APIVersionControl().showDepricateAlert()
        APIVersionControl().showUpdateAlert()
        //window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        initializeAppConnection(rootController: controller)
        return*/
    }
    
    
   
    
    
    
    
    fileprivate func delayLaunchScreen(completion : @escaping (()->())){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        window?.rootViewController = LaunchDelayController.instance()
        let when = DispatchTime.now() + 1
        //change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            completion()
            return
        }
    }
    
    
    
    
}
