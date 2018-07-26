//
//  TabContainerController.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 29/04/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit

class TabContainerController: UITabBarController {
    
    var initialTab : TabContainerView.tabType =  TabContainerView.tabType.event
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialization(){
        initializeRootController()
    }
    
    
    private func initializeRootController(){
        
        guard let greetingController = GreetingController.instance()
            else{
                return
        }
        
        let greetingNav : UINavigationController = ExtendedNavigationController()
        greetingNav.viewControllers = [greetingController]
        
        guard let eventController = EventController.instance()            else{
                return
        }
        
        let eventNav : UINavigationController = ExtendedNavigationController()
        
        eventNav.viewControllers = [eventController]
        
        guard let accountController = AccountController.instance()
            else{
               return
        }
        
        let accountNav : UINavigationController = ExtendedNavigationController()
        accountNav.viewControllers = [accountController]
   
        //----
        
        guard let accountHostController = AccountHostController.instance()
            else{
                return
        }
        
        let accountHostNav : UINavigationController = ExtendedNavigationController()        
        accountHostNav.viewControllers = [accountHostController]
        if let role = SignedUserInfo.sharedInstance?.role{
            if role == .analyst  {
                self.viewControllers = [eventNav, greetingNav , accountHostNav]
            }else{
                self.viewControllers = [eventNav, greetingNav , accountNav]
            }
        }else{
            self.viewControllers = [eventNav, greetingNav , accountNav]
        }
        self.viewControllers?.forEach { _ = $0.view }
        selectedIndex = initialTab.rawValue
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let selected = selectedViewController {
            return selected.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }
    
    open override var shouldAutorotate: Bool {
        if let selected = selectedViewController {
            return selected.shouldAutorotate
        }
        return super.shouldAutorotate
    }
    
    func setActionPending(isPending : Bool, type : TabContainerView.tabType){
        
        let containerController = self.parent as? ContainerController
        containerController?.setActionPending(isPending: isPending, type: type)
    }
    func popToRootView(type : TabContainerView.tabType){
        guard let navigationArray = self.viewControllers else {
            return
        }
        
        switch type {
        case  TabContainerView.tabType.event:
            let eventNavigationArray = navigationArray[0] as? UINavigationController
            eventNavigationArray?.popToRootViewController(animated: true)
            return
        case  TabContainerView.tabType.greeting:
            let greetingNav = navigationArray[1] as? UINavigationController
            greetingNav?.popToRootViewController(animated: true)
            return
        case  TabContainerView.tabType.account:
            let accountNav = navigationArray[2] as? UINavigationController
            accountNav?.popToRootViewController(animated: true)
            return
        default:
            return
        }        
    }    
}

