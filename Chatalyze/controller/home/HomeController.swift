//
//  HomeController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 22/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HomeController: InterfaceExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchInfo(showLoader: true)
    }
    
    func fetchInfo(showLoader : Bool){
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialization(){
        initializeInterface()
        initializeListener()
    }
    
    private func initializeInterface(){
        paintNavigationBar()
        edgesForExtendedLayout = UIRectEdge()
    }
    
    var rootView : HomeRootView?{
        get{
            return self.view as?HomeRootView
        }
    }
    
    func initializeListener(){
        rootView?.queueContainerView?.delegate = self
    }
    
    
    private func paintNavigationBar(){
        paintNavigationTitle(text : "Home")
        paintSettingButton()
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HomeController{
    
    class func dynamicInstance()->HomeController?{
        
        guard let userInfo = SignedUserInfo.sharedInstance
        else{
            return nil
        }
        
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        let controllerId = userInfo.role == .analyst ? "host_home" : "user_home"
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId) as? HomeController
        
        return controller
    }
}

extension HomeController : EventRefreshProtocol{
    func refreshInfo() {
        self.fetchInfo(showLoader: true)
    }
}
