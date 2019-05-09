//
//  FacebookProfileFetch.swift
//  Chatalyze
//
//  Created by Sumant Handa on 27/02/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import FacebookCore
import SwiftyJSON

//class FacebookProfileFetch{
//
//    struct MyProfileRequest: GraphRequestProtocol {
//        struct Response: GraphResponseProtocol {
//
//            var name: String?
//            var id: String?
//            var gender: String?
//            var email: String?
//            var profilePictureUrl: String?
//
//            init(rawResponse: Any?) {
//                // Decode JSON from rawResponse into other properties here.
//                guard let response = rawResponse as? Dictionary<String, Any> else {
//                    return
//                }
//
//                if let name = response["name"] as? String {
//                    self.name = name
//                }
//
//                if let id = response["id"] as? String {
//                    self.id = id
//                }
//
//                if let gender = response["gender"] as? String {
//                    self.gender = gender
//                }
//
//                if let email = response["email"] as? String {
//                    self.email = email
//                }
//
//                if let picture = response["picture"] as? Dictionary<String, Any> {
//
//                    if let data = picture["data"] as? Dictionary<String, Any> {
//                        if let url = data["url"] as? String {
//                            self.profilePictureUrl = url
//                        }
//                    }
//                }
//            }
//        }
//
//        var graphPath = "/me"
//        var parameters: [String : Any]? = ["fields": "id, name"]
//        var accessToken = AccessToken.current
//        var httpMethod: GraphRequestHTTPMethod = .GET
//        var apiVersion: GraphAPIVersion = .defaultVersion
//    }
//
//    func getInfo(completion : ((_ success : Bool, _ message : String?,  _ response : FacebookResponse?)->())?){
//        let connection = GraphRequestConnection()
//        connection.add(MyProfileRequest()) { urlResponse, result in
//            switch result {
//            case .success(let rawResponse):
//                let fbInfo = FacebookResponse()
//                if let fbId = rawResponse.id{
//                    fbInfo.id = fbId
//                }
//
//                if let name = rawResponse.name{
//                    fbInfo.name = name
//                }
//
//                if let gender = rawResponse.gender{
//                    fbInfo.gender = gender
//                }
//
//                if let email = rawResponse.email{
//                    fbInfo.email = email
//                }
//
//                if let profilePictureUrl = rawResponse.profilePictureUrl{
//                    fbInfo.profilePictureUrl = profilePictureUrl
//                }
//
//                completion?(true, "Details Fetched Successfully", fbInfo)
//                break
//            case .failed(let error):
//
//                completion?(false,  error.localizedDescription, nil)
//            }
//        }
//        connection.start()
//    }
//
//}

