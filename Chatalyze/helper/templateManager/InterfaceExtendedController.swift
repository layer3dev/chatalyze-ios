//
//  InterfaceExtendedController.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 27/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit

class InterfaceExtendedController : ExtendedController {
    
    var notificationBar : NotificationBar?
    var disableBack : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialization()
    }
    
    private func initialization(){
        registerForTapGestureForKeyboardResign()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.notificationBar?.count = SignedUserInfo.sharedInstance?.notificationCount ?? 0
    }    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func paintNavigationLogo(){
        //
        let image = UIImage(named: "login_screen_logo")
        let frame = CGRect(x: 0 , y: 0, width: 194, height: 41)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
//        imageView.addWidthConstraint(width: 194)
        imageView.addHeightConstraint(height: 41)
        imageView.setContentCompressionResistancePriority(900, for: .horizontal)
        imageView.setContentHuggingPriority(900, for: .horizontal)
        
        self.navigationItem.titleView = imageView
    }
    
    func paintNotificationLogo(){
        return;
        let notificationView = NotificationBar()
        notificationBar = notificationView
        let count = SignedUserInfo.sharedInstance?.notificationCount ?? 0
        Log.echo(key: "notificationCount", text: "count ==> \(count)")
        notificationBar?.count = count
        notificationView.delegate = self
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        let barItem = UIBarButtonItem(customView: notificationView)
        var items = self.navigationItem.rightBarButtonItems ?? [UIBarButtonItem]();
        items.append(barItem)
        self.navigationItem.rightBarButtonItems = items
    }
    
    func paintBackButton(){
        
        let backBar = BackBar()
        backBar.delegate = self
        backBar.translatesAutoresizingMaskIntoConstraints = false
        let barItem = UIBarButtonItem(customView: backBar)
        var items = self.navigationItem.leftBarButtonItems ?? [UIBarButtonItem]();
        items.append(barItem)
        self.navigationItem.leftBarButtonItems = items
    }
//    func paintGrayBackButton(){
//        
//        let backBar = BackBar()
//        backBar.delegate = self
//        backBar.translatesAutoresizingMaskIntoConstraints = false
//        let barItem = UIBarButtonItem(customView: backBar)
//        var items = self.navigationItem.leftBarButtonItems ?? [UIBarButtonItem]();
//        items.append(barItem)
//        self.navigationItem.leftBarButtonItems = items
//    }
    
    func paintUploadButton(){
        return
        let uploadBar = UploadBar()
        uploadBar.delegate = self
        uploadBar.translatesAutoresizingMaskIntoConstraints = false
        let barItem = UIBarButtonItem(customView: uploadBar)
        var items = self.navigationItem.leftBarButtonItems ?? [UIBarButtonItem]();
        items.append(barItem)
        self.navigationItem.leftBarButtonItems = items
        
    }
    
    func emptyNavButtons(){
        self.navigationItem.leftBarButtonItems?.removeAll()
        self.navigationItem.rightBarButtonItems?.removeAll()
    }
    
    /*func paintLogoutButton(){
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        button.contentVerticalAlignment = .bottom
        button.setTitle("Sign Out", for: .normal)
        let color = UIColor(hexString: AppThemeConfig.themeColor)
        button.setTitleColor(color, for: .normal)
        button.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: button)
        var items = self.navigationItem.rightBarButtonItems ?? [UIBarButtonItem]();
        items.append(barItem)
        self.navigationItem.rightBarButtonItems = items
    }*/
    
    
    func paintDismissButton(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissToSelf))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        //self.navigationItem.rightBarButtonItems = items
    }
    
    func dismissToSelf(){
        self.dismiss(animated: true) {
            
        }
    }
    
    
    func paintLogoutButton(){
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.contentVerticalAlignment = .bottom
        button.setImage(UIImage(named: "setting"), for: .normal)
        button.imageView?.image = UIImage(named: "setting")
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: button)
        var items = self.navigationItem.rightBarButtonItems ?? [UIBarButtonItem]();
        items.append(barItem)
        self.navigationItem.rightBarButtonItems = items
    }
    
    @objc private func showActionSheet(){
        
        let actionSheet = UIAlertController.init(title: "Settings", message: nil, preferredStyle: .actionSheet)
        
        let appVersionAction = UIAlertAction.init(title: "App Version \(AppInfoConfig.appversion)", style: UIAlertActionStyle.default, handler: { (action) in
        })
        appVersionAction.setValue(UIColor.lightGray, forKey: "titleTextColor")
        appVersionAction.isEnabled = false
        actionSheet.addAction(appVersionAction)
        
        actionSheet.addAction(UIAlertAction.init(title: "Uploads", style: UIAlertActionStyle.default, handler: { (action) in
            self.uploadBtnTapped()
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Contact Us", style: UIAlertActionStyle.default, handler: { (action) in
            self.contactUs()
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Sign Out", style: UIAlertActionStyle.destructive, handler: { (action) in
            self.signOutTapped()
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        
        //Present the controller
        actionSheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    func contactUs(){
        guard let controller = ContactController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func signOutTapped(){
        RootControllerManager.signOutAction(completion: nil)
    }
}

extension InterfaceExtendedController : NotificationBarInterface{
 
    func notificationTapped() {
        Log.echo(key: "notification", text: "tapped in InterfaceExtendedController" )
        guard let controller = NotificationController.instantiate()
            else{
                return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}
extension InterfaceExtendedController : BackBarInterface{
    func backTapped(){
        if(disableBack){
            return
        }
        let _ = self.navigationController?.popViewController(animated: true)
    }
}

extension InterfaceExtendedController : UploadBarInterface{
    func uploadBtnTapped(){
        guard let controller = UploadManagerController.instantiate()
            else{
                return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension InterfaceExtendedController{
    
    fileprivate func registerForTapGestureForKeyboardResign(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
}

extension UIAlertController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    open override var shouldAutorotate: Bool {
        return false
    }
}

