//
//  InterfaceExtendedController.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 27/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit

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


