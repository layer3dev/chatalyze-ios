//
//  GetApppleSignInButton.swift
//  Chatalyze
//
//  Created by Mansa Mac-3 on 7/28/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices

class GetApppleSignInButton: NSObject {
    
    private static var _sharedGetApppleSignInButton: GetApppleSignInButton?
    
    @objc public static var sharedGetApppleSignInButton : GetApppleSignInButton? {
        get{
            guard self._sharedGetApppleSignInButton != nil else {
                self._sharedGetApppleSignInButton = GetApppleSignInButton()
                return _sharedGetApppleSignInButton
            }
            return self._sharedGetApppleSignInButton
        }
    }

    @objc func getButtonWith(target: UIViewController, selector: Selector, superView: UIView, isActiveConstraintsNeeded: Bool)->UIView  {
        if #available(iOS 13.0, *) {
          let appleButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
            appleButton.translatesAutoresizingMaskIntoConstraints = false
                                appleButton.addTarget(target, action: selector, for: .touchUpInside)
                                superView.addSubview(appleButton)
                                if(isActiveConstraintsNeeded) {
                                        NSLayoutConstraint.activate([
                                        appleButton.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
                                        appleButton.topAnchor.constraint(equalTo: superView.topAnchor, constant:                    0),
                                        appleButton.bottomAnchor.constraint(equalTo: superView.bottomAnchor,                    constant: 0),
                                        appleButton.leadingAnchor.constraint(equalTo: superView.leadingAnchor,                  constant: 0),
                                        appleButton.trailingAnchor.constraint(equalTo: superView.trailingAnchor,                    constant: 0),
                                          
                                        ])
                                }
                                return appleButton
        } else {
            return UIView()
        }
    }
}
