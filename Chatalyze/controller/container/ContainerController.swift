//
//  ContainerController.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 29/04/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit


class ContainerController: TabChildLoadController {
    
    var tabController : TabContainerController?
    @IBOutlet fileprivate var tabContainerView : TabContainerView?
    static var initialTab : TabContainerView.tabType =  TabContainerView.tabType.event
    var initialTabInstance : TabContainerView.tabType =  TabContainerView.tabType.event
    var selectedTab:TabContainerView.tabType =  TabContainerView.tabType.event
    private let CONTAINER_SEGUE = "CONTAINER_SEGUE"
    
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
        initializeVariable()
    }
    
    override func viewGotLoaded(){
        super.viewGotLoaded()
        
        initialTabInstance = ContainerController.initialTab
        tabController?.initialTab = initialTabInstance
        selectTab(type: initialTabInstance)
    }
    
    override func viewLayoutCompleted(){
        super.viewLayoutCompleted()
        
        selectTab(type: initialTabInstance)
    }
    
    private func initializeVariable(){
        tabContainerView?.delegate = self
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueIdentifier = segue.identifier ?? ""
        if(segueIdentifier != CONTAINER_SEGUE){
            return
        }
        
        tabController = segue.destination as? TabContainerController
        initialTabInstance = ContainerController.initialTab
        tabController?.initialTab = initialTabInstance
        if(ContainerController.initialTab != .event){
            //ContainerController.initialTab = .profile
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
        tabController?.selectedIndex = type.rawValue
        selectedTab = type
    }
    
    class func instance()->ContainerController?{
        
        let storyboard = UIStoryboard(name: "container", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ContainerController") as? ContainerController
        return controller
    }
}

