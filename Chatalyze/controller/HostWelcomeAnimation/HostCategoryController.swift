//
//  HostCategoryController.swift
//  Chatalyze
//
//  Created by mansa infotech on 20/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class HostCategoryController: InterfaceExtendedController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        initilaizeRootView()
        fetchCategoryInfo()
        // Do any additional setup after loading the view.
    }
    
    
    func fetchCategoryInfo(){
        
        self.showLoader()
        FetchHostCategoryProcessor().fetchInfo { (success, listInfo) in
            self.stopLoader()            
            for info in listInfo ?? [HostCategoryListInfo](){
                
                Log.echo(key: "yud", text: "name \(info.name)")
                Log.echo(key: "yud", text: "categoryId \(info.categoryId)")
                Log.echo(key: "yud", text: "id \(info.id)")
                Log.echo(key: "yud", text: "categoryType \(info.categoryType)")
            }
        }
    }
    func initilaizeRootView(){
        
        rootView?.controller = self
        rootView?.fillInfo()
    }
    
    var rootView:HostCategoryRootView?{
        return self.view as? HostCategoryRootView
    }
    
    func nextScreen(){
        
        guard let controller = SetHostProfileController.instance() else {
            return
        }
        self.present(controller, animated: true) {
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */    
    
    class func instance()->HostCategoryController?{

        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HostCategory") as? HostCategoryController
        return controller
    }
}
