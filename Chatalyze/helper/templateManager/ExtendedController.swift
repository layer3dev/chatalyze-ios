//
//  ExtendedViewController.swift
//  GenGold
//
//  Created by Sumant Handa on 15/10/16.
//  Copyright © 2016 Mansa. All rights reserved.
//

import UIKit

class ExtendedController: UIViewController {

    private var isLoaded = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated : Bool){
        super.viewWillAppear(animated)
        if(!isLoaded){
            isLoaded = true
            viewDidLayout()
        }
    }
    
    func viewDidLayout(){
    }
}