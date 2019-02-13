//
//  TippingConfirmationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 12/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class TippingConfirmationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
    }
    
    var rootView:TippingRootView?{
        return self.view as? TippingRootView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setGradientColors(){
        
        let colors = [UIColor(red: 239.0/255.0, green: 154.0/255.0, blue: 131.0/255.0, alpha: 1).cgColor,UIColor(red: 241.0/255.0, green: 170.0/255.0, blue: 120.0/255.0, alpha: 1).cgColor]
        
        self.view.addGradientWithColor(colors: colors)
    }
    
    @IBAction func cardInfoAction(sender:UIButton){
        
        guard let controller = TippingCardDetailInfoController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func dollorOneTipAction(sender:UIButton){
        
        guard let controller = TippingCardDetailInfoController.instance() else{
            return
        }
        controller.tip  = TippingCardDetailInfoController.TipPrice.oneDollor
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func dollorTwoTipAction(sender:UIButton){
        
        guard let controller = TippingCardDetailInfoController.instance() else{
            return
        }
        controller.tip  = TippingCardDetailInfoController.TipPrice.twoDollor
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func dollorFiveTipAction(sender:UIButton){
        
        guard let controller = TippingCardDetailInfoController.instance() else{
            return
        }
        controller.tip  = TippingCardDetailInfoController.TipPrice.fiveDollor
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->TippingConfirmationController?{
        
        let storyboard = UIStoryboard(name: "Tipping", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TippingConfirmation") as? TippingConfirmationController
        return controller
    }
}


extension UIView {
    
    func addGradientWithColor(colors: [CGColor]) {
     
        //It must be of cgcolor as layers always initialize with the cgcolor.
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        self.layer.insertSublayer(gradient, at: 0)
    }
}
