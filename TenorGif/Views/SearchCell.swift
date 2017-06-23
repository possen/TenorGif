//
//  SearchCell.swift
//  TenorGif
//
//  Created by Paul Ossenbruggen on 6/23/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    struct ViewData {
        let index: Int
    }
    
    var viewData: ViewData? {
        didSet {
            
        }
    }
}

extension SearchCell.ViewData {
    init(model: Void, index: Int) {
        self.index = index
    }
}
