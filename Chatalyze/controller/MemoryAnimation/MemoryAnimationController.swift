//
//  MemoryAnimationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 13/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class MemoryAnimationController: InterfaceExtendedController {
    
    weak var lastPresentingController : UIViewController?
    var memoryImage:UIImage?
    @IBOutlet var memoryImageView:UIImageView?
    var eventInfo:EventScheduleInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintImageView()
        // Do any additional setup after loading the view.
    }
    
    func paintImageView(){
        
        self.memoryImageView?.image = memoryImage
    }
    
    
    @IBAction func dismiss(sender:UIButton?){
        
        self.dismiss(animated: true) {
            
            guard let controller = ReviewController.instance() else {
                return
            }
            controller.eventInfo = self.eventInfo
            self.lastPresentingController?.present(controller, animated: true, completion: {
            })
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
    
    
    class func instance()->MemoryAnimationController?{
        
        let storyboard = UIStoryboard(name: "MemoryAnimation", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemoryAnimation") as? MemoryAnimationController
        return controller
    }

}
