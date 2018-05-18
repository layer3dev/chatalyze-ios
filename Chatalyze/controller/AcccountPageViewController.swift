
//
//  AcccountPageViewController.swift
//  Chatalyze
//
//  Created by Mansa on 18/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

protocol stateofAccountTabDelegate {
    func currentViewController(currentController:UIViewController?)
}

import UIKit

class AcccountPageViewController: UIPageViewController {
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            MyTicketsController.instance(),
            MemoriesController.instance(),
            SettingController.instance()
        ]
        }() as! [UIViewController]
    
    var accountDelegate:stateofAccountTabDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeVariable()
        setFirstController()
        // Do any additional setup after loading the view.
    }
    
    func initializeVariable(){
        
        self.dataSource = self
        self.delegate = self
    }
    
    func setFirstController(){
    
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension AcccountPageViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
     
        
        accountDelegate?.currentViewController(currentController:viewController)
     
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0          else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
         accountDelegate?.currentViewController(currentController:viewController)
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
   
}

