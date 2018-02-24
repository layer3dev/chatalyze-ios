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
        
        //:todo
        /*self.notificationBar?.count = SignedUserInfo.sharedInstance?.notificationCount ?? 0*/
    }    
    
    
    func paintNavigationLogo(){
        //
        let image = UIImage(named: "login_screen_logo")
        let frame = CGRect(x: 0 , y: 0, width: 194, height: 41)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        imageView.addHeightConstraint(height: 41)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .horizontal)
        
        self.navigationItem.titleView = imageView
    }
    
    
    func paintNavigationTitle(){
        /*
         UILabel *titleLabel= [UILabel new];
         titleLabel.backgroundColor = [UIColor clearColor];
         titleLabel.font = [UIFont fontWithName:Font_regular size:16];
         titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
         titleLabel.textAlignment = NSTextAlignmentCenter;
         titleLabel.textColor = [UIColor whiteColor];
         titleLabel.text=pageTitle;
         [titleLabel sizeToFit];
         [[self navigationItem] setTitleView:titleLabel];
         */
        
        /*let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = AppInfoConfig
        
        if let font = UIFont(name: "HelveticaNeue", size:16){
            mutableInfo.addAttribute(NSFontAttributeName, value: font , range: range)
        }
        
        self.navigationItem.titleView = titleLabel*/
    }
    
    //:todo
    /*
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
    }*/
    
    func paintBackButton(){
        
        let backBar = BackBar()
        backBar.delegate = self
        backBar.translatesAutoresizingMaskIntoConstraints = false
        let barItem = UIBarButtonItem(customView: backBar)
        var items = self.navigationItem.leftBarButtonItems ?? [UIBarButtonItem]();
        items.append(barItem)
        self.navigationItem.leftBarButtonItems = items
    }

    

    
    func emptyNavButtons(){
        self.navigationItem.leftBarButtonItems?.removeAll()
        self.navigationItem.rightBarButtonItems?.removeAll()
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

