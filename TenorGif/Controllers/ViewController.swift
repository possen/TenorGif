//
//  ViewController.swift
//  TenorGif
//
//  Created by Paul Ossenbruggen on 6/21/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var searchAdaptor : SearchAdaptor? = nil
    let query = Query()
    let modelStore = ModelStore()
    var collectionController: CollectionViewController!
    var videoController: VideoViewController!
    var searchController: UISearchController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        searchController = UISearchController(searchResultsController: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchAdaptor = SearchAdaptor(searchView: searchController.searchBar, parentView: view) {
            self.performQuery(query: self.searchController.searchBar.text ?? "")
        }
        
        performQuery(query: "Hello")
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
        let result = modelStore.process(data)
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                guard data.results.count >= 1 else {
                    return
                }
                //collectionController.update()
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
        alert.popoverPresentationController?.sourceView = searchController.searchBar
        self.present(alert, animated: true, completion: {})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collection" {
            collectionController = segue.destination as! CollectionViewController
            collectionController.modelStore = modelStore
            collectionController.searchController = searchController
        } else if segue.identifier == "video" {
            videoController = segue.destination as! VideoViewController
            if let results = modelStore.results?.results, results.count > 0 {
                videoController.model = results[0]
            }
        }
    }
}
