//
//  GreetingController.swift
//  Chatalyze
//
//  Created by Mansa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class GreetingController: TabChildLoadController {
    
    @IBOutlet var rootView:GreetingRootView?
    var greetingsArray = [GreetingInfo]()
    @IBOutlet var nogreetLbl:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
      
        paintInterface()
        initailizeVariable()
    }
    
    override func viewGotLoaded() {
        super.viewGotLoaded()
        
        fetchGreetingsInfo()
    }
    
    func initailizeVariable(){
        
        self.rootView?.controller = self
    }
    
    func paintInterface(){
        
        self.paintNavigationTitle(text: "GREETINGS")
        self.paintSettingButton()
    }
    
    func fetchGreetingsInfo(){
        
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        self.showLoader()
        FetchGreetingsProcessor().fetchInfo(id: selfId, offset: 0) { (success, info) in
           
            self.stopLoader()
            self.greetingsArray.removeAll()
            self.nogreetLbl?.isHidden = true
            if success{
                
                if let array  = info{
                    if array.count > 0{
                        for info in array{
                            self.greetingsArray.append(info)
                        }
                        self.rootView?.fillInfo(info: self.greetingsArray)
                        self.nogreetLbl?.isHidden = true
                        return
                    }else if array.count <= 0{
                        self.nogreetLbl?.isHidden = false
                        self.rootView?.fillInfo(info: self.greetingsArray)
                    }
                    return
                }
            }
            self.nogreetLbl?.isHidden = false
            self.rootView?.fillInfo(info: self.greetingsArray)
            return
        }
    }
    
    func fetchDataForPagination(){
       
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }

        FetchGreetingsProcessor().fetchInfo(id: selfId, offset: self.greetingsArray.count) { (success, info) in
            
            if success{
                if let array = info{
                    if array.count > 0{
                        
                        var arrayForDuplicateChecking = self.greetingsArray
                        for i in 0..<array.count{
                            var loopController = 1
                            var isEqual = false
                            for index in stride(from: arrayForDuplicateChecking.count-1, to: -1, by: -1) {
                                if array[i].id == arrayForDuplicateChecking[index].id{
                                    isEqual = true
                                    break
                                }
                                if loopController == 10{
                                    break
                                }
                                loopController = loopController + 1
                            }
                            if isEqual == false{
                                
                               // send Data to insert in the UItableView
                                self.rootView?.insertPageData(info: array[i])
                                self.greetingsArray.append(array[i])
                            }
                        }
                        
                        //*********************************
                        for info in array{
                            self.greetingsArray.append(info)
                        }
                        self.rootView?.fillInfo(info: self.greetingsArray)
                        self.nogreetLbl?.isHidden = true
                        return
                    }
                    return
                }
            }
            return
        }
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

extension GreetingController{
    
    class func instance()->GreetingController?{
    
        let storyboard = UIStoryboard(name: "Greeting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Greeting") as? GreetingController
        return controller
    }
}
