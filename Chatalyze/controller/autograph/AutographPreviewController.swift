//
//  AutographPreviewController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AutographPreviewController: InterfaceExtendedController {
    
    
    var image : UIImage?
    @IBOutlet private var imageView : UIImageView?
    private var completion : ((_ image : UIImage?)->())?
    
    @IBAction private func cancel(){
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }
    
    func onResult(completion : ((_ image : UIImage?)->())?){
            self.completion = completion
    }
    
    @IBAction private func save(){
        self.presentingViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.completion?(self?.image)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialization()
    }
    
    
    private func initialization(){
        self.imageView?.image = image
        
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

extension AutographPreviewController{
    class func instance()->AutographPreviewController?{
        
        let storyboard = UIStoryboard(name: "autograph", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "autograph_preview") as? AutographPreviewController
        return controller
    }
}

extension AutographPreviewController : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
