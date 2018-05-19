//
//  MyTicketsController.swift
//  Chatalyze
//
//  Created by Mansa on 18/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

protocol getTicketsScrollInsets {
    
    func getTicketsScrollInset(scrollView:UIScrollView)
}

import UIKit

class MyTicketsController: InterfaceExtendedController {
    
    @IBOutlet var scroll:UIScrollView?
    var delegate:getTicketsScrollInsets?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        scroll?.delegate = self
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


extension MyTicketsController{
    
    class func instance()->MyTicketsController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyTickets") as? MyTicketsController
        return controller
    }
}

extension MyTicketsController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.getTicketsScrollInset(scrollView: scrollView)
        Log.echo(key: "yud", text: "scroll content odffset y is \(String(describing: scroll?.contentOffset.y))")
    }
}


