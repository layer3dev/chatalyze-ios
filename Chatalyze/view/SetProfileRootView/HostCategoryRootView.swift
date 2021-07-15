//
//  HostCategoryRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 20/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class HostCategoryRootView:ExtendedView {
    
    enum hostCategory:Int{
        
        case influencer = 0
        case languageTeacher = 1
        case expert = 2
        case coach = 3
        case other = 4
        case none = 5
    }
    
    @IBOutlet var errorLabel:UILabel?
    var selectedCategory = hostCategory.none
    var controller: HostCategoryController?
    
    @IBOutlet var influencerView:UIView?
    @IBOutlet var languageTeacherView:UIView?
    @IBOutlet var expertView:UIView?
    @IBOutlet var coachView:UIView?
    @IBOutlet var otherView:UIView?
    @IBOutlet var revealView:UIView?
    @IBOutlet var usernameLabel:UILabel?
    @IBOutlet var categoryTableView:UITableView?
    var categoryList:[HostCategoryListInfo] = [HostCategoryListInfo]()
    @IBOutlet var tableViewHeight:NSLayoutConstraint?
    var selectedIndex:Int = -1
    @IBOutlet var otherField:SigninFieldView?
    @IBOutlet var heightOfTextFieldView:NSLayoutConstraint?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var contentBottomConstraint:NSLayoutConstraint?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        roundToRevealView()
        initialization()
    }
    func showOtherFeield(){
        
        heightOfTextFieldView?.constant = UIDevice.current.userInterfaceIdiom == .pad ? 70 : 50
    }
    
    func hideOtherField(){
        
        heightOfTextFieldView?.constant = 0
    }
    
    func initialization(){
        
        self.scrollView?.bottomContentOffset = contentBottomConstraint
        self.otherField?.textField?.doneAccessory = true
        self.otherField?.isCompleteBorderAllow = true
        self.otherField?.textField?.delegate = self
    }
    
    
    func fillInfo(){
        
        usernameLabel?.text = ""
        guard let name = SignedUserInfo.sharedInstance?.firstName else {
            return
        }
        categoryTableView?.dataSource = self
        categoryTableView?.delegate = self
        self.categoryTableView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        usernameLabel?.text = name.firstCapitalized
    }
    
    func reloadTableWithData(data:[HostCategoryListInfo]?){
        
        guard let info = data else{
            return
        }
        self.categoryList = info
        self.categoryTableView?.reloadData()
    }
    
    func roundToRevealView(){
     
        revealView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        revealView?.layer.masksToBounds = true
    }
    
    func reset(){
        
        influencerView?.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        languageTeacherView?.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        expertView?.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        coachView?.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        otherView?.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
    }
    
    @IBAction func influencerAction(sender:UIButton){
       
        reset()
        selectedCategory = .influencer
        influencerView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    }
    
    @IBAction func languageTeacherAction(sender:UIButton){
     
        reset()
        selectedCategory = .languageTeacher
        languageTeacherView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    }
    
    @IBAction func expertAction(sender:UIButton){
      
        reset()
        selectedCategory = .expert
        expertView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    }
    
    @IBAction func coachAction(sender:UIButton){
        
        reset()
        selectedCategory = .coach
        coachView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    }
    
    @IBAction func otherAction(sender:UIButton){
       
        reset()
        selectedCategory = .other
        otherView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        showOtherFeield()
        
        
        //In order to reset the table fields field.
        selectedIndex = -1
        self.categoryTableView?.reloadData()
        self.errorLabel?.text = ""
    }
    
    @IBAction func revealMyProfileAction(sender:UIButton){
       
        if selectedCategory == .other{
            
            if otherField?.textField?.text?.replacingOccurrences(of: " ", with: "") == ""{
                
                otherField?.showError(text: "Category is required.".localized())
                
            }else{
                
                otherField?.showError(text: "")
                controller?.nextScreen()
                
            }
            return
        }
        
        if selectedIndex == -1 && self.categoryList.count > 0{
            
            errorLabel?.text = "Category is required.".localized()
            return
        }
        errorLabel?.text = ""
        controller?.nextScreen()
    }
    
    func getParam()->[String:Any]?{
        
        var param = [String:Any]()
        var nestedParam = [String:String]()
        
        if selectedCategory == .other{
            
            nestedParam["name"] = otherField?.textField?.text ?? ""
            param["category"] = nestedParam
            //{"category":{"name":"hello filling other"}}
            return param
        }
        
        if selectedIndex == -1 {
            return nil
        }
        
        nestedParam["id"] = categoryList[selectedIndex].id ?? ""
        nestedParam["categoryType"] = categoryList[selectedIndex].categoryType ?? ""
        nestedParam["categoryId"] = categoryList[selectedIndex].categoryId ?? ""
        nestedParam["name"] = categoryList[selectedIndex].name ?? ""
        param["category"] = nestedParam
        
        Log.echo(key: "yud", text: "parameters selected are \(param)")
        return param
    }
}

extension HostCategoryRootView:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = categoryTableView?.dequeueReusableCell(withIdentifier: "HostCategoryCell", for: indexPath) as? HostCategoryCell else {
            return UITableViewCell()
        }
        if indexPath.row < categoryList.count {
            
            cell.currentIndex = indexPath.row
            cell.selectedIndex = { selectedCellIndex in
                Log.echo(key: "yud", text: "selected cell is \(selectedCellIndex)")
                
                
                self.selectedIndex = selectedCellIndex
                self.categoryTableView?.reloadData()
                
                //In order to hide the price Field.
                
                self.selectedCategory = .none
                self.reset()
                self.hideOtherField()
                self.otherField?.showError(text: "")
            }
            if indexPath.row == selectedIndex {
                cell.isCellSelected = true
            }else{
                cell.isCellSelected = false
            }
            cell.fillInfo(info: categoryList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        DispatchQueue.main.async {
            
            self.categoryTableView?.layer.removeAllAnimations()
            self.tableViewHeight?.constant = self.categoryTableView?.contentSize.height ?? 0.0
        }
    }
}

extension HostCategoryRootView:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension HostCategoryRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = otherField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
}
