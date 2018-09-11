//
//  MemoriesController.swift
//  Chatalyze
//
//  Created by Mansa on 18/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


protocol getMemoryScrollInsets {
    
    func getMemoryScrollInset(offset:CGFloat?)
}

import UIKit

class MemoriesController: InterfaceExtendedController {

    @IBOutlet var scroll:UIScrollView?
    var delegate:getMemoryScrollInsets?
    
    @IBOutlet var rootView:MemoriesRootView?
    var memoriesListingArray = [MemoriesInfo]()
    
    @IBOutlet var nogreetLbl:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        initializeVariable()
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "PAYMENT HISTORY")
        paintBackButton()
    }
    
    func initializeVariable(){
        
        self.rootView?.controller = self
       
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
         getPaymentInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getPaymentInfo(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        self.showLoader()
        
        MemoriesFetchProcessor().fetchInfo(id: id, offset: 0) { (success, info) in
            
            self.stopLoader()
            self.memoriesListingArray.removeAll()
            self.nogreetLbl?.isHidden = true
            if success{
                
                if let array  = info{
                    if array.count > 0{
                        for info in array{
                            
                            self.memoriesListingArray.append(info)
                        }
                        self.rootView?.fillInfo(info: self.memoriesListingArray)
                        self.nogreetLbl?.isHidden = true
                        return
                    }else if array.count <= 0{
                        self.nogreetLbl?.isHidden = false
                        self.rootView?.fillInfo(info: self.memoriesListingArray)
                    }
                    return
                }
            }
            self.nogreetLbl?.isHidden = false
            self.rootView?.fillInfo(info: self.memoriesListingArray)
            return
        }
    }
    
    func fetchDataForPagination(){
        
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        
        MemoriesFetchProcessor().fetchInfo(id: selfId, offset: self.memoriesListingArray.count) { (success, info) in
            
            if success{
                if let array = info{
                    if array.count > 0{
                        
                        var arrayForDuplicateChecking = self.memoriesListingArray
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
                                
                                //send Data to insert in the UItableView
                                self.rootView?.insertPageData(info: array[i])
                                self.memoriesListingArray.append(array[i])
                            }
                        }
                        return
                    }
                    self.rootView?.hidePaginationLoader()
                    return
                }
            }
            self.rootView?.hidePaginationLoader()
            return
        }
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


extension MemoriesController{
    
    class func instance()->MemoriesController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Memories") as? MemoriesController
        return controller
    }
}

extension MemoriesController{
    
    func updateTableContentOffset(offset:CGFloat?){
        
        guard let offset = offset  else {
            return
        }
        delegate?.getMemoryScrollInset(offset: offset)
    }
    
}
