
//
//  RequestAutographController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 05/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class RequestAutographController: InterfaceExtendedController {
    
    var defaultScreenshotInfo : ScreenshotInfo?
    var customScreenshotInfo : ScreenshotInfo?
    
    private var cacheImageLoader = CacheImageLoader.sharedInstance
    
    var completion : ((_ success : Bool, _ info : ScreenshotInfo?, _ isDefault : Bool)->())?
    
    
    
    @IBAction fileprivate func requestDefault(){
        self.completion?(true, defaultScreenshotInfo, true)
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }
    
    
    @IBAction fileprivate func requestCustom(){
        self.completion?(true, customScreenshotInfo, false)
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }
    
    func setListener(listener : ((_ success : Bool, _ info : ScreenshotInfo?, _ isDefault : Bool)->())?){
        self.completion = listener
    }
    
    var rootView : RequestAutographRootView?{
        get{
            return self.view as? RequestAutographRootView
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialization()
    }
    
    private func initialization(){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootView?.defaultScreenshot?.fillInfo(info: defaultScreenshotInfo)
        rootView?.customScreenshot?.fillInfo(info: customScreenshotInfo)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension RequestAutographController {
    
    class func customInstance()->RequestAutographController?{
        
        let storyboard = UIStoryboard(name: "autograph", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "custom_request") as? RequestAutographController
        return controller
    }
    
    class func defaultInstance()->RequestAutographController?{
        
        let storyboard = UIStoryboard(name: "autograph", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "single_request") as? RequestAutographController
        return controller
    }
}
