//
//  ContainerController.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 29/04/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit


class ContainerController: NavChildController {
    
    var edgeGesture = UIScreenEdgePanGestureRecognizer()
    var panGestureRecognizer = UIPanGestureRecognizer()
    var tapGestureForToggle = UITapGestureRecognizer()
    @IBOutlet var socketVerifierView:UIView?
    var tabController : TabContainerController?
    var menuController:MenuController?
    var navController:ContainerNavigationController?
    @IBOutlet fileprivate var tabContainerView : TabContainerView?
    static var initialTab : TabContainerView.tabType =  TabContainerView.tabType.event
    var initialTabInstance : TabContainerView.tabType =  TabContainerView.tabType.event
    var selectedTab:TabContainerView.tabType =  TabContainerView.tabType.event
    private let CONTAINER_SEGUE = "CONTAINER_SEGUE"
    private let MENUBAR_SEGUE = "MENUBAR_SEGUE"
    private let NAVIGATION_SEGUE = "navigation_Segue"
    var didLoad:(()->())?
    var isOpen = false
    @IBOutlet var toggleView:UIView?
    @IBOutlet var toggleTrailing:NSLayoutConstraint?
    var toggleWidth:CGFloat = 0.0
    @IBOutlet var shadowView:UIView?
    
    @IBOutlet var updateAlertView:UIView?
    @IBOutlet var deprecationAlertView:UIView?
    @IBOutlet var obsoleteAlertView:UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let didLoaded = self.didLoad{
            didLoaded()
        }
        initialization()
        initializeToggleWidth()
        hideSocketVerifierOnAdhoc()
    }
    
    
    
    
    
    func hideSocketVerifierOnAdhoc(){
        
        if ProvisiningProfileStatus.isDevelopmentProvisioningProfile(){
            socketVerifierView?.isHidden = false
            return
        }
        socketVerifierView?.isHidden = true
        return
    }
    
    func showShadowView(){
        
        UIView.animate(withDuration: 0.3) {
            self.shadowView?.alpha = 1
        }
        self.view.layoutIfNeeded()
    }

    func hideShadowView(){
        
        UIView.animate(withDuration: 0.3) {
            self.shadowView?.alpha = 0
        }
        self.view.layoutIfNeeded()
    }
    
    func initializeToggleWidth(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            toggleWidth = 420.0
        }else{
            toggleWidth = 256.0
        }
        //Set the toggle position
        self.toggleTrailing?.constant = -(toggleWidth)
    }
    
    func toggleAnimation(){
        
        Log.echo(key: "yud", text: "Toogle is calling")
        
        if isOpen{
            
            isOpen = false
            UIView.animate(withDuration: 0.35) {
                
                self.toggleTrailing?.constant = -(self.toggleWidth)
                self.hideShadowView()

            }
            self.view.layoutIfNeeded()
            return
        }
        isOpen = true
        UIView.animate(withDuration: 0.35) {
            
            self.toggleTrailing?.constant = 0
            self.showShadowView()

        }
        self.view.layoutIfNeeded()
    }
    
    func closeToggle(){
        
        isOpen = false
        UIView.animate(withDuration: 0.35) {
            
            self.toggleTrailing?.constant = -(self.toggleWidth)
            self.hideShadowView()
        }
        self.view.layoutIfNeeded()
        return
    }
    
    func openToggle(){
       
        isOpen = true
        UIView.animate(withDuration: 0.35) {
            
            self.toggleTrailing?.constant = 0
            self.showShadowView()
        }
        self.view.layoutIfNeeded()
        return
    }
    
    func implementEdgePanGesture(){
        
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgeGesture.edges = .right
        edgeGesture.delegate = self
        self.toggleView?.addGestureRecognizer(edgeGesture)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
     
        if recognizer.state == .recognized {
            
            print("Screen edge swiped!")
            //toggleAnimation()
        }
        if recognizer.state == .began{
            
            recognizer.view?.center.x = (self.view.frame.size.width+40)
            recognizer.setTranslation(CGPoint.zero, in: view)
            Log.echo(key: "yud", text: "Edge Gesture Begun")
        }
        if recognizer.state == .changed{
            Log.echo(key: "yud", text: "Edge Gesture Changed")
        }
        if recognizer.state == .ended{
            Log.echo(key: "yud", text: "Edge Gesture Ended")
        }
    }
    
    func implementSwipeGestureOnShadow(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.shadowView?.addGestureRecognizer(swipeRight)
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.left
//        self.toggleView?.addGestureRecognizer(swipeLeft)
    }
    
    @objc  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {          
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                closeToggle()
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialization(){
        
        initializeForFirstTab()
        initializeVariable()
    }
    
    func initializeForFirstTab(){
        
        initialTabInstance = ContainerController.initialTab
        tabController?.initialTab = initialTabInstance
        selectTab(type: initialTabInstance)
    }
    
    override func viewGotLoaded(){
        super.viewGotLoaded()
    }
    
    override func viewLayoutCompleted(){
        super.viewLayoutCompleted()
        
        selectTab(type: initialTabInstance)
    }
    
    private func initializeVariable(){
        
        implementSwipeGestureOnShadow()
        implementEdgePanGesture()
        initializePanGesture()
        initializeTapGestureOnShadow()
        tabContainerView?.delegate = self
    }
    
    func initializeTapGestureOnShadow(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOnTap))
        tapGesture.numberOfTapsRequired = 1
        self.shadowView?.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideOnTap(_: UITapGestureRecognizer){
        closeToggle()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueIdentifier = segue.identifier ?? ""
        if(segueIdentifier == CONTAINER_SEGUE){
            
            tabController = segue.destination as? TabContainerController
            initialTabInstance = ContainerController.initialTab
            tabController?.initialTab = initialTabInstance
            if(ContainerController.initialTab != .event){
                //ContainerController.initialTab = .profile
            }
        }
        
        if segueIdentifier == MENUBAR_SEGUE{
            
            menuController = segue.destination as? MenuController
            menuController?.selectedSlideBarTab = { (selecetdMenuType) in
                
                self.tapAction(menuType:selecetdMenuType)
                self.closeToggle()
            }
        }
        
        if segueIdentifier == NAVIGATION_SEGUE{
            navController = segue.destination as? ContainerNavigationController
        }
    }
    
    func tapAction(menuType:MenuRootView.MenuType?){
        
        guard let typeOfAction = menuType else {
            return
        }
        
        if typeOfAction == .none{
            return
        }
        
        else if typeOfAction == .mySessionAnalyst{
            
            guard let rootController = HostDashboardController.instance() else{
                return
            }
            navController?.setViewControllers([rootController], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .paymentAnalyst{
            
            guard let rootController = HostDashboardController.instance() else{
                return
            }
            
            guard let controller = PaymentSetupPaypalController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .scheduledSessionAnalyst{
            
            guard let rootController = HostDashboardController.instance() else{
                return
            }
            
            guard let controller = ScheduleSessionController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .editProfileAnalyst{
            
            guard let rootController = HostDashboardController.instance() else{
                return
            }
            
            guard let controller = EditProfileHostController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .contactUsUser{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            guard let controller = ContactUsController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .contactUsAnalyst{
            
            guard let rootController = HostDashboardController.instance() else{
                return
            }
            
            guard let controller = ContactUsController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .editProfileUser{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            guard let controller = EditProfileController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .paymentUser{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            guard let controller = PaymentListingController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .autograph{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            guard let controller = MemoriesController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .tickets{
            
            //This id the home controller for the user in the User side.            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            navController?.setViewControllers([rootController], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .userAccount{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            guard let controller = EditProfileController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .analystAccount{
            
            guard let rootController = HostDashboardController.instance() else{
                return
            }
            guard let controller = EditProfileHostController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .settings{
            
            guard let roleId = SignedUserInfo.sharedInstance?.role else{
                return
            }
            
            if roleId == .analyst{
                
                guard let rootController = HostDashboardController.instance() else{
                    return
                }
                
                guard let controller = EditProfileHostController.instance() else{
                    return
                }
                
                navController?.setViewControllers([rootController,controller], animated: true)
                
                self.closeToggle()
                
            }else{
               
                guard let rootController = MyTicketsVerticalController.instance() else{
                    return
                }
                
                guard let controller = EditProfileController.instance() else{
                    return
                }
                
                navController?.setViewControllers([rootController,controller], animated: true)
                
                self.closeToggle()
            }
            
            return
            
        }else if typeOfAction == .events{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            guard let controller = EventController.instance() else{
                return
            }
            
            navController?.setViewControllers([rootController,controller], animated: true)
            
            self.closeToggle()
           
            //navController?.viewControllers = [controller]
            return
        }
        
        //        var analystArray = ["My Sessions","Payments","Settings","Support"]
        //        var userArray = ["My Tickets","Memories","Purchase","History", "Settings"]
    }
    
    
    func setActionPending(isPending : Bool, type : TabContainerView.tabType){
        
        tabContainerView?.setActionPending(isPending: isPending, type: type)
    }
    
//    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        
//        if let selected = tabController {
//            return selected.supportedInterfaceOrientations
//        }
//        return super.supportedInterfaceOrientations
//    }
//    
//    open override var shouldAutorotate: Bool {
//        
//        if let selected = tabController {
//            return selected.shouldAutorotate
//        }
//        return super.shouldAutorotate
//    }
    
    
    func selectTab(type : TabContainerView.tabType){
        
        tabContainerView?.selectTab(type : type)
        elementSelected(type: type)
    }
    
    func showFAQController(){
        
        guard let roleId = SignedUserInfo.sharedInstance?.role else{
            return
        }
        
        if roleId == .analyst{
            
            guard let rootController = HostDashboardController.instance() else{
                return
            }
            
            guard let controller = FAQController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            
            self.closeToggle()
            
        }else{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            guard let controller = FAQController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            
            self.closeToggle()
        }
        return
    }
}

extension ContainerController : TabContainerViewInterface{
    
    func elementSelected(type : TabContainerView.tabType){
        
        if selectedTab == type{
            
            tabController?.popToRootView(type :selectedTab)
            selectedTab = type
            return
        }
        Log.echo(key: "yud", text: "the raw value is \(type.rawValue)")
        tabController?.selectedIndex = type.rawValue
        //tabController?.selectedIndex = 2
        Log.echo(key: "yud", text: "index do not set \(type.rawValue)")
        selectedTab = type
    }
    
    func selectAccountTabWithTicketScreen(){
        
        self.tapAction(menuType: MenuRootView.MenuType.tickets)
    }
    
    func setAccountTabwithMySessionScreen(){
      
        tapAction(menuType: MenuRootView.MenuType.analystAccount)
        
//        tabContainerView?.selectTab(type : TabContainerView.tabType.account)
//        tabController?.popToRootView(type :selectedTab)
//        selectedTab = TabContainerView.tabType.account
//        tabController?.selectedIndex = TabContainerView.tabType.account.rawValue
//
//        //Above code is responsible for the changing the tabs.
//        //Below code is responsible for changing the controller to the tickets Controller.
//
//        if let accountControllerNav = tabController?.selectedViewController as? ExtendedNavigationController {
//
//            accountControllerNav.popToRootViewController(animated: true)
//            if let accountController = accountControllerNav.topViewController as? AccountHostController{
//                accountController.memoryAction()
//                if let pageController = accountController.pageViewHostController {
//                    if pageController.pagesHost.count >= 2 {
//                        if let settingController = pageController.pagesHost[1] as? SettingController {
//                            guard let controller = MyScheduledSessionsController.instance() else{
//                                return
//                            }
//                            settingController.navigationController?.pushViewController(controller, animated: true)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func selectEventTabWithSessions(){
        
        tabContainerView?.selectTab(type : TabContainerView.tabType.event)
        tabController?.popToRootView(type :selectedTab)
        selectedTab = TabContainerView.tabType.event
        tabController?.selectedIndex = TabContainerView.tabType.event.rawValue
        
        //Above code is responsible for the changing the tabs
        //Below code is responsible for changing the controller to the tickets Controller
        
        if let eventControllerNav = tabController?.selectedViewController as? ExtendedNavigationController {
            
            eventControllerNav.popToRootViewController(animated: true)
        }
    }
    
    
    class func instance()->ContainerController?{
        
        let storyboard = UIStoryboard(name: "container", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ContainerController") as? ContainerController
        return controller
    }
}


extension ContainerController{
    
    func initializePanGesture(){
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        self.toggleView?.addGestureRecognizer(panGestureRecognizer)
    }
   
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        let gestureIsDraggingFromRightToLeft = (recognizer.velocity(in: view).x < 0)
        
        guard let rview = recognizer.view else{
            return
        }
        
        Log.echo(key: "yud", text: "PanGesture is calling\(recognizer.translation(in: view).x)")
        
        let state = recognizer.state
        if state == .began {
            
            if gestureIsDraggingFromRightToLeft{
                //openToggle()
            }
            Log.echo(key: "yud", text: "just begun")
        }
        if state == .changed{
            
            Log.echo(key: "yud", text: "change\(rview.center.x) and the view width is \(self.view.frame.size.width) toggle width is \(self.toggleView?.frame.size.width) and the toggleTrailing is \(toggleTrailing?.constant) and the test is \((self.view.frame.size.width-toggleWidth/2))")
            
            if rview.center.x + recognizer.translation(in: view).x < (self.view.frame.size.width-toggleWidth/2){
                
                UIView.animate(withDuration: 0.35) {
                    self.toggleTrailing?.constant = 0.0
                    self.showShadowView()
                }
                return
            }
            rview.center.x = rview.center.x + recognizer.translation(in: view).x
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
        if state == .ended{
            
            Log.echo(key: "yud", text: "ended\(rview.center.x) and the view width is \(self.view.frame.size.width) toggle width is \(self.toggleView?.frame.size.width) and the toggleTrailing is \(toggleTrailing?.constant)")
            
            if rview.center.x > (self.view.frame.size.width){
                
                rview.center.x = ((self.view.frame.size.width+(toggleWidth/2)-5))
                recognizer.setTranslation(CGPoint.zero, in: view)
                UIView.animate(withDuration: 0.35) {
                    self.hideShadowView()
                    self.toggleTrailing?.constant = -(self.toggleWidth)
                }
                //closeToggle()
            }else{
                
                rview.center.x = (self.view.frame.size.width-toggleWidth/2)
                recognizer.setTranslation(CGPoint.zero, in: view)
                UIView.animate(withDuration: 0.35) {
                    self.toggleTrailing?.constant = 0.0
                    self.showShadowView()
                }
                //openToggle()
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.panGestureRecognizer || gestureRecognizer == edgeGesture{
            return true
        }
        return false
    }
}


//MARK:- Support for update alert , depercation support , obsolete version support

extension ContainerController{
    
    func hideAllAlert(){
        
        updateAlertView?.alpha = 0
        deprecationAlertView?.alpha = 0
        obsoleteAlertView?.alpha = 0
    }
    
    func showUpdateAlert(){
        
        UIView.animate(withDuration: 0.25) {
            
            self.updateAlertView?.alpha = 1
            self.deprecationAlertView?.alpha = 0
            self.obsoleteAlertView?.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func showDeprecationAlert() {
       
        UIView.animate(withDuration: 0.25) {
            
            self.updateAlertView?.alpha = 0
            self.deprecationAlertView?.alpha = 1
            self.obsoleteAlertView?.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func showObsoleteAlert(){
       
        UIView.animate(withDuration: 0.25) {
            
            self.updateAlertView?.alpha = 0
            self.deprecationAlertView?.alpha = 0
            self.obsoleteAlertView?.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func checkForSupport(){
    }
    
}

