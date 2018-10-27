//
//  AccountController.swift
//  Chatalyze
//
//  Created by Mansa on 18/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AccountController: InterfaceExtendedController {
    
    @IBOutlet var rootView:AccountRootView?    
    var pageViewController:AcccountPageViewController?
    var memoryContentOffset:CGFloat = 0.0
    var ticketContentOffset:CGFloat = 0.0
    var settingContentOffset:CGFloat = 0.0
    @IBOutlet var topConstraint:NSLayoutConstraint?
    @IBOutlet var containerTopContraint:NSLayoutConstraint?
    @IBOutlet var containerView:AccountContainerView?
    var pageViewHostController:AccountPageViewHostController?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        initializeVariable()
        paintInterfce()
    }
    
    func paintInterfce(){
        
        paintNavigationTitle(text: "Settings")
        paintBackButton()
        paintSettingButton()
    }
    
    func initializeVariable(){
        
        rootView?.controller = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
        self.containerView?.layoutIfNeeded()
            pageViewController?.ticketController?.rootview?.adapter?.featureHeight = containerView?.bounds.size.height ?? 0.0
        pageViewController?.ticketController?.rootview?.adapter?.initializeCollectionFlowLayout()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let segueIdentifier  = segue.identifier
        if segueIdentifier == "pagination"{
            
            pageViewController = segue.destination as? AcccountPageViewController
            pageViewController?.accountDelegate = self
            pageViewController?.ticketController?.featureHeight = containerView?.bounds.size.height ?? 0.0
        }else if segueIdentifier == "paginationHost"{
            
            pageViewHostController = segue.destination as? AccountPageViewHostController
            pageViewHostController?.accountDelegate = self
            pageViewHostController?.ticketController?.featureHeight = containerView?.bounds.size.height ?? 0.0
        }
    }
    
    class func instance()->AccountController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Account") as? AccountController
        return controller
    }
    
    func settingsAction(){
        
        pageViewController?.setSettingTab()
        rootView?.setTabInterface(controller: SettingController())
    }
    
    func memoryAction(){
        
        pageViewController?.setMemoryTab()
        rootView?.setTabInterface(controller:MemoriesController())
    }
    
    func ticketAction(){
        
        pageViewController?.setMyTicketTab()
        rootView?.setTabInterface(controller: MyTicketsVerticalController())
    }
}

extension AccountController{
}


extension AccountController:stateofAccountTabDelegate{
    
    func contentOffsetForMemory(offset: CGFloat?) {
        
        guard let offset = offset else {
            return
        }
        settingContentOffset = offset
        setOffset()
    }
    
    func contentOffsetForTickets(scrollView: UIScrollView) {
        
        ticketContentOffset = scrollView.contentOffset.y
    }
    
    func contentOffsetForSeetings(scrollView: UIScrollView) {
        
        settingContentOffset = scrollView.contentOffset.y
        setOffset()
    }
    
    func currentViewController(currentController: UIViewController?) {
        
        guard let controller = currentController else { return  }
        rootView?.setTabInterface(controller:controller)
        //resetOffset()
    }
    
    func  resetOffset(){
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.topConstraint?.constant = 0.0
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func setOffset(){
        
        if settingContentOffset >= 0.0 && settingContentOffset <= 65.0 {
            UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.topConstraint?.constant = -(self.settingContentOffset)
                self.containerTopContraint?.constant = 155.0 - (self.settingContentOffset)
                
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }else if settingContentOffset > 65.0{
            UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.topConstraint?.constant = -65.0
                self.containerTopContraint?.constant = 90
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }else if settingContentOffset < 0.0{
            UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.topConstraint?.constant = 0.0
                self.containerTopContraint?.constant = 155.0
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
    }
}

extension AccountController{
}
