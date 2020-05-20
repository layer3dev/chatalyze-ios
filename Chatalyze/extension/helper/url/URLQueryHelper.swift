//
//  URLQueryHelper.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 19/05/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation

extension URL {
    subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}
