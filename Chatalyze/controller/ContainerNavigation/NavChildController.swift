//
//  NavChildController.swift
//  Chatalyze
//
//  Created by Mansa on 24/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit

class NavChildController: InterfaceExtendedController {
    
    private var isLoaded = false
    private var isLayoutCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewGotLoaded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated : Bool){
        super.viewWillAppear(animated)
        if(!isLoaded){
            isLoaded = true
            return
        }
        viewGotLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!isLayoutCompleted){
            isLayoutCompleted = true
            viewLayoutCompleted()
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func viewGotLoaded(){
    }
    
    func viewLayoutCompleted(){
    }
}

