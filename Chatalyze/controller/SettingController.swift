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
        
//        guard let controller = PaymentListingController.instance() else {
//            return
//        }
//        self.navigationController?.pushViewController(controller, animated: true)        
        
        guard let controller = MyTicketsController.instance() else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
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
        
        if ((scroll?.contentOffset.y)! >= (scroll?.contentSize.height)! - (scroll?.frame.size.height)!) {

            scroll?.setContentOffset(CGPoint(x: (scroll?.contentOffset.x)!, y: (scroll?.contentSize.height)! - (scroll?.frame.size.height)!), animated: true)
        }
    }
}

