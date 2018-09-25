//
//  ContainerController.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 29/04/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit


class ContainerController: NavChildController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let didLoaded = self.didLoad{
            didLoaded()
        }
        initialization()
        initializeToggleWidth()
    }
    
    func initializeToggleWidth(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            toggleWidth = 420.0
        }else{
            toggleWidth = 256.0
        }
    }
    
    func toggleAnimation(){
        
        Log.echo(key: "yud", text: "Toogle is calling")
        
        if isOpen{
            
            isOpen = false
            UIView.animate(withDuration: 0.7) {
                
                self.toggleTrailing?.constant = -(self.toggleWidth-2)
            }
            self.view.layoutIfNeeded()
            return
        }
        isOpen = true
        UIView.animate(withDuration: 0.7) {
            
            self.toggleTrailing?.constant = 0
        }
        self.view.layoutIfNeeded()
        
    }
    
    func closeToggle(){
        
        isOpen = false
        UIView.animate(withDuration: 0.7) {
            
            self.toggleTrailing?.constant = -(self.toggleWidth-2)
        }
        self.view.layoutIfNeeded()
        return
    }
    
    func openToggle(){
       
        isOpen = true
        UIView.animate(withDuration: 0.7) {
            
            self.toggleTrailing?.constant = 0
        }
        self.view.layoutIfNeeded()
        return
    }
    
    func implementEdgePanGesture(){
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .right
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            print("Screen edge swiped!")
            toggleAnimation()
        }
    }
    
    
    func implementSwipeGesture(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.left
//        self.toggleView?.addGestureRecognizer(swipeLeft)
    }
    
    @objc  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                closeToggle()
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
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
        
        self.toggleTrailing?.constant = -(toggleWidth-2)
        implementSwipeGesture()
        implementEdgePanGesture()
        initializePanGesture()
        tabContainerView?.delegate = self
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
            
