


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
        fetchInfo()
    }

    var rootView : HomeRootView?{
        get{
            return self.view as?HomeRootView
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialization(){
        initializeInterface()
    }
    
    private func initializeInterface(){
        paintNavigationBar()
        edgesForExtendedLayout = UIRectEdge()
    }
    
    
    private func paintNavigationBar(){
        paintNavigationTitle(text : "Home")
        paintLogoutButton()
    }

    private func fetchInfo(){
        self.showLoader()
        CallBookingsFetch().fetchInfo { (success, response) in
            self.stopLoader()
        self.rootView?.jointContainerView?.countdownView?.udpateTimer(eventInfo: response)
        }
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
    
    class func instance()->HomeController?{
        
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "home") as? HomeController
        return controller
    }
}
