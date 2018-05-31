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
        
        guard let controller = PaymentListingController.instance() else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
        
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
        
            do {
//                let imageData = try Data(contentsOf: URL(string: "https://s3-us-west-2.amazonaws.com/chatalyze/defaultimages/1519640038601_.png")!)
//                let image = UIImage(data: imageData)
                let image1 = UIImage(named: "tick")
                print("image is \(image1)")
                let photo = Photo(image: image1!, userGenerated: true)
                var contentImage = PhotoShareContent(photos: [photo])
                //contentImage.referer = "https://dev.chatalyze.com"
                //contentImage.url = URL(string:"https://dev.chatalyze.com")
                let shareDialog = ShareDialog(content: contentImage)
                do  {
                    try ShareDialog.show(from: self, content: contentImage) { (result) in
                        print("Result is")
                        print(result)
                    }
                } catch{
                }
            } catch {
                print("Unable to load data: \(error)")
            }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        delegate?.getSettingScrollInset(scrollView: scrollView)
        
        if ((scroll?.contentOffset.y ?? 0.0) >= (scroll?.contentSize.height ?? 0.0) - (scroll?.frame.size.height ?? 0.0)) {

            scroll?.setContentOffset(CGPoint(x: (scroll?.contentOffset.x ?? 0.0), y: (scroll?.contentSize.height ?? 0.0) - (scroll?.frame.size.height ?? 0.0)), animated: true)
        }
    }
}

