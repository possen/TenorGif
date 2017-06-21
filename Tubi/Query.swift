//
//  Query.swift
//  Tubi
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation


class Query {
    func query(query: String, limit: Int) -> RESTNetworkRequest {
        let parameters =   ["tag" : query,
                            "key" : "LIVDSRZULELA",
                            "limit": "\(limit)"]
        
        return  RESTNetworkRequest(command: "v1/search", parameters: parameters)
    }
}
