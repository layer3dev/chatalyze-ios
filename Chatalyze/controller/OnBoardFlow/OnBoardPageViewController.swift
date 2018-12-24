//
//  OnBoardPageViewController.swift
//  Chatalyze
//
//  Created by Mansa on 20/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit


protocol pageViewDelegate {
    func indexofPage(index:OnBoardPageViewController.indexofPage)
}

class OnBoardPageViewController: UIPageViewController {
    
    enum indexofPage:Int{
    
        case first  =  0
        case second =  1
        case third  =  2
        case fourth =  3
        case fifth  =  4
    }
    
    enum controllerObjectIndex:Int{
     
        case first  =  0
        case second =  1
        case third  =  2
        case fourth =  3
        case fifth  =  4
    }
    
    
    var pageCustomDelegate:pageViewDelegate?
    
    var currentIndex = indexofPage.first
    
    var firstController:OnboardFirstController?
    var secondController:OnboardFirstController?
    var thirdController:OnboardFirstController?
    var fourthController:OnboardFirstController?
    var fifthController:OnboardFirstController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        setFirstController()
        // Do any additional setup after loading the view.
    }
    
    func setFirstController(){
 
        guard let firstController = getControllerAtIndex(index: indexofPage.first) else {
            return
        }
        
        setViewControllers([firstController], direction: .forward, animated: true) { (success) in
        }
    }
    
    
    func getPreviousIndex(index:indexofPage)->indexofPage?{
        
        guard let userType = SignedUserInfo.sharedInstance?.role else{
            return nil
        }
        
        if userType == .analyst{
            
            if index == .first{
                return nil
            }
            if index == .second{
                return indexofPage.first
            }
            if index == .third{
                return indexofPage.second
            }
            if index == .fourth{
                return indexofPage.third
            }
            if index == .fifth{
                return indexofPage.fourth
            }
            return nil
        }
        
        if userType == .user{
            
            if index == .first{
                return nil
            }
            if index == .second{
                return indexofPage.first
            }
            if index == .third{
                return indexofPage.second
            }
            if index == .fourth{
                return indexofPage.third
            }
            return nil
        }
        return nil
    }
    
    func getNextIndex(index:indexofPage)->indexofPage?{
        
        guard let userType = SignedUserInfo.sharedInstance?.role else{
            return nil
        }
        
        if userType == .analyst{
           
            if index == .first{
                return indexofPage.second
            }
            if index == .second{
                return indexofPage.third
            }
            if index == .third{
                return indexofPage.fourth
            }
            if index == .fourth{
                return indexofPage.fifth
            }
            if index == .fifth{
                return nil
            }
            return nil
        }
        if userType == .user{
            
            if index == .first{
                return indexofPage.second
            }
            if index == .second{
                return indexofPage.third
            }
            if index == .third{
                return indexofPage.fourth
            }
            if index == .fourth{
                return nil
            }
            return nil
        }
        return nil
    }
    
    
    func getCurrentIndex(index:Int)->indexofPage{
        
        if index == 0{
            return indexofPage.first
        }
        if index == 1{
            return indexofPage.second
        }
        if index == 2{
            return indexofPage.third
        }
        if index == 3{
            return indexofPage.fourth
        }
        if index == 4{
            return indexofPage.fifth
        }
        return indexofPage.first
    }
    
    
    func getControllerAtIndex(index:indexofPage)->UIViewController?{
        
        if index == .first{
            
            if let controller = firstController{
                return controller
            }
            guard let controller = OnboardFirstController.instance() else{
                return nil
            }
            controller.currentControllerIndex = .first
            self.firstController = controller
            return self.firstController
        }
        if index == .second{
            
            if let controller = secondController{
                return controller
            }
            guard let controller = OnboardFirstController.instance() else{
                return nil
            }
            controller.currentControllerIndex = .second
            self.secondController = controller
            return self.secondController
        }
        if index == .third{
            
            if let controller = thirdController{
                return controller
            }
            guard let controller = OnboardFirstController.instance() else{
                return nil
            }
            controller.currentControllerIndex = .third
            self.thirdController = controller
            return self.thirdController
        }
        if index == .fourth{
            
            if let controller = fourthController{
                return controller
            }
            guard let controller = OnboardFirstController.instance() else{
                return nil
            }
            controller.currentControllerIndex = .fourth
            self.fourthController = controller
            return self.fourthController
        }
        if index == .fifth{
            
            if let controller = fifthController{
                return controller
            }
            guard let controller = OnboardFirstController.instance() else{
                return nil
            }
            controller.currentControllerIndex = .fifth
            self.fifthController = controller
            return self.fifthController
        }
        return nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension OnBoardPageViewController:UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let previousIndex = getPreviousIndex(index:currentIndex) else{
            return nil
        }
        guard let controller = getControllerAtIndex(index: previousIndex) else{
            return nil
        }
        
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      
        guard let nextIndex = getNextIndex(index:currentIndex) else{
            return nil
        }
        guard let controller = getControllerAtIndex(index: nextIndex) else{
            return nil
        }
        
        return controller
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        Log.echo(key: "yud", text: "Current Controller is \(pageViewController.viewControllers?.first)")
        
        if finished {
            
            pageCustomDelegate?.indexofPage(index: getCurrentIndex(index: pageViewController.viewControllers?.first?.view.tag ?? 0))
            
            self.currentIndex = getCurrentIndex(index: pageViewController.viewControllers?.first?.view.tag ?? 0)
            
            Log.echo(key: "yud", text: "Transition is ended \(finished) and the current index is \(pageViewController.viewControllers?.first?.view.tag)")
        }
    }
    
}
