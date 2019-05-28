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
    private var isViewDidAppear : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Log.echo(key : "rotate", text : "viewDidLoad in InterfaceExtended -> \(self)")
        initialization()
        showNavigationBar()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            if(self.isViewDidAppear){
                return
            }
            self.isViewDidAppear = true
            self.viewAppeared()
        }
        
    }
    
    @objc override func viewDidRelease(){
        super.viewDidRelease()
        
        Log.echo(key : "rotate", text : "viewDidRelease in InterfaceExtended-> \(self)")
        guard let rootView = self.view as? ExtendedRootView
            else{
                return
        }
        rootView.onRelease()
    }
    
    //singular execution of viewDidAppear
    func viewAppeared(){
        
         Log.echo(key : "rotate", text : "viewAppeared in InterfaceExtended-> \(self)")
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
        
        Log.echo(key : "rotate", text : "viewWillAppear in InterfaceExtended -> isViewDidAppear -> \(isViewDidAppear) -> \(self)")
        
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
    
    func hideNavigationBar(){
       
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showNavigationBar(){
        
        self.navigationController?.isNavigationBarHidden = false
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
        

        if SignedUserInfo.sharedInstance?.role  == .analyst{
            imageView.image = UIImage(named : "menuBlack")
        }else{
            imageView.image = UIImage(named : "menuBar")
        }
        
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
        button.contentVerticalAlignment = .bottom
        button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        containerView.addSubview(button)
        
        let barItem = UIBarButtonItem(customView: containerView)
        var items = self.navigationItem.rightBarButtonItems ?? [UIBarButtonItem]();
        items.append(barItem)
        self.navigationItem.rightBarButtonItems = items
    }
    
    @objc func toggle(){
        
        Log.echo(key: "yud", text: "Toogle is calling")
        
//        UserSocket.sharedInstance?.registerSocket()
        RootControllerManager().getCurrentController()?.toggleAnimation()
    }
        
    func paintHideBackButton(){
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.backItem?.hidesBackButton = true
    }
    
    func paintBackButton(){
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 25, height: 25))
        if SignedUserInfo.sharedInstance?.role  == .user{
            imageView.image = UIImage(named : "back_white")
        }else{
            imageView.image = UIImage(named : "back_black")
        }
        
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
        button.contentVerticalAlignment = .bottom
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        containerView.addSubview(button)
        
        let barItem = UIBarButtonItem(customView: containerView)
        
        var items = self.navigationItem.leftBarButtonItems ?? [UIBarButtonItem]();
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


extension InterfaceExtendedController:UIGestureRecognizerDelegate{
    
    fileprivate func registerForTapGestureForKeyboardResign(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return true
//    }
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }
}


extension UIViewController : NVActivityIndicatorViewable{
    
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
    
    func getRootPresentingController()-> UIViewController?{
        
        var presenting : UIViewController? = self.presentingViewController
        while(true){
            if let root = presenting?.presentingViewController{
                presenting = root
            }
            else{
                return presenting
            }
        }
    }
    
    func getTopMostPresentedController()-> UIViewController?{
        
        //If no controller is presented then it will return itself.
        if self.presentedViewController == nil {
            return self
        }
        var presented : UIViewController? = self.presentedViewController
        while(true){
            if let root = presented?.presentedViewController{
                presented = root
            }
            else{
                return presented
            }
        }
    }
}

extension InterfaceExtendedController{
    
    func changeOrientationToPortrait(){
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            
            appDelegate.allowRotate = false
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
}
