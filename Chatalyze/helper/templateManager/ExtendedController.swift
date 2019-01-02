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
    var isReleased = false;
    
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
    
    func viewDidRelease(){
        Log.echo(key: "release", text: "viewDidRelease -> Extended")
        isReleased = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (self.isBeingDismissed || self.isMovingFromParent) {
            // clean up code here
            viewDidRelease()
        }
    }
}
