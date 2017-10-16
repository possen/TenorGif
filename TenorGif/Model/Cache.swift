//
//  Cache
//  TenorGif
//
//  Created by Paul Ossenbruggen on 10/15/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

// simple in-memory cache that will purge oldest if it grows larger than cacheSize
// threadsafe updates to cache structure and does purging in the utilty QOS.
// probably better to purge based upon how big the latest request is, and
// purge as many items as it takes to open up the cache to allocate it.


class Cache<U> {
    let cacheQueue = DispatchQueue(label: "cache", qos: .utility)
    private var cache : [String: (timeCount: Int, size: Int, data: U)] = [:]
    private var timeCount = 0
    private let cacheSize: Int
    
    init(cacheSize: Int) {
        self.cacheSize = cacheSize
    }
    
    fileprivate func purgeCache() {
        cacheQueue.async {
            let size = self.cache.reduce(0) { $0 + $1.value.size }
            if size > self.cacheSize {
                let sortedLRU = self.cache.keys.sorted(by: { (key1, key2) -> Bool in
                    let val1 = self.cache[key1]?.timeCount ?? self.timeCount
                    let val2 = self.cache[key2]?.timeCount ?? self.timeCount
                    return val1 > val2
                })
                if let oldest = sortedLRU.first {
                    NSLog("removing \(oldest)")
                    self.cache[oldest] = nil
                }
            }
        }
    }
    
    func readCache(url : URL) -> U? {
        // must wait for access, if any lower priority tasks
        // block this, those queues will be promoted by GCD to prevent deadlock.
        var image : U? = nil
        cacheQueue.sync {
            image = cache[url.absoluteString]?.data
        }
        return image
    }
    
    func writeCache(url : URL, size: Int, data: U) {
        // update as soon as possible.
        cacheQueue.async {
            self.timeCount += 1
            self.cache[url.absoluteString] = (timeCount: self.timeCount, size:size, data: data)
            self.purgeCache()
        }
    }
}
