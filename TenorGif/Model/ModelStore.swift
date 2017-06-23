//
//  ModelStore.swift
//  TenorGif
//
//  Created by Paul Ossenbruggen on 6/21/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class ModelStore: NSObject {
    var results: AssetModel? = nil
    @objc dynamic var updated: Bool = false // this is to work around bug in setting results.
    var kvo : NSKeyValueObservation!
    
     func process(_ data: Data) -> CompletionData<AssetModel> {
        let decoder = JSONDecoder()
        do {
            let results = try decoder.decode(AssetModel.self, from: data)
            self.results = results
            self.updated = true
            return CompletionData.success(results)
        } catch let error {
            return CompletionData.error(error)
        }
    }
}
