//
//  ReviewRootView.swift
//  Chatalyze
//
//  Created by Mansa on 20/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import HCSStarRatingView

class ReviewRootView:ExtendedView{
    
    @IBOutlet var ratingView:HCSStarRatingView?
    var controller:ReviewController?
    var eventInfo : EventScheduleInfo?
    override func viewDidLayout(){
        super.viewDidLayout()
        
        paintInterface()
    }
    
    func paintInterface(){
        
        resetRating()
    }
    
    @IBAction func submit(sender:UIButton){
        
        Log.echo(key: "yud", text: "The value of the rating is \(ratingView?.value)")
    }
    
    @IBAction func tapReviewAction(sender:UIButton){
        
        resetRating()
        for i in 1..<(sender.tag+1){
            
            if let button = self.viewWithTag(i) as? UIButton
            {
                button.tintColor = UIColor(hexString: "#82C57E")
                button.setImage(UIImage(named: "star"), for: UIControlState.normal)
            }
        }
    }
    
    func resetRating(){
        
        for i in 1..<6{
            
            if let button = self.viewWithTag(i) as? UIButton
            {
                button.tintColor = UIColor(hexString: "#82C57E")
                button.setImage(UIImage(named: "emptyStar"), for: UIControlState.normal)
            }
        }
    }
}
