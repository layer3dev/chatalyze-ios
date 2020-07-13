//
//  HostTermsAndContions.swift
//  Chatalyze
//
//  Created by Mansa Mac-3 on 7/2/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import UIKit

class HostTermsAndContions:UIViewController,UITextViewDelegate{


  lazy var txtView :UITextView = {
    let txtView = UITextView()
    txtView.font = UIFont.systemFont(ofSize: 16)
    txtView.backgroundColor = .clear
    txtView.textColor = .white
    txtView.delegate = self
    txtView.textAlignment = .center
    txtView.linkTextAttributes = [
        .foregroundColor: UIColor(r: 83, g: 110, b: 203),
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    txtView.isUserInteractionEnabled = true
    txtView.isEditable = false
    txtView.font = UIFont(name: "Nunito-Regular", size: 16)
    return txtView
  }()

  lazy var chatalyzeLbl : UIImageView = {
    let iv = UIImageView()
    let image = UIImage(named: "logo_for_terms&Conditions")
    iv.image = image
    iv.contentMode = .scaleAspectFit
    return iv
  }()

  lazy var acceptBtn : UIButton = {

    let btn = UIButton(type: .system)
    btn.setTitleColor(.white, for: .normal)
    btn.setTitle("Accept", for: .normal)
    btn.backgroundColor = UIColor(r: 236, g: 82, b: 62)
    btn.layer.cornerRadius = 6
    btn.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
    return btn
  }()


  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(chatalyzeLbl)
    self.view.addSubview(txtView)
    self.view.addSubview(acceptBtn)
    setupTxtView()
    upddatetextView()
    view.backgroundColor = UIColor(r: 32, g: 35, b: 42)
  }

  @objc func acceptAction(){
//    dismiss(animated: true, completion: nil)
    updateTermsCondtions()
  }


  func updateTermsCondtions(){

      var param = [String:Any]()
      param["termsAccepted"] = true

      Log.echo(key: "yud", text: "params are \(param)")

      self.showLoader()
      EditProfileProcessor().edit(params: param) { (success, message, response) in

          self.stopLoader()
        if success{
          
          guard let info = SignedUserInfo.sharedInstance else{
            return
          }
          info.isTermsAccepted = true
          info.save()
          
          self.dismiss(animated: true)
          
        }
          
      }
  }


  func setupTxtView() {

    self.chatalyzeLbl.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 60, left: 0, bottom: 0, right: 0),size: .init(width: 200, height: 50))
    chatalyzeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    chatalyzeLbl.translatesAutoresizingMaskIntoConstraints = false

    let newHeight = estimateHeightForMessage(text: txtView.text!).height + 380
    txtView.anchor(top: chatalyzeLbl.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 5, left: 20, bottom: 0, right: 20),size: .init(width: 0, height: newHeight))


    acceptBtn.anchor(top: txtView.bottomAnchor, leading: txtView.leadingAnchor, bottom: nil, trailing: txtView.trailingAnchor,padding: .init(top: 20, left: 0, bottom: 20, right: 0), size: .init(width: 0, height: 50))

  }



  func upddatetextView(){
    let attributedText = NSMutableAttributedString()
    let helpCenterLink = "https://support.chatalyze.com/hc/en-us"
    let privacyLink = "https://www.chatalyze.com/privacy"
    let termsLink = "https://www.chatalyze.com/terms"

    attributedText.append(NSAttributedString.makeHyperLink(path: helpCenterLink, string: text1, substring: "Chatalyze Help Center"))
    attributedText.append(NSAttributedString.makeHyperLink(path: termsLink, string: text2, substring: "Terms of Service"))
    attributedText.append(NSAttributedString.makeHyperLink(path: privacyLink, string: text3, substring: "Privacy Policy"))

    txtView.attributedText = attributedText
    txtView.textColor = .white
    txtView.font = UIFont(name: "Nunito-Regular", size: 14)
    }

  let text1 = "Welcome to your new Chatalyze account [\(String(describing: SignedUserInfo.sharedInstance?.email ?? ""))] This account has access to the core Chatalyze features that allow you to schedule, manage, and host virtual meet and greets. In addition, your account administrator can schedule and manage events for you. For tips about using this account, visit the Chatalyze Help Center."

  let text2  = "\n\nYour administrator will have access to your information stored in this Chatalyze account, including data such as profile pictures and biographical information. Your administrator also can deactivate this account at any time. You can choose to maintain a separate account for personal Chatalyze usage. \n\nClick “Accept” below to indicate that you understand this description of how your [\(String(describing: SignedUserInfo.sharedInstance?.email ?? ""))] account works and agree to the Chatalyze Terms of Service"

  let text3  =  "and Privacy Policy."

}

extension HostTermsAndContions {

  private func estimateHeightForMessage(text:String)-> CGRect{


    let size = CGSize(width: 0, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }

  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

    UIApplication.shared.open(URL)
    return true

  }
}
