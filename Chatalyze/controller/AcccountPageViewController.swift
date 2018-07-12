
//
//  AcccountPageViewController.swift
//  Chatalyze
//
//  Created by Mansa on 18/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

protocol stateofAccountTabDelegate {
    
    func currentViewController(currentController:UIViewController?)
    func contentOffsetForMemory(offset:CGFloat?)
    func contentOffsetForTickets(scrollView:UIScrollView)
    func contentOffsetForSeetings(scrollView:UIScrollView)
}

import UIKit

class AcccountPageViewController: UIPageViewController {
    
    let ticketController = MyTicketsPageController.instance()
    let memoryController = MemoriesController.instance()
    let settingController = SettingController.instance()
    
    fileprivate lazy var pages: [UIViewController] = ({
        return [
            ticketController,
            memoryController,
            settingController
        ]
        }() as! [UIViewController])
    
    var accountDelegate:stateofAccountTabDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializeVariable()
        setFirstController()
        ticketController?.delegate = self
        memoryController?.delegate = self
        settingController?.delegate = self
        //Do any additional setup after loading the view.
    }
    
    func initializeVariable(){
        
//        self.dataSource = self
//        self.delegate = self
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


extension AcccountPageViewController{
    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//
//        accountDelegate?.currentViewController(currentController:viewController)
//        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
//        let previousIndex = viewControllerIndex - 1
//        //guard previousIndex >= 0          else { return pages.last }
//        guard previousIndex >= 0          else { return nil }
//        guard pages.count > previousIndex else { return nil }
//        accountDelegate?.contentOffsetForMemory(offset: 0.0)
//        return pages[previousIndex]
//    }
//
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//         accountDelegate?.currentViewController(currentController:viewController)
//        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
//        let nextIndex = viewControllerIndex + 1
//        //guard nextIndex < pages.count else { return pages.first }
//        guard nextIndex < pages.count else { return nil }
//        guard pages.count > nextIndex else { return nil         }
//        accountDelegate?.contentOffsetForMemory(offset: 0.0)
//        return pages[nextIndex]
//    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//
//        guard let controller = pageViewController.viewControllers?.last
//            else{
//                return
//        }
//        accountDelegate?.currentViewController(currentController:controller)
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//
//
//
//        guard let controller = pendingViewControllers.last
//            else{
//                return
//        }
//        accountDelegate?.currentViewController(currentController:controller)
//    }
    
}

extension AcccountPageViewController:getMemoryScrollInsets,getSettingScrollInstet,getTicketsScrollInsets {
    
    func getMemoryScrollInset(offset: CGFloat?) {
        
        guard let offset = offset else {
            return
        }
        accountDelegate?.contentOffsetForMemory(offset: offset)
    }
    
    func getSettingScrollInset(scrollView: UIScrollView) {
        
        accountDelegate?.contentOffsetForSeetings(scrollView: scrollView)
        Log.echo(key: "yud", text: "scroll Inset is \(scrollView.contentOffset.y)")
    }
    
    func getTicketsScrollInset(scrollView: UIScrollView) {
        
        Log.echo(key: "yud", text: "scroll Inset is \(scrollView.contentOffset.y)")
    }
}

extension AcccountPageViewController{
    
    func setSettingTab(){
        
        setViewControllers([pages[2]], direction: .forward, animated: false, completion: nil)
        accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }
    func setMemoryTab(){
        
        setViewControllers([pages[1]], direction: .forward, animated: false, completion: nil)
        accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }
    func setMyTicketTab(){
        
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }
}
