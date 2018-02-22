//
//  PlaceholderTextView.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 29/04/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit

class PlaceholderTextView: ExtendedTextView {
    
    @IBInspectable var _placeholder = "";
    var listener : UITextViewDelegate?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        self.delegate = self
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var placeholder : String{
        get{
            return _placeholder
        }
        set{
            _placeholder = newValue
            setPlaceholder()
        }
    }
    
    fileprivate func setPlaceholder(){
        
        if(self.text != ""){
            return
        }
        self.text = placeholder
        self.textColor = UIColor.lightGray
        
    }
}

extension PlaceholderTextView : UITextViewDelegate{
    
    func setText(text : String?){
        self.text = text
        
        if(text != ""){
            return
        }
        setPlaceholder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text != placeholder){
            listener?.textViewDidBeginEditing?(textView)
            return
        }
        
        textView.text = ""
        textView.textColor = UIColor.black
        textView.becomeFirstResponder()
        listener?.textViewDidBeginEditing?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text != ""){
            listener?.textViewDidEndEditing?(textView)
            return
        }
        
        textView.text = placeholder
        textView.textColor = UIColor.lightGray
        textView.resignFirstResponder()
        listener?.textViewDidEndEditing?(textView)
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
//
//        if(!validateInput(range, string: string)){
//            return false
//        }
//        return delegate?.formatField?(self, shouldChangeCharactersInRange: range, replacementString: string) ?? true
//    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.text.count > 200{
            return false
        }
        return true
    }
}
