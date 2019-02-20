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
    @IBOutlet var revealView:ButtonContainerCorners?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        revealView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
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
        influencerView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    }
    
    @IBAction func expertAction(sender:UIButton){
      
        reset()
        selectedCategory = .expert
        influencerView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    }
    
    @IBAction func coachAction(sender:UIButton){
        
        reset()
        selectedCategory = .coach
        influencerView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    }
    
    @IBAction func otherAction(sender:UIButton){
       
        reset()
        selectedCategory = .other
        influencerView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    }
    
    @IBAction func revealMyProfileAction(sender:UIButton){
       
        if selectedCategory == .none {
            errorLabel?.text = "Please select the category."
            return
        }
        errorLabel?.text = ""
        controller?.nextScreen()
    }
    
}
