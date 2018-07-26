//
//  AccountPageViewHostController.swift
//  Chatalyze
//
//  Created by Mansa on 26/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AccountPageViewHostController: AcccountPageViewController {

    lazy var pagesHost: [UIViewController] = ({
        return [
            sessionController,
            settingController
        ]
        }() as! [UIViewController])
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //initializeVariable()
    }

    override func setFirstController(){
        
        if let firstVC = pagesHost.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
   override func setSettingTab(){
        
        setViewControllers([pages[2]], direction: .forward, animated: false, completion: nil)
        accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }
    
    override func setMemoryTab(){
        
        setViewControllers([pagesHost[1]], direction: .forward, animated: false, completion: nil)
        accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }
    
    override func setMyTicketTab(){
        
        setViewControllers([pagesHost[0]], direction: .forward, animated: false, completion: nil)
        accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
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
