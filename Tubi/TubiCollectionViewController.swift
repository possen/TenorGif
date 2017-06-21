//
//  TubiCollectionViewController.swift
//  Tubi
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class TubiCollectionViewController: UICollectionViewController {
    var cellCollectionViewAdaptor: CollectionViewAdaptor!
    var searchAdaptor : SearchAdaptor? = nil
    let query = Query()
    var cellAdaptorSection: CollectionViewAdaptorSection<CollectionCell, AssetModel.Result>!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        cellAdaptorSection = CollectionViewAdaptorSection<CollectionCell, AssetModel.Result> (
            cellReuseIdentifier: "Cell",
            title: "",
            height: 200,
            items: [])
        { cell, model, index in
            cell.viewData = CollectionCell.ViewData(model: model, index: index)
        }
        
        cellCollectionViewAdaptor = CollectionViewAdaptor (
            collectionView: collectionView!,
            sections: [cellAdaptorSection],
            didChangeHandler: { [unowned self] in
                self.collectionView?.reloadData()
            }
        )
        
        searchAdaptor = SearchAdaptor(searchView: searchBar, parentView: view) {
            self.performQuery(query: self.searchBar.text ?? "")
        }
        
    }
        
    fileprivate func process(_ data: (Data)) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.processInBackground(data)
        }
    }
        
    func performQuery(query: String) {
        return self.query.query(query: query, limit:50).send { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.process(data)
                case .error(let error):
                    self.displayError(error)
                }
            }
        }
    }
    
    fileprivate func processInBackground(_ data: (Data)) {
        let result = AssetModel.process(data)
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                guard data.results.count >= 1 else {
                    return
                }
                self.cellAdaptorSection?.items = data.results
                self.cellCollectionViewAdaptor?.update()
            case .error(let error):
                self.displayError(error)
            }
        }
    }
    
    fileprivate func displayError(_ error: (Error)) {
        print(error)
        let alert = UIAlertController(title: "NetworkError", message: "error \(error)", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {})
        })
        alert.addAction(okAction)
        alert.popoverPresentationController?.sourceView = searchBar
        self.present(alert, animated: true, completion: {})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let destination = segue.destination as! DetailViewController
            let send = sender as! CollectionCell
            if let indexPath = collectionView?.indexPath(for: send) {
                destination.model = cellAdaptorSection.items[indexPath.row]
            }
        }
    }
}
    

