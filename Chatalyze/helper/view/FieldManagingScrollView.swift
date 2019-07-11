//
//  FieldManagingScrollView.swift
//  BN PERKS
//
//  Created by Sumant Handa on 09/06/17.
//  Copyright © 2017 Mansa. All rights reserved.
//


import UIKit

class FieldManagingScrollView: ExtendedScrollView {
    
    @IBOutlet var bottomContentOffset : NSLayoutConstraint?
    var activeField : UIView?
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        registerForKeyboardNotifications()
        registerForTapGestureForKeyboardResign()
    }
}

// MARK: - TAP GESTURE
extension FieldManagingScrollView{
    
    fileprivate func registerForTapGestureForKeyboardResign(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard(){
        self.endEditing(true)
    }
}

// MARK: - KEYBOARD HANDLING
extension FieldManagingScrollView{
    
    fileprivate func registerForKeyboardNotifications(){
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification , object: nil)
        
    }
    
    fileprivate func unregisterForKeyboardNotifications(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification : Notification){
        _ = adjustForKeyboard(notification, shouldIncreaseOffset: false)
    }
    
    @objc func keyboardWillShow(_ notification : Notification){
        scrollToIncreaseOffset(true, notification: notification)
    }
    
    fileprivate func adjustForKeyboard(_ notification : Notification, shouldIncreaseOffset : Bool)->CGFloat{
        
        let info = (notification as NSNotification).userInfo
        let keyboardSize = (info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let keyboardHeight = keyboardSize?.height ?? 255.0
        return adjustForHeight(keyboardHeight, shouldIncreaseOffset: shouldIncreaseOffset)
    }
    
    fileprivate func adjustForHeight(_ keyboardHeight : CGFloat, shouldIncreaseOffset : Bool)->CGFloat{
        
        guard let contentOffset = self.bottomContentOffset?.constant
            else{
                return keyboardHeight
        }
        
        if(shouldIncreaseOffset && keyboardHeight != contentOffset)
        {
            self.updateScrollViewContentOffset(keyboardHeight)
            return keyboardHeight;
        }
        
        if(!shouldIncreaseOffset && contentOffset != 0)
        {
            self.updateScrollViewContentOffset(0)
            return keyboardHeight;
        }
        
        return keyboardHeight
    }
    
    fileprivate func updateScrollViewContentOffset(_ contentOffset : CGFloat){
        
        self.layoutIfNeeded()
        self.bottomContentOffset?.constant = contentOffset
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    fileprivate func scrollToIncreaseOffset(_ shouldIncreaseOffset : Bool, notification : Notification){
        
        let keyboardHeight = adjustForKeyboard(notification, shouldIncreaseOffset: shouldIncreaseOffset)
        
        let screenSize = self.bounds.size
        let viewWidth = screenSize.width
        let viewHeight = screenSize.height
        
        let viewableAreaFrame = CGRect(x: 0.0, y: 0.0, width: viewWidth, height: viewHeight - keyboardHeight)
        
        guard let activeFieldUW = activeField
            else{
                return
        }
        let activeFieldOrigin = activeFieldUW.convert(activeFieldUW.bounds.origin, to: self)
        
        let scrollViewUW = self
        
        let scrollViewOrigin = scrollViewUW.convert(scrollViewUW.bounds.origin, to: nil)
        
        let activeFieldSize = activeFieldUW.bounds.size
        
        var activeFieldFrame = CGRect.zero
        activeFieldFrame.size = activeFieldSize
        activeFieldFrame.origin = CGPoint(x: activeFieldOrigin.x, y: activeFieldOrigin.y + scrollViewOrigin.y)
        
        let scrollCount = activeFieldOrigin.y + scrollViewOrigin.y + 10 + activeFieldSize.height - (viewHeight - keyboardHeight);
        
        print("viewableAreaFrame  --> \(viewableAreaFrame) activeFieldFrame-->\(activeFieldFrame)")
        
        if(!viewableAreaFrame.contains(activeFieldFrame)){
            self.contentOffset = CGPoint(x: CGFloat(0.0), y: scrollCount)
        }
    }
    
    func scrollToCustomView(customView:UIView?){
        
        let screenSize = self.bounds.size
        let viewWidth = screenSize.width
        let viewHeight = screenSize.height
        
        let viewableAreaFrame = CGRect(x: 0.0, y: 0.0, width: viewWidth, height: viewHeight)
        
        guard let activeFieldUW = customView
            else{
                return
        }
        let activeFieldOrigin = activeFieldUW.convert(activeFieldUW.bounds.origin, to: self)
        let scrollViewUW = self
        let scrollViewOrigin = scrollViewUW.convert(scrollViewUW.bounds.origin, to: nil)
        let activeFieldSize = activeFieldUW.bounds.size
        self.contentOffset = CGPoint(x: CGFloat(0.0), y: activeFieldOrigin.y-30)
    }
    
}
