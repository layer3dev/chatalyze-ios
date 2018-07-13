//
//  SettingControllerViewController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


protocol getSettingScrollInstet {
    
  func getSettingScrollInset(scrollView:UIScrollView)
}

import UIKit
import FacebookShare
import FBSDKShareKit
import SDWebImage
import TwitterKit
import TwitterShareExtensionUI
import TwitterCore

class SettingController : InterfaceExtendedController {
    
    @IBOutlet var scroll:UIScrollView?
    var delegate:getSettingScrollInstet?
    
    @IBAction private func signoutAction(){
        
        RootControllerManager().signOut(completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    private func initialization(){
       
        initializeInterface()
        initializeVariable()
    }
    
    private func initializeVariable(){
        
        self.scroll?.delegate = self
        self.scroll?.alwaysBounceVertical = false
        self.scroll?.bounces = false
    }
    
    private func initializeInterface(){
        
        paintNavigationBar()
        //edgesForExtendedLayout = UIRectEdge()
    }
    
    private func paintNavigationBar(){
        
        paintNavigationTitle(text : "Settings")
        paintSettingButton()
        paintBackButton()
    }
    
    @IBAction func settingAction(sender:UIButton){
                
        guard let controller = EditProfileController.instance() else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func paymentListingAction(sender:UIButton){
        
        guard let controller = PaymentSuccessController.instance() else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
        
        
      //  guard let controller = PaymentListingController.instance() else {
      //      return
        //}
        //self.navigationController?.pushViewController(controller, animated: true)
        
//        guard let controller = MyTicketsController.instance() else {
//            return
//        }
//        self.navigationController?.pushViewController(controller, animated: true)
        
//        guard let controller = ReviewController.instance() else {
//            return
//        }
//        self.navigationController?.pushViewController(controller, animated: true)
        
        
       // guard let controller = PaymentSuccessController.instance() else {
         //   return
//        }
  //      self.navigationController?.pushViewController(controller, animated: true)
        
        
//        guard let controller = SystemTestController.instance() else {
//            return
//        }
//        controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
//        self.present(controller, animated: true) {
//        }
        
    }
    
    @IBAction func aboutAction(sender:UIButton){
        
//        guard let controller = PaymentSuccessController.instance() else {
//
//            return
//        }
//
//        self.navigationController?.pushViewController(controller, animated: true)
        
        
//        guard let controller = ReviewController.instance() else {
//            return
//        }
//        self.navigationController?.present(controller, animated: true, completion: {
//            
//        })
        
//        guard let controller = HomeController.dynamicInstance()
//            else{
//                return
//        }
//        
//        self.navigationController?.present(controller, animated: true, completion: {
//            
//        })
//        let twitter = TWTRComposer()
//        //twitter.setURL(URL(string: "https://dev.chatalyze.com/"))
//        twitter.show(from: self) { (result) in
//            print("result is \(result)")
//        }
        
//        if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
//            // App must have at least one logged-in user to compose a Tweet
//            let composer = TWTRComposerViewController.emptyComposer()
//            present(composer, animated: true, completion: nil)
//        } else {
//            // Log in, and then check again
//            TWTRTwitter.sharedInstance().logIn { session, error in
//
//                if session != nil { // Log in succeeded
//                    let composer = TWTRComposerViewController.emptyComposer()
//                    self.present(composer, animated: true, completion: nil)
//                } else {
//                    let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
//                    self.present(alert, animated: false, completion: nil)
//                }
//            }
//        }
    }
}

extension SettingController{
    
    class func instance()->SettingController?{
        
        let storyboard = UIStoryboard(name: "setting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "setting") as? SettingController
        return controller
    }
}

extension SettingController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        delegate?.getSettingScrollInset(scrollView: scrollView)
        
        if ((scroll?.contentOffset.y ?? 0.0) >= (scroll?.contentSize.height ?? 0.0) - (scroll?.frame.size.height ?? 0.0)) {
            
            scroll?.setContentOffset(CGPoint(x: (scroll?.contentOffset.x ?? 0.0), y: (scroll?.contentSize.height ?? 0.0) - (scroll?.frame.size.height ?? 0.0)), animated: true)
        }
    }
}

