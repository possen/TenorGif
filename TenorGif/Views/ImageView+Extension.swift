//
//  UIImageView+Extensions.swift
//
//  Created by Paul Ossenbruggen on 6/19/17.
//
//

import UIKit

fileprivate let imageCache = Cache<UIImage>(cacheSize: 10_000_000)

extension UIImageView {
    
    func loadImageAtURL(_ urlOrig : URL, index: Int) {
        tag = index
        UIImageView.loadImageAtURLCache(urlOrig, index: index) { (image, url, index) in
            if self.tag == index {
                self.image = image
            }
        }
    }
    
    private static func networkRequest(url: URL, index: Int, completion: @escaping (UIImage, URL, Int) -> Void) {
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("image failed to load \(url)")
                return
            }
            DispatchQueue.global(qos: .userInitiated).async { () -> Void in
                guard let createImage = UIImage(data: data) else { // decode off main thread
                    print("image decoding failed \(url)")
                    return
                }
                DispatchQueue.main.async { () -> Void in
                    completion(createImage, url, index)
                    imageCache.writeCache(url: url, size:data.count, data: createImage)
                }
            }
        }
        task.resume()
    }
    
    private class func loadImageAtURLCache(_ url : URL, index: Int, completion: @escaping (UIImage, URL, Int) -> Void ) {
        if let cacheHit = imageCache.readCache(url: url) {
            completion(cacheHit, url, index)
        } else {
            networkRequest(url: url, index: index, completion: completion)
        }
    }
}



