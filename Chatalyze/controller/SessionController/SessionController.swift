//
//  SessionController.swift
//  Chatalyze
//
//  Created by Mansa on 26/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionController: InterfaceExtendedController {

    @IBOutlet var scroll:UIScrollView?
    var delegate:getSettingScrollInstet?
    @IBOutlet var containerView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //embedHostHomeController()
    }

    func embedHostHomeController(){
       
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "host_home") as? HomeController
        self.containerView?.addSubview((controller?.view)!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as? HostHomeController

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    class func instance()->SessionController?{
        
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionController") as? SessionController
        return controller
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


extension SessionController:UIScrollViewDelegate{
    
     func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        delegate?.getSettingScrollInset(scrollView: scrollView)
        
        if ((scroll?.contentOffset.y ?? 0.0) >= (scroll?.contentSize.height ?? 0.0) - (scroll?.frame.size.height ?? 0.0)) {
            
            scroll?.setContentOffset(CGPoint(x: (scroll?.contentOffset.x ?? 0.0), y: (scroll?.contentSize.height ?? 0.0) - (scroll?.frame.size.height ?? 0.0)), animated: true)
        }
    }
}

