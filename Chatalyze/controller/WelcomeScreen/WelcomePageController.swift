//
//  WelcomePageController.swift
//  Chatalyze
//
//  Created by Mansa on 19/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class WelcomePageController: UIPageViewController {

    let signinController = SigninController.instance()
    let signUpController = SignUpController.instance()
    
    lazy var pages: [UIViewController] = ({
        return [
            signinController,
            signUpController
        ]
        }() as! [UIViewController])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeVariable()
        setFirstController()
    }
    
    func initializeVariable(){
    }
    
    private func setFirstController(){
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setSignInTab(){
        
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
    
    func setSignUpTab(){
        
        setViewControllers([pages[1]], direction: .forward, animated: false, completion: nil)
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
