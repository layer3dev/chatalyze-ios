//
//  MenuController.swift
//  Chatalyze
//
//  Created by Mansa on 21/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class MenuController: InterfaceExtendedController {
        
    @IBOutlet var userImage:UIImageView?
    @IBOutlet var userName:UILabel?
    var selectedSlideBarTab:((MenuRootView.MenuType?)->())?
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialize()
        paintInterface()
    }
    
    func paintInterface(){
        
        self.userImage?.layer.cornerRadius = ((self.userImage?.frame.size.width ?? 0.0) / 2.0)
        self.userImage?.layer.masksToBounds = true
        self.userImage?.clipsToBounds = true
    }
    
    private func initialize(){
        
        rootView?.selectedSlideBarTab = self.selectedSlideBarTab
        guard let useInfo = SignedUserInfo.sharedInstance else{
            return
        }
        userName?.text = useInfo.fullName.uppercased()
        if let imageStr = useInfo.profileImage{
            if let url = URL(string: imageStr){
                userImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
                    self.userImage?.image = image
                })
            }
        }
    }
    
    func updateMenuInfo(){
        
        initialize()
    }
    
    @IBAction func signOut(){
                
        RootControllerManager().signOut(completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var rootView:MenuRootView?{
        return self.view as? MenuRootView
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

extension MenuController{
    
    class func instance()->MenuController?{
        
        let storyboard = UIStoryboard(name: "Container", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Menu") as? MenuController
        return controller
    }
}

