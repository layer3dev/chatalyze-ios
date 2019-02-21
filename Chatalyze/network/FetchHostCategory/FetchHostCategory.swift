//
//  FetchHostCategory.swift
//  Chatalyze
//
//  Created by mansa infotech on 21/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchHostCategoryProcessor{
    
    public func fetchInfo(completion : @escaping ((_ success : Bool, _ response : [HostCategoryListInfo]?)->())){

        let url = AppConnectionConfig.webServiceURL + "/tag/host"
        let params = [String:Any]()
        
        Log.echo(key: "yud", text:"url in the payment fetch is \(url)")
        
        ServerProcessor().request(.get, url, parameters : params, encoding: .queryString, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : [HostCategoryListInfo]?)->())){
        
        Log.echo(key: "yud", text: "Response of fetching the category is   \(String(describing: response))")
        
        if(!success){
            completion(false, nil)
            return
        }
        
        guard let responseArray = response?.array
            else{
                completion(false, nil)
                return
        }
        
        var infoArray = [HostCategoryListInfo]()
        for info in responseArray{
            let obj = HostCategoryListInfo(info: info)
            infoArray.append(obj)
        }
        completion(true, infoArray)
        return
    }
}