//        enum MenuType:Int{
//
//            case mySessionAnalyst = 0
//            case paymentAnalyst = 1
//            case scheduledSessionAnalyst = 2
//            case editProfileAnalyst = 3
//            case contactUs = 4
//            case editProfileUser = 6
//            case paymentUser = 7
//            case none = 5
//        }
            
        else if typeOfAction == .mySessionAnalyst{
            
            guard let rootController = MyScheduledSessionsController.instance() else{
                return
            }
            navController?.setViewControllers([rootController], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .paymentAnalyst{
            
            guard let rootController = MyScheduledSessionsController.instance() else{
                return
            }
            
            guard let controller = PaymentSetupPaypalController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .scheduledSessionAnalyst{
            
            guard let rootController = MyScheduledSessionsController.instance() else{
                return
            }
            
            guard let controller = ScheduleSessionController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .editProfileAnalyst{
            
            guard let rootController = MyScheduledSessionsController.instance() else{
                return
            }
            
            guard let controller = EditProfileHostController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .contactUsUser{
            
            guard let rootController = EventController.instance() else{
                return
            }
            
            guard let controller = ContactUsController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .contactUsAnalyst{
            
            guard let rootController = MyScheduledSessionsController.instance() else{
                return
            }
            
            guard let controller = ContactUsController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .editProfileUser{
            
            guard let rootController = EventController.instance() else{
                return
            }
            
            guard let controller = EditProfileController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .paymentUser{
            
            guard let rootController = EventController.instance() else{
                return
            }
            
            guard let controller = PaymentListingController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .autograph{
            
            guard let rootController = EventController.instance() else{
                return
            }
            
            guard let controller = MemoriesController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .tickets{
            
            guard let rootController = EventController.instance() else{
                return
            }
            
            guard let controller = AccountController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .userAccount{
            
            guard let rootController = EventController.instance() else{
                return
            }
            
            guard let controller = AccountController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
        else if typeOfAction == .analystAccount{
            
            guard let rootController = MyScheduledSessionsController.instance() else{
                return
            }
            
            guard let controller = AccountHostController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            //navController?.viewControllers = [controller]
            return
        }
    }
    
    
    func setActionPending(isPending : Bool, type : TabContainerView.tabType){
        
        tabContainerView?.setActionPending(isPending: isPending, type: type)
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        if let selected = tabController {
            return selected.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }
    
    open override var shouldAutorotate: Bool {
        
        if let selected = tabController {
            return selected.shouldAutorotate
        }
        return super.shouldAutorotate
    }
    
    
    func selectTab(type : TabContainerView.tabType){
        
        tabContainerView?.selectTab(type : type)
        elementSelected(type: type)
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
        
        tabContainerView?.selectTab(type : TabContainerView.tabType.account)
        tabController?.popToRootView(type :selectedTab)
        selectedTab = TabContainerView.tabType.account
        tabController?.selectedIndex = TabContainerView.tabType.account.rawValue
        
        //Above code is responsible for the changing the tabs
        //Below code is responsible for changing the controller to the tickets Controller
        
        if let accountControllerNav = tabController?.selectedViewController as? ExtendedNavigationController {
            
            accountControllerNav.popToRootViewController(animated: true)
            if let accountController = accountControllerNav.topViewController as? AccountController{
                accountController.ticketAction()
            }
        }
    }
    
    func setAccountTabwithMySessionScreen(){
        
        tabContainerView?.selectTab(type : TabContainerView.tabType.account)
        tabController?.popToRootView(type :selectedTab)
        selectedTab = TabContainerView.tabType.account
        tabController?.selectedIndex = TabContainerView.tabType.account.rawValue
        
        //Above code is responsible for the changing the tabs.
        //Below code is responsible for changing the controller to the tickets Controller.
        
        if let accountControllerNav = tabController?.selectedViewController as? ExtendedNavigationController {
            
            accountControllerNav.popToRootViewController(animated: true)
            if let accountController = accountControllerNav.topViewController as? AccountHostController{
                accountController.memoryAction()
                if let pageController = accountController.pageViewHostController {
                    if pageController.pagesHost.count >= 2 {
                        if let settingController = pageController.pagesHost[1] as? SettingController {
                            guard let controller = MyScheduledSessionsController.instance() else{
                                return
                            }
                            settingController.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
            }
        }
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
/*

class ContainerController: TabChildLoadController {
    
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
    @IBOutlet var toggleLeading:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let didLoaded = self.didLoad{
            didLoaded()
        }
        initialization()
    }
    
     func toggleAnimation(){
       
        Log.echo(key: "yud", text: "Toogle is calling")
        
        if isOpen{
            
            isOpen = false
            UIView.animate(withDuration: 0.7) {
                
                self.toggleLeading?.constant = (self.view.frame.size.width)
            }
            self.view.layoutIfNeeded()
            return
        }
        isOpen = true
        UIView.animate(withDuration: 0.7) {
            
            self.toggleLeading?.constant = 0
        }
        self.view.layoutIfNeeded()

    }
    
    func closeToggle(){
     
        isOpen = false
        UIView.animate(withDuration: 0.7) {
            
            self.toggleLeading?.constant = (self.view.frame.size.width)
        }
        self.view.layoutIfNeeded()
        return
    }
    
    func implementPanGesture(){
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .right
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            print("Screen edge swiped!")
            toggleAnimation()
        }
    }
    
    
    func implementSwipeGesture(){
       
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.toggleView?.addGestureRecognizer(swipeRight)
    }
    
   @objc  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                closeToggle()
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
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
        
        self.toggleLeading?.constant = (self.view.frame.size.width)
        implementSwipeGesture()
        implementPanGesture()
        tabContainerView?.delegate = self
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
            return
        }
        
        if segueIdentifier == MENUBAR_SEGUE{
            menuController = segue.destination as? MenuController
            menuController?.selectedSlideBarTab = { (selecetdMenuType) in
                
                if selecetdMenuType == MenuRootView.MenuType.contactUs {
                    Log.echo(key: "yud", text: "Contact us is calling")
                }
            }
            return
        }
        
        if segueIdentifier == NAVIGATION_SEGUE{
            navController = segue.destination as? ContainerNavigationController
            return
        }
    }
    
    func setActionPending(isPending : Bool, type : TabContainerView.tabType){
        
        tabContainerView?.setActionPending(isPending: isPending, type: type)
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        if let selected = tabController {
            return selected.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }
    
    open override var shouldAutorotate: Bool {
        
        if let selected = tabController {
            return selected.shouldAutorotate
        }
        return super.shouldAutorotate
    }
    
    
    func selectTab(type : TabContainerView.tabType){
        
        tabContainerView?.selectTab(type : type)
        elementSelected(type: type)
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
        
        tabContainerView?.selectTab(type : TabContainerView.tabType.account)
        tabController?.popToRootView(type :selectedTab)
        selectedTab = TabContainerView.tabType.account
        tabController?.selectedIndex = TabContainerView.tabType.account.rawValue

        //Above code is responsible for the changing the tabs
        //Below code is responsible for changing the controller to the tickets Controller
        
        if let accountControllerNav = tabController?.selectedViewController as? ExtendedNavigationController {
            
            accountControllerNav.popToRootViewController(animated: true)
            if let accountController = accountControllerNav.topViewController as? AccountController{
                accountController.ticketAction()
            }
        }
    }
    
    func setAccountTabwithMySessionScreen(){
        
        tabContainerView?.selectTab(type : TabContainerView.tabType.account)
        tabController?.popToRootView(type :selectedTab)
        selectedTab = TabContainerView.tabType.account
        tabController?.selectedIndex = TabContainerView.tabType.account.rawValue

        //Above code is responsible for the changing the tabs
        //Below code is responsible foe changing the controller to the tickets Controller
        
        if let accountControllerNav = tabController?.selectedViewController as? ExtendedNavigationController {
            accountControllerNav.popToRootViewController(animated: true)
            
            if let accountController = accountControllerNav.topViewController as? AccountHostController{
                accountController.memoryAction()
                if let pageController = accountController.pageViewHostController {
                    if pageController.pagesHost.count >= 2 {
                       
                        if let settingController = pageController.pagesHost[1] as? SettingController {
                         
                            guard let controller = MyScheduledSessionsController.instance() else{
                                return
                            }
                            settingController.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
            }
        }
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
*/


extension ContainerController{
    
    func initializePanGesture(){
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
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
                return
            }
            rview.center.x = rview.center.x + recognizer.translation(in: view).x
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
        if state == .ended{
            
            Log.echo(key: "yud", text: "ended\(rview.center.x) and the view width is \(self.view.frame.size.width) toggle width is \(self.toggleView?.frame.size.width) and the toggleTrailing is \(toggleTrailing?.constant)")
            
            if rview.center.x > (self.view.frame.size.width){
               
                rview.center.x = ((self.view.frame.size.width+(toggleWidth/2))-2)
                recognizer.setTranslation(CGPoint.zero, in: view)
                //closeToggle()
            }else{
                rview.center.x = (self.view.frame.size.width-toggleWidth/2)
                recognizer.setTranslation(CGPoint.zero, in: view)
                //openToggle()
            }
        }
    }
}
