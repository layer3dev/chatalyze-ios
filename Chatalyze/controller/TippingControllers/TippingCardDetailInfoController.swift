//
//  TippingCardDetailInfoController.swift
//  Chatalyze
//
//  Created by mansa infotech on 13/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import InputMask

class TippingCardDetailInfoController: UIViewController {
    
    enum TipPrice:Int{
    
        case oneDollor = 0
        case twoDollor = 1
        case fiveDollor = 2
        case none = 3
    }
   
    var tip = TipPrice.none
   
    @IBOutlet var tipPriceLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fillPriceInfo()        
    }
    
    func fillPriceInfo(){
        
        if tip == .none{
            
            tipPriceLabel?.text = ""
            return
        }
        if tip == .oneDollor{
            
            tipPriceLabel?.text = "$1.00"
            return
        }
        if tip == .twoDollor{
            
            tipPriceLabel?.text = "$2.00"
            return
        }
        if tip == .fiveDollor{
            
            tipPriceLabel?.text = "$5.00"
            return
        }
        
    }
    
    var rootView:TippingCardInfoRootView? {
        return self.view as? TippingCardInfoRootView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->TippingCardDetailInfoController?{
        
        let storyboard = UIStoryboard(name: "Tipping", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TippingCardDetailInfo") as? TippingCardDetailInfoController
        return controller
    }

}

