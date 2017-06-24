//
//  CollectionViewController.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    var cellCollectionViewAdaptor: CollectionViewAdaptor!
    var cellAdaptorSection: CollectionViewAdaptorSection<CollectionCell, AssetModel.Result>!
    var dataChangedObserverToken: NSKeyValueObservation!
    var modelStore: ModelStore!
    
    override func viewDidLoad() {
        let frame = collectionView?.frame
        
        cellAdaptorSection = CollectionViewAdaptorSection<CollectionCell, AssetModel.Result> (
            cellReuseIdentifier: "CollectionCell",
            cellSize: CGSize(width: frame!.width, height: frame!.width),
            items: [])
        { cell, model, index in
            cell.viewData = CollectionCell.ViewData(model: model, index: index)
        }
        
        cellCollectionViewAdaptor = CollectionViewAdaptor (
            collectionView: collectionView!,
            sections: [cellAdaptorSection]) { [unowned self] in
                self.collectionView?.reloadData()
            }
        
        dataChangedObserverToken = modelStore.observe(\ModelStore.updated) { (object, change) in
            if let results = object.results {
                self.cellAdaptorSection?.items = results.results
            }
            self.cellCollectionViewAdaptor?.update()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let destination = segue.destination as! VideoViewController
            let send = sender as! CollectionCell
            if let indexPath = collectionView?.indexPath(for: send) {
                destination.model = cellAdaptorSection.items[indexPath.row]
            }
        }
    }
}
    

