//
//  OnBoardFlowController.swift
//  Chatalyze
//
//  Created by Mansa on 20/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class OnBoardFlowController: UIViewController {
    
    var didLoad:(()->())?
    
    @IBOutlet var firstDot:PageViewDotsUIPaint?
    @IBOutlet var secondDot:PageViewDotsUIPaint?
    @IBOutlet var thirdDot:PageViewDotsUIPaint?
    @IBOutlet var fourthDot:PageViewDotsUIPaint?
    @IBOutlet var fifthDot:PageViewDotsUIPaint?
    
    var onBoardPageViewController:OnBoardPageViewController?
    @IBOutlet var skipDoneLbl:UILabel?
    @IBOutlet var pageViewControl:UIPageControl?    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.didLoad?()
        setPageControl()
        // Do any additional setup after loading the view.
    }
    
    func setPageControl(){
        
        guard let role = SignedUserInfo.sharedInstance?.role else{
            return
        }
        
        if role == .user{
           
            pageViewControl?.currentPage = 0
            pageViewControl?.numberOfPages = 4
            pageViewControl?.transform = CGAffineTransform(scaleX: 2, y: 2)

            return
        }
      
        pageViewControl?.currentPage = 0
        pageViewControl?.numberOfPages = 5
        pageViewControl?.transform = CGAffineTransform(scaleX: 2, y: 2)
    
    }
    
    @IBAction func skipAction(sender:UIButton){

        UserDefaults.standard.set(true, forKey: "isOnBoardShowed")
        RootControllerManager().updateRoot()
    }
    
    func reset(){
        
        self.firstDot?.backgroundColor = UIColor.white
        self.secondDot?.backgroundColor = UIColor.white
        self.thirdDot?.backgroundColor = UIColor.white
        self.fourthDot?.backgroundColor = UIColor.white
        self.fifthDot?.backgroundColor = UIColor.white
    }
    
    func setPagerIndex(index:OnBoardPageViewController.indexofPage){
        
        if index == .first{
           
            pageViewControl?.currentPage = 0
            
            reset()
            self.firstDot?.backgroundColor = UIColor(hexString: "#4a4a4a")
            self.secondDot?.backgroundColor = UIColor.white
            self.thirdDot?.backgroundColor = UIColor.white
            self.fourthDot?.backgroundColor = UIColor.white
            self.fifthDot?.backgroundColor = UIColor.white
            self.skipDoneLbl?.text = "Skip"
            return
        }
        if index == .second{
            
            pageViewControl?.currentPage = 1
            
            reset()
            self.firstDot?.backgroundColor = UIColor.white
            self.secondDot?.backgroundColor = UIColor(hexString: "#4a4a4a")
            self.thirdDot?.backgroundColor = UIColor.white
            self.fourthDot?.backgroundColor = UIColor.white
            self.fifthDot?.backgroundColor = UIColor.white
            self.skipDoneLbl?.text = "Skip"

            return
        }
        if index == .third{
           
            pageViewControl?.currentPage = 2

            
            reset()
            self.firstDot?.backgroundColor = UIColor.white
            self.secondDot?.backgroundColor = UIColor.white
            self.thirdDot?.backgroundColor = UIColor(hexString: "#4a4a4a")
            self.fourthDot?.backgroundColor = UIColor.white
            self.fifthDot?.backgroundColor = UIColor.white
            self.skipDoneLbl?.text = "Skip"

            return
        }
        if index == .fourth{
            
            pageViewControl?.currentPage = 3

            
            reset()
            self.firstDot?.backgroundColor = UIColor.white
            self.secondDot?.backgroundColor = UIColor.white
            self.thirdDot?.backgroundColor = UIColor.white
            self.fourthDot?.backgroundColor = UIColor(hexString: "#4a4a4a")
            self.fifthDot?.backgroundColor = UIColor.white
            self.skipDoneLbl?.text = "Skip"

            if let roleId = SignedUserInfo.sharedInstance?.role{
                if roleId == .user{
                   self.skipDoneLbl?.text = "Done"
                }
            }
            return
        }
        if index == .fifth{
            
            pageViewControl?.currentPage = 4

            
            reset()
            self.firstDot?.backgroundColor = UIColor.white
            self.secondDot?.backgroundColor = UIColor.white
            self.thirdDot?.backgroundColor = UIColor.white
            self.fourthDot?.backgroundColor = UIColor.white
            self.fifthDot?.backgroundColor = UIColor(hexString: "#4a4a4a")
            self.skipDoneLbl?.text = "Done"
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let segueIdentifier  = segue.identifier
        if segueIdentifier == "pagination"{
            
            onBoardPageViewController = segue.destination as? OnBoardPageViewController
            onBoardPageViewController?.pageCustomDelegate = self
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    class func instance()->OnBoardFlowController?{
        
        let storyboard = UIStoryboard(name: "OnBoardingFlow", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "OnBoardFlow") as? OnBoardFlowController
        return controller
    }
    
}

extension OnBoardFlowController:pageViewDelegate{
   
    func indexofPage(index:OnBoardPageViewController.indexofPage){
        setPagerIndex(index:index)
        
        Log.echo(key: "yud", text: "Current index is \(index.rawValue)")
    }
}
