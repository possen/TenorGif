//
//  AssetModel.swift
//  Tubi
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

// Swift 4 decodable is quite nice.
enum AssetModelError: Error {
    case jsonDecodeError
}

struct AssetModel: Decodable {
    
    struct LoopedMP4: Decodable {
        let url: String
        let preview: String
    }
    
    struct Media: Decodable {
        let loopedmp4: LoopedMP4
    }
    
    struct Result: Decodable {
        let media: [Media]
        let title: String
    }
    
    let results: [Result]
    
    static func process(_ data: (Data)) -> CompletionData<AssetModel> {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(AssetModel.self, from: data)
            return CompletionData.success(result)
        } catch let error {
            return CompletionData.error(error)
        }
    }
}
