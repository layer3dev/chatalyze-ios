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
    
    @IBOutlet var heightOfTestIPhonePriority:NSLayoutConstraint?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialize()
        paintInterface()
        setVisibilityOfTestMyIPhone()
    }
    
    func setVisibilityOfTestMyIPhone(){
        
        guard let roleId = SignedUserInfo.sharedInstance?.role else{
            return
        }
        
        if roleId == .analyst{
            
            heightOfTestIPhonePriority?.priority = UILayoutPriority(rawValue: 250.0)
            return
        }
        
        heightOfTestIPhonePriority?.priority = UILayoutPriority(rawValue: 999.0)
        return
    }
    
    
    func paintInterface(){
        
//        self.userImage?.layer.cornerRadius = ((self.userImage?.frame.size.width ?? 0.0) / 2.0)
//        self.userImage?.layer.masksToBounds = true
//        self.userImage?.clipsToBounds = true
    }
    
    @IBAction func testMyAction(sender:UIButton){
        
        self.selectedSlideBarTab?(MenuRootView.MenuType.test)
    }
    
    
    private func initialize(){
        
        rootView?.selectedSlideBarTab = self.selectedSlideBarTab
        guard let useInfo = SignedUserInfo.sharedInstance else{
            return
        }
        userName?.text = useInfo.fullName
        userImage?.image = UIImage(named: "orangePup")
        if let imageStr = useInfo.profileImage{
            if let url = URL(string: imageStr){
                userImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "orangePup"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
                    if error != nil{
                        self.userImage?.image = UIImage(named: "orangePup")
                        return
                    }
                    self.userImage?.image = image
                })
            }
        }
    }
    
    func updateMenuInfo(){
        
        initialize()
    }
    
    @IBAction func signOut(){
        self.showLoader()
        
        SignOutManager().signOut { (success) in
            self.stopLoader()
            /*if !success{
                return
            }*/
            RootControllerManager().signOut(completion: nil)
        }
    }
    
    @IBAction func accountAction(sender:UIButton){
        
        if let selecetTabAction = selectedSlideBarTab{
            
            guard let role = SignedUserInfo.sharedInstance?.role
                else{
                    return
            }
            if(role == .analyst){
                selecetTabAction(MenuRootView.MenuType.analystAccount)
                return
            }else{
                selecetTabAction(MenuRootView.MenuType.userAccount)
                return
            }
        }
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

