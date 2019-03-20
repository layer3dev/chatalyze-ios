//
//  EditSessionFormController.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EditSessionFormController: InterfaceExtendedController {

    var eventInfo:EventInfo?
    
    @IBOutlet var scrollViewCustom:FieldManagingScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rootView?.paintInteface()
        paintInterface()
    }
    
    func paintInterface(){
        
        paintBackButton()
        paintNavigationTitle(text: "Edit Session")
    }

    var rootView:EditSessionFormRootView?{
        return self.view as? EditSessionFormRootView
    }    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    class func instance()->EditSessionFormController?{
        
        let storyboard = UIStoryboard(name: "EditScheduleSession", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditSessionForm") as? EditSessionFormController
        return controller
    }

}

