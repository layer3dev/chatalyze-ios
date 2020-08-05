//
//  AppleUserDetails.swift
//  Chatalyze
//
//  Created by Mansa Mac-3 on 7/28/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation
import AuthenticationServices

@available(iOS 13.0, *)
struct AppleUserDetails {
  
  
  let id: String
  let fullname: String
  let lastName: String
  let email:String
  
  init(credentails: ASAuthorizationAppleIDCredential) {
    self.id = credentails.user
    self.fullname = credentails.fullName?.givenName ?? ""
    self.lastName = credentails.fullName?.familyName ?? ""
    self.email = credentails.email ?? ""
  }
}

@available(iOS 13.0, *)
extension AppleUserDetails: CustomDebugStringConvertible{
  var debugDescription: String {
    return """
    id: \(id)
    First Name : \(fullname)
    Last Name : \(lastName)
    Email : \(email)
    """
  }
}
