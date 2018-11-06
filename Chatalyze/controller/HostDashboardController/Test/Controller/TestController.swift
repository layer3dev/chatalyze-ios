//
//  TestController.swift
//  Chatalyze
//
//  Created by Mansa on 10/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class TestController: InterfaceExtendedController{

    @IBOutlet var savedCardsTable:UITableView?
    
    var crossFading: Bool  = false
    let duration = 1.0
    let fontSizeSmall: CGFloat = 30
    let fontSizeBig: CGFloat = 120
    var isSmall: Bool = true
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeVariable()
        reset(self)
    }
    
    func initializeVariable(){
        
        savedCardsTable?.dataSource = self
        savedCardsTable?.delegate = self
        savedCardsTable?.reloadData()
    }

    @IBAction func ticketsAction(){
        
        enlarge()
//        crossFading = true
//        animateFont(self)
        //RootControllerManager().setMyTicketsScreenForNavigation()
    }
    
    
    @IBAction func sessionAction(){

        shrink()
//        crossFading = false
//        animateFont(self)
        //RootControllerManager().selectEventTabWithEventScreen()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func reset(_ sender: Any) {
        
        var bounds = label.bounds
        label.font = label.font.withSize(fontSizeSmall)
        bounds.size = label.intrinsicContentSize
        label.bounds = bounds
        isSmall = true
    }
    
    @IBAction func animateFont(_ sender: Any) {
        
        if isSmall {
            if crossFading {
                enlargeWithCrossFade()
            } else {
                enlarge()
            }
        } else {
            if crossFading {
                shrinkWithCrossFade()
            } else {
                shrink()
            }
        }
        isSmall = !isSmall
    }
    
    func enlarge() {
        
        var biggerBounds = label.bounds
        label.font = label.font.withSize(fontSizeBig)
        biggerBounds.size = label.intrinsicContentSize
        
        label.transform = scaleTransform(from: biggerBounds.size, to: label.bounds.size)
        label.bounds = biggerBounds
        
//        UIView.animate(withDuration: duration) {
//            self.label.transform = .identity
//        }
//
        //Animated
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = .identity

        }) { (success) in
            self.shrink()
        }
    }
    
    func enlargeWithCrossFade() {
        
        let labelCopy = label.copyLabel()
        view.addSubview(labelCopy)
        
        var biggerBounds = label.bounds
        label.font = label.font.withSize(fontSizeBig)
        biggerBounds.size = label.intrinsicContentSize
        
        label.transform = scaleTransform(from: biggerBounds.size, to: label.bounds.size)
        let enlargeTransform = scaleTransform(from: label.bounds.size, to: biggerBounds.size)
        label.bounds = biggerBounds
        label.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = .identity
            labelCopy.transform = enlargeTransform
        }, completion: { done in
            labelCopy.removeFromSuperview()
        })
        
        UIView.animate(withDuration: duration / 2) {
           
            self.label.alpha = 1.0
            labelCopy.alpha = 0.0
        }
    }
    
    func shrink() {
        
        let labelCopy = label.copyLabel()
        var smallerBounds = labelCopy.bounds
        labelCopy.font = label.font.withSize(fontSizeSmall)
        smallerBounds.size = labelCopy.intrinsicContentSize
        
        let shrinkTransform = scaleTransform(from: label.bounds.size, to: smallerBounds.size)
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = shrinkTransform
        }, completion: { done in
            self.label.font = labelCopy.font
            self.label.transform = .identity
            self.label.bounds = smallerBounds
            self.enlarge()
        })
    }
    
    func shrinkWithCrossFade() {
        
        let labelCopy = label.copyLabel()
        view.addSubview(labelCopy)
        
        var smallerBounds = label.bounds
        label.font = label.font.withSize(fontSizeSmall)
        smallerBounds.size = label.intrinsicContentSize
        
        label.transform = scaleTransform(from: smallerBounds.size, to: label.bounds.size)
        label.alpha = 0.0
        
        let shrinkTransform = scaleTransform(from: label.bounds.size, to: smallerBounds.size)
        
        UIView.animate(withDuration: duration, animations: {
            labelCopy.transform = shrinkTransform
            self.label.transform = .identity
        }, completion: { done in
            self.label.transform = .identity
            self.label.bounds = smallerBounds
        })
        
        let percUntilFade = 0.8
        UIView.animate(withDuration: duration - (duration * percUntilFade), delay: duration * percUntilFade, options: .curveLinear, animations: {
            labelCopy.alpha = 0
            self.label.alpha = 1
        }, completion: { done in
            labelCopy.removeFromSuperview()
        })
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
}


extension TestController{
    
    class func instance()->TestController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Test") as? TestController
        return controller
    }
}


extension TestController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = savedCardsTable?.dequeueReusableCell(withIdentifier: "SavedCardsCell", for: indexPath) as? SavedCardsCell else{
            return UITableViewCell()
        }
        return cell
    }
}

extension TestController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}



