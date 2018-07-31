//
//  InterfaceExtendedController.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 27/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class InterfaceExtendedController : ExtendedController {
    
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
    
    
    func paintNavigationTitle(text : String?){
    
        guard let title = text else {
            return
        }
        self.title = title
        return
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        
        guard let font = UIFont(name: AppThemeConfig.defaultFont, size:16)
            else{
                return
        }
        titleLabel.font = font
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = text
        self.navigationItem.titleView = titleLabel
    }
    
    func paintSettingButton(){
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        imageView.image = UIImage(named : "setting_white")
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
        button.contentVerticalAlignment = .bottom
        button.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
        containerView.addSubview(button)
        
        let barItem = UIBarButtonItem(customView: containerView)
        var items = self.navigationItem.rightBarButtonItems ?? [UIBarButtonItem]();
        items.append(barItem)
        self.navigationItem.rightBarButtonItems = items
    }
    
    
    func paintBackButton(){
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 25, height: 25))
        imageView.image = UIImage(named : "back_white")
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
        button.contentVerticalAlignment = .bottom
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        containerView.addSubview(button)
        
        let barItem = UIBarButtonItem(customView: containerView)
        
        var items = self.navigationItem.rightBarButtonItems ?? [UIBarButtonItem]();
        items.append(barItem)
        self.navigationItem.leftBarButtonItems = items
    }
    
    
    
    @objc func settingAction(){
        guard let controller = SettingController.instance()
            else{
                return
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func emptyNavButtons(){
        self.navigationItem.leftBarButtonItems?.removeAll()
        self.navigationItem.rightBarButtonItems?.removeAll()
    }
}



extension InterfaceExtendedController{
    
    fileprivate func registerForTapGestureForKeyboardResign(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
}


extension InterfaceExtendedController : NVActivityIndicatorViewable{
    
    func showLoader(text : String = "Loading..."){
        let size = CGSize(width: 30, height: 30)
        
        self.startAnimating(size, message: text, type: .lineScale)
        
    }
    
    func updateLoaderMessage(text : String = "Loading..."){
        NVActivityIndicatorPresenter.sharedInstance.setMessage(text)
    }
    
    func stopLoader(){
        self.stopAnimating()
    }
}


