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
    
//    func askForStarterPlanIfNotAskedYet(){
//
//        guard let userType = SignedUserInfo.sharedInstance?.role else{
//            return
//        }
//
//        if userType == .user{
//            return
//        }
//
//        guard let shouldAskForPlan = SignedUserInfo.sharedInstance?.shouldAskForPlan else{
//            return
//        }
//
//        Log.echo(key: "container", text: "Should I ask for plan \(shouldAskForPlan)")
//
//        if !shouldAskForPlan {
//            return
//        }
//
//        guard let controller = ProFeatureEndTrialController.instance() else{
//            return
//        }
//
//        self.getTopMostPresentedController()?.present(controller, animated: true, completion: {
//        })
//    }

    func fetchProfile(){
        
        FetchProfileProcessor().fetch { (success, message, response) in
            
            //self.menuController?.rootView?.adapter?.reloadDataAfterFetchingData()
           // self.askForStarterPlanIfNotAskedYet()
        }
    }
    
    func toggleAnimation(){
      
        // This method will execute only once if the side bar will open by tapping on the MenuButton.
        
        self.fetchProfile()
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
     
        
        //recognizer.edges
        if recognizer.state == .recognized {
            
            print("Screen edge swiped!")
            //toggleAnimation()
        }
        if recognizer.state == .began{
            
            // This will execute only once as the edge gesture initiaite.
            self.fetchProfile()
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
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewLayoutCompleted(){
        super.viewLayoutCompleted()
        
        selectTab(type: initialTabInstance)
        if let didLoaded = self.didLoad{
            didLoaded()
        }
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
        
        if typeOfAction == .none {
            return
        }
        
        else if typeOfAction == .mySessionAnalyst{
            
            guard let rootController = HostDashboardNewUIController.instance() else{
                return
            }
            guard let firstController = HostDashboardController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,firstController], animated: true)
            self.closeToggle()
            return
        }
        else if typeOfAction == .referAndEarn{
            
            guard let rootController = HostDashboardNewUIController.instance() else{
                return
            }
            guard let controller = ReferralController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            return
        }
            
            
        else if typeOfAction == .paymentAnalyst{
            
            guard let rootController = HostDashboardNewUIController.instance() else{
                return
            }
            
            guard let controller = PaymentSetupPaypalController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            return
        }
            
        else if typeOfAction == .scheduledSessionAnalyst{
            
            guard let rootController = HostDashboardNewUIController.instance() else{
                return
            }
            guard let controller = ScheduleSessionSinglePageController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            return
        }
            
        else if typeOfAction == .editProfileAnalyst{
            
            guard let rootController = HostDashboardNewUIController.instance() else{
                return
            }
            
            guard let controller = EditProfileHostController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
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
            return
        }
            
        else if typeOfAction == .contactUsAnalyst{
            
            guard let rootController = HostDashboardNewUIController.instance() else{
                return
            }
            
            guard let controller = ContactUsController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
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
            return
        }
        
        else if typeOfAction == .changeLanguage{
            
//            let alert = UIAlertController(title: AppInfoConfig.appName, message: "Change Language".localized(), preferredStyle: .alert)
//            
//            let enAction = UIAlertAction(title: "English", style: .default) { (action) in
//                UserDefaults.standard.set("en", forKey: LanguageKey)
//                NotificationCenter.default.post(name: AppNotification.changeLanguage, object: nil )
//            }
//            
//            let frAction = UIAlertAction(title: "French", style: .default) { (action) in
//                UserDefaults.standard.set("fr", forKey: LanguageKey)
//                NotificationCenter.default.post(name: AppNotification.changeLanguage, object: nil )
//            }
//            
//            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
//            
//            alert.addAction(enAction)
//            alert.addAction(frAction)
//            alert.addAction(cancel)
//            
//            RootControllerManager().getCurrentController()?.present(alert, animated: true, completion: nil)
        }
            
        else if typeOfAction == .tickets{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            navController?.setViewControllers([rootController], animated: true)
            
            self.closeToggle()
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
            return
        }
            
        else if typeOfAction == .analystAccount{
            
            guard let rootController = HostDashboardNewUIController.instance() else{
                return
            }
            
            guard let controller = HostDashboardController.instance() else{
                return
            }
            
            navController?.setViewControllers([rootController,controller], animated: true)
            
            self.closeToggle()
            return
        }
            
        else if typeOfAction == .settings{
            
            guard let roleId = SignedUserInfo.sharedInstance?.role else {
                return
            }
            
            if roleId == .analyst {
                
                guard let rootController = HostDashboardNewUIController.instance() else{
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
            return
        }
        else if typeOfAction == .test{
            
            guard let controller = InternetSpeedTestController.instance() else{
                return
            }
            
            controller.onlySystemTest = true
            
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navController?.present(controller, animated: false, completion: {
            })
            return
        }
            
        else if typeOfAction == .proFeature{
            
            self.closeToggle()
            return
        }
        
        else if typeOfAction == .achievements{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            guard let controller = AchievmentsController.instance() else{
                return
            }
            navController?.setViewControllers([rootController,controller], animated: true)
            self.closeToggle()
            return
        }
        
    }
    
    
    func setActionPending(isPending : Bool, type : TabContainerView.tabType){
        
        tabContainerView?.setActionPending(isPending: isPending, type: type)
    }
    
    func selectTab(type : TabContainerView.tabType){
        
        tabContainerView?.selectTab(type : type)
        elementSelected(type: type)
    }
    
    func showFAQController(){
        
        guard let roleId = SignedUserInfo.sharedInstance?.role else{
            return
        }
        
        if roleId == .analyst{
            
            guard let rootController = HostDashboardNewUIController.instance() else{
                return
            }
            guard let controller = FAQWebController.instance() else{
                return
            }
            controller.url = "https://support.chatalyze.com/hc/en-us"
            controller.nameofTitle = "Help Center"
            
            navController?.setViewControllers([rootController,controller], animated: true)
            
            self.closeToggle()
            
        }else{
            
            guard let rootController = MyTicketsVerticalController.instance() else{
                return
            }
            
            guard let controller = FAQWebController.instance() else{
                return
            }
            controller.url = "https://support.chatalyze.com/hc/en-us"
            controller.nameofTitle = "Help Center"
            
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
    
    func showProfileScreen(){
        
        self.tapAction(menuType: MenuRootView.MenuType.settings)
    }
    
    func showContactUs(){
        
        self.tapAction(menuType: MenuRootView.MenuType.contactUsUser)
    }
    
    func showContactUsAnalyst(){
        
        self.tapAction(menuType: MenuRootView.MenuType.contactUsAnalyst)
    }
    
    func setAccountTabwithMySessionScreen(){
      
        tapAction(menuType: MenuRootView.MenuType.analystAccount)
    }
    
    func setScheduleSession(){
        
        tapAction(menuType: MenuRootView.MenuType.scheduledSessionAnalyst)
    }
    
    func setMySessions(){
        
        tapAction(menuType: MenuRootView.MenuType.scheduledSessionAnalyst)
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
            
            Log.echo(key: "yud", text: "change\(rview.center.x) and the view width is \(self.view.frame.size.width) toggle width is \(self.toggleView?.frame.size.width) and the toggleTrailing is \(toggleTrailing?.constant) and the test is \((self.view.frame.size.width-toggleWidth/2))Translation x is \(recognizer.translation(in: view).x)")
            
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


struct AppNotification {
    
    static let  changeLanguage = Notification.Name("changeLanguage")
}
