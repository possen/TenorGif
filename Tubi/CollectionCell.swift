//
//  CollectionCell.swift
//  Tubi
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit
//
//  RowCollectionCell.swift
//
//  Created by Paul Ossenbruggen on 2/26/17.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    struct ViewData {
        let index: Int
        let result: AssetModel.Result
    }
    
    var viewData: ViewData? {
        didSet {
            if let viewData = viewData {
                let thumbnailURL = URL(string: viewData.result.media[0].loopedmp4.preview)!
                image.loadImageAtURL(thumbnailURL, index: viewData.index)
            } else {
                image.image = UIImage(named: "Placeholder")
            }
            
            title.text = viewData?.result.title ?? "No name"
        }
    }
}

extension CollectionCell.ViewData {
    init(model: AssetModel.Result, index: Int) {
        self.result = model
        self.index = index
    }
}



