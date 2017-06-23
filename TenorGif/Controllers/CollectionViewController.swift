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
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        let navigationItem = navigationController?.navigationItem
        navigationItem?.searchController = searchController
        
        let headerAdaptorSection = CollectionViewAdaptorSection<SearchCell, Void> (
            cellReuseIdentifier: "SearchCell",
            items: [()])
        { cell, model, index in
            cell.subviews[0].addSubview(self.searchController.searchBar)
        }
        
        cellAdaptorSection = CollectionViewAdaptorSection<CollectionCell, AssetModel.Result> (
            cellReuseIdentifier: "CollectionCell",
            items: [])
        { cell, model, index in
            cell.viewData = CollectionCell.ViewData(model: model, index: index)
        }
        
        cellCollectionViewAdaptor = CollectionViewAdaptor (
            collectionView: collectionView!,
            sections: [headerAdaptorSection, cellAdaptorSection]) { [unowned self] in
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
    

